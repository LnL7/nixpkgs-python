with import <nixpkgs-python> {};


virtualenvWith {
  buildInputs = [ pkgs.dpkg ];

  packages = pythonPackages: [
    pythonPackages.asn1crypto
    pythonPackages.cffi
    pythonPackages.cryptography
    pythonPackages.enum34
    pythonPackages.idna
    pythonPackages.ipaddress
    pythonPackages.pycparser
    pythonPackages.six
  ];

  installHook = ''
    pip install -e . --no-deps
  '';
}
