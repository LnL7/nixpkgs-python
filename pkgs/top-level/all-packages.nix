self: super:

let
  inherit (self) callPackage recurseIntoAttrs;
  inherit (self.stdenv.lib) filterAttrs mapAttrs;

  getWheel = _: drv: let res = builtins.tryEval drv.wheel or {}; in if res.success then res.value else {};
  mapWheels = attrs: filterAttrs (_: v: v != {}) (mapAttrs getWheel attrs);
in

{
  toplevel = recurseIntoAttrs rec {
    inherit (self) pkgs;
    inherit (pythonPackages) python pythonWith virtualenvWith;

    pythonSources = mapAttrs (_: v: v.src) self.toplevel.pythonWheels;
    pythonWheels = mapWheels self.toplevel.pythonPackages;

    pythonPackages = recurseIntoAttrs (callPackage ../development/python-modules {
      inherit (self.python27Packages) python virtualenv;
      pip = self.python27Packages.bootstrapped-pip;
    });
  };
}
