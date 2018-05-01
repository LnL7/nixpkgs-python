{ stdenv, config, buildEnv, runCommand, fetchurl, python, virtualenv, coreutils, unzip
, interpreter, packages, pythonPlatform
}:

let
  inherit (interpreter) pip mkPythonWheel;

  isZip = builtins.any (stdenv.lib.hasSuffix ".zip");

  defaultPipFlags = [ "--isolated" "--no-cache-dir" "--disable-pip-version-check" ];

  wheelSrc = fetchurl {
    url = https://pypi.python.org/packages/py2.py3/w/wheel/wheel-0.29.0-py2.py3-none-any.whl;
    sha256 = "1g8f0p8kp1k6kaa3rpbq396401qa84rlsivm5xjlx005k7y3707a";
  };
in

{
  inherit pythonPlatform python;

  pip = runCommand "python${pythonPlatform.version}-pip"
    { nativeBuildInputs = [ unzip ]; buildInputs = [ python ]; }
    ''
      mkdir $out
      ln -s $out .local
      export HOME=$(pwd)
      ${pythonPlatform.python} -m ensurepip --user

      unzip -d $out/${pythonPlatform.sitePackages} ${wheelSrc}

      for f in $out/bin/*; do
          substituteInPlace $f \
              --replace "import sys" "import sys; sys.path.append('$out/${pythonPlatform.sitePackages}')"
      done
    '';

  mkPythonWheel =
    { pname, version, src
    , name ? "wheel-${pythonPlatform.abi}-${pname}-${version}"
    , pipFlags ? defaultPipFlags
    , systemDepends ? [], pythonDepends ? []
    , buildInputs ? [], nativeBuildInputs ? []
    , propagatedBuildInputs ? []
    , ...
    }@attr:
    stdenv.mkDerivation (attr // {
      inherit name pipFlags;

      nativeBuildInputs = stdenv.lib.optional (isZip src.urls) unzip
        ++ nativeBuildInputs;
      buildInputs = [ python pip ] ++ buildInputs;
      propagatedBuildInputs = systemDepends ++ pythonDepends ++ propagatedBuildInputs;

      buildPhase = ''
        runHook preBuild

        ${pythonPlatform.pip} wheel . $pipFlags --no-deps --no-index --wheel-dir ./dist

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r dist $out

        runHook postInstall
      '';

      meta = with stdenv.lib; {
        meta.platforms = platforms.all;
      };
    });

  mkPythonPackage =
    { pname, version, src ? null
    , wheel ? mkPythonWheel (builtins.removeAttrs attr ["wheel"])
    , name ? "python${pythonPlatform.version}-${pname}-${version}"
    , pipFlags ? [ "--ignore-installed" ] ++ defaultPipFlags
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

      fixupPhase = ''
        runHook preFixup

        for f in $out/bin/*; do
            substituteInPlace $f \
                --replace "#!${python}/bin/${pythonPlatform.python}" "#!${coreutils}/bin/env ${pythonPlatform.python}" \
                --replace "import sys" "import sys; sys.path.append('$out/${pythonPlatform.sitePackages}')"
        done

        runHook postFixup
      '';

      passthru.src = wheel;

      meta = with stdenv.lib; {
        meta.platforms = platforms.all;
      };
    };

  virtualenvWith = import ./virtualenv-with.nix {
    inherit stdenv buildEnv python virtualenv interpreter packages pythonPlatform;
  };
}
