{ stdenv, callPackage, pythonScope }:

with stdenv.lib;

let

  fakeStdenv = stdenv // {
    isDarwin = "stdenv.isDarwin";
    isLinux = "stdenv.isLinux";

    lib = stdenv.lib // {
      licenses = mapAttrs (n: v: n) stdenv.lib.licenses;
      platforms = mapAttrs (n: v: [n]) stdenv.lib.platforms;
      optional = expr: optional: [{ inherit expr optional; }];
      optionals = expr: optionals: [{ inherit expr optionals; }];
    };
  };

  fakePython = {
    mkDerivation = id;
  };

  fakePythonPlatform = pythonScope.pythonPlatform // {
    isPython27 = "pythonPlatform.isPython27";
    isPython36 = "pythonPlatform.isPython36";

    python27 = ["python27"];
    python36 = ["python36"];
  };

  fakeScope = {
    fetchurl = id;
    python = fakePython;
    pythonPlatform = fakePythonPlatform;
    stdenv = fakeStdenv;

    mkPythonPackage = id;  # removed
  };

  fakeCallPackage = f: attr:
    mapAttrs (n: v: fakeScope.${n} or n) (builtins.functionArgs f);

  pythonCallPackage = f: attr:
    if isFunction f
    then callPackage f (attr // fakeCallPackage f attr)
    else callPackage f attr;

  toValue = attr: filterAttrs (n: v: !isFunction v && !isDerivation v) attr;

in
  toValue (pythonScope.override {
    configurationCommon = _: self: super: {};
    interpreterConfig = self: super: {};
    versionConfig = self: super: {};
    pythonCallPackage = f: attr: builtins.removeAttrs (pythonCallPackage f attr) ["override" "overrideDerivation"];
    pythonPlatform = fakePythonPlatform;
    stdenv = fakeStdenv;
  })