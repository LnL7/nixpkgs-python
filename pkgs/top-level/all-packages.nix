self: super:

let
  inherit (super) callPackage;
in

{
  toplevel = callPackage ../development/python-modules {
    inherit (self.python27Packages) python virtualenv;
    pip = self.python27Packages.bootstrapped-pip;
  };
}
