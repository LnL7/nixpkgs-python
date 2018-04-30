{ pkgs, config, pythonPlatform, python, stdenv, runCommand, fetchurl }:

let
  isZip = builtins.any (stdenv.lib.hasSuffix ".zip");

  defaultPipFlags = [ "--isolated" "--no-cache-dir" "--disable-pip-version-check" ];

  wheelSrc = fetchurl {
    url = https://pypi.python.org/packages/py2.py3/w/wheel/wheel-0.29.0-py2.py3-none-any.whl;
    sha256 = "1g8f0p8kp1k6kaa3rpbq396401qa84rlsivm5xjlx005k7y3707a";
  };
in

rec {
  inherit pythonPlatform python;

  pip = runCommand "python${pythonPlatform.version}-pip"
    { nativeBuildInputs = [ pkgs.unzip ]; buildInputs = [ python ]; }
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

      nativeBuildInputs = stdenv.lib.optional (isZip src.urls) pkgs.unzip
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

      buildInputs = [ python pip ] ++ buildInputs;
      propagatedBuildInputs = systemDepends ++ pythonDepends ++ propagatedBuildInputs;

      installPhase = ''
        runHook preInstall

        ${pythonPlatform.pip} install '${pname}==${version}' $pipFlags --no-deps --no-index --find-links ./dist --prefix $out

        for dep in $pythonDepends; do
            for f in $dep/${pythonPlatform.sitePackages}/*; do
                name=''${f##*/}
                l=$out/${pythonPlatform.sitePackages}/$name
                if [ -L "$link" -a "$(readlink -f $f)" = "$(readlink -f $l)" ]; then
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

        for f in $out/bin/*; do
            substituteInPlace $f \
                --replace "import sys" "import sys; sys.path.append('$out/${pythonPlatform.sitePackages}')"
        done

        runHook postInstall
      '';

      passthru.src = wheel;

      meta = with stdenv.lib; {
        meta.platforms = platforms.all;
      };
    };
}
