{ stdenv, callPackage, self }:

with stdenv.lib;

let

  fakeStdenv = stdenv // {
    lib = stdenv.lib // {
      optional = expr: optional: [{ inherit expr optional; }];
      optionals = expr: optionals: [{ inherit expr optionals; }];
    };
  };

  fakePythonPlatform = self.pythonPlatform // {
    isPython27 = "pythonPlatform.isPython27";
    isPython36 = "pythonPlatform.isPython36";
  };

  fakeScope = {
    stdenv = fakeStdenv;
    pythonPlatform = fakePythonPlatform;
    fetchurl = id;
    mkPythonPackage = id;
  };

  fakeCallPackage = f: attr:
    mapAttrs (n: v: fakeScope.${n} or n) (builtins.functionArgs f);

  pythonCallPackage = f: attr:
    if isFunction f
    then callPackage f (attr // fakeCallPackage f attr)
    else callPackage f attr;

  toJSON = attr: builtins.toJSON (stdenv.lib.filterAttrs (n: v: !isFunction v) attr);

in
  toJSON (self.override {
    configurationCommon = _: self: super: {};
    interpreterConfig = self: super: {};
    versionConfig = self: super: {};
    pythonCallPackage = f: attr: builtins.removeAttrs (pythonCallPackage f attr) ["override" "overrideDerivation"];
  })