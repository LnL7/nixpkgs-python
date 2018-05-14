{ lib }:

with lib;

{
  overrideWithPackages = drv: withPackages: drv.override {
    python = drv.pythonScope.pythonWithPackages withPackages;
  };
}
