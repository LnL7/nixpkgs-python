# Nixpkgs Pythonng

Nix infrastructure and expression generator for python packages.


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
pip2nix --no-dist-info psycopg2==2.7.4
```
