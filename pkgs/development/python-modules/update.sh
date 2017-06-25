#! /usr/bin/env nix-shell
#! nix-shell -i bash -p python27Packages.bootstrapped-pip -p python27Packages.pbr -p python27Packages.setuptools_scm
set -e

declare -a pipArgs=()
if [ -n "$pip_index_url" ]; then pipArgs+=(--index-url "$pip_index_url"); fi
if [ -n "$pip_trusted_host" ]; then pipArgs+=(--trusted-host "$pip_trusted_host"); fi

downloadPackages() {
  pip download "$@" -d cache -f cache --no-binary :all: "${pipArgs[@]}" >&2
  cd cache
}

printExpression() {
  local attr args ext pname version sha256
  local file="$1"
  shift 1

  attr=${file,,}
  attr=${attr%%.[^0-9]*}
  attr=${attr//[-.]/_}
  pname=${file%-*}
  version=${file}
  version=${version##*-}
  version=${version%%.[^0-9]*}
  ext=${file}
  ext=${ext##*[0-9].}
  ext=${ext//./}
  sha256=$(shasum -a256 "$file" | awk '{print $1}')

  if [ "$ext" != targz ]; then
    args=", types"
  fi

  cat <<-EONIX
  ${attr} = callPackage
    ({ mkDerivation${args} }:
     mkDerivation {
       pname = "${pname}";
       version = "${version}";
       sha256 = "${sha256}";
EONIX

  if [ "$ext" != targz ]; then
    echo "       type = types.${ext};"
  fi
  echo "     }) {};"
}

printVersion() {
  local attr args ext pname version sha256
  local file="$1"
  shift 1

  attr=${file,,}
  attr=${attr%%.[^0-9]*}
  attr=${attr//[-.]/_}
  pname=${file,,}
  pname=${pname%-*}

  echo "  ${pname} = ${attr};"
}

main() {
  downloadPackages "$@"

  for file in *; do
    echo
    printExpression "$file"
  done

  echo
  echo

  for file in *; do
    printVersion "$file"
  done
}

main "$@"
