self: super:

let
  pythonng = import ./pkgs/top-level/python-packages.nix {
    inherit (super) pkgs stdenv callPackage recurseIntoAttrs;
    pythonng = self.pythonng;
  };
in

{
  pythonng = super.pythonng or {} // pythonng // {
    interpreter = super.pythonng.interpreter or {} // pythonng.interpreter;
    packages = super.pythonng.packages or {} // pythonng.packages;
  };
}
