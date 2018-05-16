{ pkgs, stdenv, coreutils, python, pip, pythonPlatform, pythonScope, pipHook, mkPythonWheel }:

let
  checkPython = stdenv.lib.any (x: stdenv.lib.matchAttrs x pythonPlatform);
in

{ pname, version, src ? null
, name ? "python${pythonPlatform.version}-${pname}-${version}"
, meta ? {}
, info ? wheel.info
, wheel ? mkPythonWheel (builtins.removeAttrs attr ["wheel"])
, dontPipCheck ? false, pipCheckFlags ? []
, pipFlags ? [], pipInstallFlags ? [ "--ignore-installed" ]
, systemDepends ? [], pythonDepends ? []
, nativeBuildInputs ? [], propagatedNativeBuildInputs ? []
, buildInputs ? [], propagatedBuildInputs ? []
, postFixup ? ""
, ... }@attr:

stdenv.mkDerivation {
  inherit name pname version wheel;
  inherit systemDepends pythonDepends;
  src = wheel;

  inherit dontPipCheck pipCheckFlags;
  pipFlags = [ "--isolated" "--no-cache-dir" "--disable-pip-version-check" ] ++ pipFlags;
  pipInstallFlags = [ "--no-deps" "--no-index" ] ++ pipInstallFlags;

  nativeBuildInputs = [ pipHook ] ++ nativeBuildInputs;
  buildInputs = [ pip ] ++ buildInputs;
  propagatedBuildInputs = [ python ] ++ systemDepends ++ propagatedBuildInputs;

  installPhase = ''
    runHook preInstall

    ${pythonPlatform.pip} install '${pname}==${version}' $pipFlags $pipInstallFlags --find-links ./dist --prefix $out

    for dep in $pythonDepends; do
        for f in $dep/${pythonPlatform.sitePackages}/*; do
            name=''${f##*/}
            l=$out/${pythonPlatform.sitePackages}/$name
            if [ "$name" = __pycache__ ]; then
                continue
            fi
            if [ "$(readlink -f $f)" = "$(readlink -f $l)" ]; then
                continue
            fi
            if ! ln -s "$f" "$l"; then
                echo
                echo "error: conflicting dependency '$name' in"
                echo "  $(readlink -f $f)"
                echo "  $(readlink -f $l)"
                echo
                false
            fi
        done
    done

    rm -rf $out/bin/__pycache__

    runHook postInstall
  '';

  postFixup = ''
    for f in $out/bin/*; do
        substituteInPlace $f \
            --replace "import sys" "import sys; sys.path.append('$out/${pythonPlatform.sitePackages}')"
    done
  '' + postFixup;

  passthru = { inherit info src pythonScope; };

  meta = with stdenv.lib; {
    platforms = platforms.all;
    broken = !checkPython (meta.python or [{}]);
  } // meta;
}
