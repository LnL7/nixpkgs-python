self: super:

let
  inherit (self) callPackage recurseIntoAttrs;
in

{
  toplevel = recurseIntoAttrs rec {
    inherit (self) pkgs;
    inherit (pythonPackages) python pythonWith virtualenvWith;

    pythonPackages = recurseIntoAttrs (callPackage ../development/python-modules {
      inherit (self.python27Packages) python virtualenv;
      pip = self.python27Packages.bootstrapped-pip;
    });
  };
}
