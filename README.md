# Nixpkgs Pythonng

Nix infrastructure and expression generator for python packages.

Goals:
- autogenerated pypi-packages.nix
- avoid PYTHONPATH


## Generating packages

Generate a full pypi-packages.nix expression.

```sh
pypi2nix -r requirements.txt
```

The generated expressions will include overrides from `index/cffi/overrides.json`,
this is useful for eg. system dependencies like libffi.

```sh
pip2nix cffi==1.11.5
```

If the dist-info generation fails it can be skipped, however this
requires specifying the dependencies manually (or using overrides).

```sh
pip2nix --no-dist-info --python-depends pycparser cffi==1.11.5
```

## Git sources

For custom packages that are not available on pypi a git source can be used.
This also works with local paths to a git repository for development.

> NOTE only use this for your own packages.

```sh
pip2nix --git-url ssh://git@github.com/LnL7/python-hello.git hello
```

## Python environments

An interpreter with packages.

```nix
with pythonng.packages.cpython36;

pythonWithPackages (p: with p; [
  cryptography
  lxml
  pyyaml
])
```

Extending a package (binary) with extra dependencies.

```nix
with pythonng.packages.cpython36;

ipython.override {
  python = pythonWithPackages (p: with p; [
    pyyaml
  ]);
}
```

Overriding the default version of a package.

```nix
let
  pkgs = pythonng.packages.cpython36.override {
    overrides = self: super: {
      pycparser = self.pycparser_2_14;
    };
  };
in

pkgs.cffi
```
