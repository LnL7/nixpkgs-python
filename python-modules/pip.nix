{ pythonPlatform, python, stdenv, fetchurl }:

let
  pbr = fetchurl {
    url = https://files.pythonhosted.org/packages/e1/ba/f95e3ec83f93919b1437028e989cf3fa5ff4f5cae4a1f62255f71deddb5b/pbr-4.0.2-py2.py3-none-any.whl;
    sha256 = "4e8a0ed6a8705a26768f4c3da26026013b157821fe5f95881599556ea9d91c19";
  };

  wheel = fetchurl {
    url = https://pypi.python.org/packages/py2.py3/w/wheel/wheel-0.29.0-py2.py3-none-any.whl;
    sha256 = "ea8033fc9905804e652f75474d33410a07404c1a78dd3c949a66863bd1050ebd";
  };

  setuptools = fetchurl {
    url = https://files.pythonhosted.org/packages/8c/10/79282747f9169f21c053c562a0baa21815a8c7879be97abd930dbcf862e8/setuptools-39.1.0-py2.py3-none-any.whl;
    sha256 = "0cb8b8625bfdcc2d43ea4b9cdba0b39b2b7befc04f3088897031082aa16ce186";
  };

  pip = fetchurl {
    url = https://files.pythonhosted.org/packages/ac/95/a05b56bb975efa78d3557efa36acaf9cf5d2fd0ee0062060493687432e03/pip-9.0.3-py2.py3-none-any.whl;
    sha256 = "c3ede34530e0e0b2381e7363aded78e0c33291654937e7373032fda04e8803e5";
  };
in

stdenv.mkDerivation {
  name = "python${pythonPlatform.version}-pip";
  buildInputs = [ python ];

  unpackPhase = ''
    mkdir dist
    ${stdenv.lib.concatMapStringsSep "\n" (src: "ln -s ${src} dist/${src.name}") [ pbr wheel setuptools pip ]}
  '';

  configurePhase = ''
    prefix=$(pwd)/.local

    export HOME=$(pwd)
    export PATH=$prefix/bin:$PATH
    export PYTHONPATH=$prefix/${pythonPlatform.sitePackages}
  '';

  buildPhase = ''
    ${pythonPlatform.python} -m ensurepip --user
  '';

  installPhase = ''
    ${pythonPlatform.pip} install \
        --no-index --ignore-installed --find-links ./dist --prefix $out \
        pbr==4.0.2 wheel==0.29.0 setuptools==39.1.0 pip==9.0.3

    for f in $out/bin/*; do
        substituteInPlace $f \
            --replace "import sys" "import sys; sys.path.append('$out/${pythonPlatform.sitePackages}')"
    done
  '';
}
