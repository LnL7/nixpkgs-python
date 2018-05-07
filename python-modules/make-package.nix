{ pkgs, stdenv, coreutils, python, pip, pythonPlatform, mkPythonWheel }:

{ pname, version, src ? null
, name ? "python${pythonPlatform.version}-${pname}-${version}"
, meta ? {}
, info ? wheel.info
, wheel ? mkPythonWheel (builtins.removeAttrs attr ["wheel"])
, pipFlags ? [ "--ignore-installed" ]
, systemDepends ? [], pythonDepends ? []
, buildInputs ? [], propagatedBuildInputs ? []
, ... }@attr:

stdenv.mkDerivation {
  inherit name pname version wheel;
  inherit systemDepends pythonDepends;
  src = wheel;

  pipFlags = [ "--isolated" "--no-cache-dir" "--no-deps" "--no-index" ] ++ pipFlags;

  buildInputs = [ pip ] ++ buildInputs;
  propagatedBuildInputs = [ python ] ++ systemDepends ++ pythonDepends ++ propagatedBuildInputs;

  installPhase = ''
    runHook preInstall

    # Determinism: The interpreter is patched to write null timestamps when compiling python files.
    # This way python doesn't try to update them when we freeze timestamps in nix store.
    export DETERMINISTIC_BUILD=1;
    # Determinism: We fix the hashes of str, bytes and datetime objects.
    export PYTHONHASHSEED=0;
    # Determinism. Whenever Python is included, it should not check user site-packages.
    # This option is only relevant when the sandbox is disabled.
    export PYTHONNOUSERSITE=1;

    ${pythonPlatform.pip} install '${pname}==${version}' $pipFlags --find-links ./dist --prefix $out

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
  '';

  passthru = { inherit info src pip; };

  meta = with stdenv.lib; {
    platforms = platforms.all;
  } // meta;
}
