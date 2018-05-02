{ pkgs, stdenv, coreutils, python, pip, pythonPlatform, mkPythonWheel }:

{ pname, version, src ? null
, wheel ? mkPythonWheel (builtins.removeAttrs attr ["wheel"])
, name ? "python${pythonPlatform.version}-${pname}-${version}"
, pipFlags ? [ "--ignore-installed" "--isolated" "--no-cache-dir" "--disable-pip-version-check" ]
, systemDepends ? [], pythonDepends ? []
, buildInputs ? [], propagatedBuildInputs ? []
, ... }@attr:

stdenv.mkDerivation {
  inherit name pname version wheel pipFlags;
  inherit systemDepends pythonDepends;
  src = wheel;

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

    ${pythonPlatform.pip} install '${pname}==${version}' $pipFlags --no-deps --no-index --find-links ./dist --prefix $out

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

    runHook postInstall
  '';

  postFixup = ''
    for f in $out/bin/*; do
        substituteInPlace $f \
            --replace "#!${python}/bin/${pythonPlatform.python}" "#!${coreutils}/bin/env ${pythonPlatform.python}" \
            --replace "import sys" "import sys; sys.path.append('$out/${pythonPlatform.sitePackages}')"
    done
  '';

  passthru.src = wheel;

  meta = with stdenv.lib; {
    meta.platforms = platforms.all;
  };
}