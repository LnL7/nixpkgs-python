{ stdenv, callPackage }:

with stdenv.lib;

let
  pythonScope = (fakeImport ../.. {}).pythonng.packages.cpython36;

  fakeImport = builtins.scopedImport { builtins = fakeBuiltins; import = fakeImport; };

  fakeBuiltins = builtins.builtins // {
    fetchGit = args: args // builtins.removeAttrs (builtins.fetchGit args) ["outPath"];
  };

  fakeStdenv = stdenv // {
    isDarwin = "stdenv.isDarwin";
    isLinux = "stdenv.isLinux";

    cc = stdenv.cc // {
      isClang = "stdenv.cc.isClang";
      isGNU = "stdenv.cc.isGNU";
    };

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

  fakeDerivation = outPath:
    let
      out = { inherit out dev outPath; };
      bin = { inherit out bin dev lib man doc; outPath = "${outPath}.bin"; };
      dev = { inherit out bin dev lib man doc; outPath = "${outPath}.dev"; };
      lib = { inherit out bin dev lib man doc; outPath = "${outPath}.lib"; };
      man = { inherit out bin dev lib man doc; outPath = "${outPath}.man"; };
      doc = { inherit out bin dev lib man doc; outPath = "${outPath}.doc"; };
    in out;

  fakeScope = {
    fetchurl = id;
    python = fakePython;
    pythonPlatform = fakePythonPlatform;
    stdenv = fakeStdenv;

    mkPythonPackage = id;  # removed
  };

  fakeCallPackage = f: attr:
    mapAttrs (n: v: fakeScope.${n} or (fakeDerivation n)) (builtins.functionArgs f);

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
