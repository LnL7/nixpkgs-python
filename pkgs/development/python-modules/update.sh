#! /usr/bin/env nix-shell
#! nix-shell -i bash -p stdenv.cc -p python27Packages.bootstrapped-pip -p python27Packages.pbr -p python27Packages.setuptools_scm
set -e

declare -a pipArgs=()
if [ -n "$pip_index_url" ]; then pipArgs+=(--index-url "$pip_index_url"); fi
if [ -n "$pip_trusted_host" ]; then pipArgs+=(--trusted-host "$pip_trusted_host"); fi

cachePackages() {
  local attr out
  local cache="$1"
  shift 1

  for pkg in $(cat); do
    case "$pkg" in
      *==*)
        attr=${pkg,,}
        attr=${attr//==/_}
        attr=${attr//[-.]/_}

        out=$(nix-build -A "$attr.src" --no-out-link) || true
        if [ -e "$out" ]; then
          ln -sfn "$attr.src" "$cache/${out#*-}"
        fi
      ;;
    esac
  done
}

downloadPackages() {
  local cache
  cache=$PWD/cache
  mkdir -p "$cache"

  if [ "$1" = -r ]; then
    cachePackages "$cache" < "$2"
  fi

  pip download "$@" -d "$cache" -f "$cache" --no-binary :all: "${pipArgs[@]}" >&2
  cd "$cache"
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
  pname=${pname//[-.]/_}

  echo "  ${pname} = ${attr};"
}

main() {
  local result="$PWD/result"
  rm -r result pip-cache-* 2> /dev/null || true
  mkdir -p "$result"

  downloadPackages "$@"

  echo "===============================" >&2
  for file in *; do
    echo | tee -a "$result/pypi-packages"
    printExpression "$file" | tee -a "$result/pypi-packages"
  done

  echo
  echo "===============================" >&2
  echo

  for file in *; do
    printVersion "$file" | tee -a "$result/versions"
  done
}

main "$@"
