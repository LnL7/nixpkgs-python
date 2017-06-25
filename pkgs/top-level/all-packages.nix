self: super:

let
  inherit (super) callPackage;
in

{
  toplevel = rec {
    inherit (self) pkgs;
    inherit (pythonPackages) virtualenvWith;

    pythonPackages = callPackage ../development/python-modules {
      inherit (self.python27Packages) python virtualenv;
      pip = self.python27Packages.bootstrapped-pip;
    };
  };
}
