self: super:

let
  inherit (super) callPackage;
in

{
  toplevel = super.recurseIntoAttrs rec {
    inherit (self) pkgs;
    inherit (pythonPackages) python pythonWith virtualenvWith;

    pythonPackages = super.recurseIntoAttrs (callPackage ../development/python-modules {
      inherit (self.python27Packages) python virtualenv;
      pip = self.python27Packages.bootstrapped-pip;
    });
  };
}
