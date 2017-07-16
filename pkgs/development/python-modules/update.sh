#! /usr/bin/env nix-shell
#! nix-shell -i bash -p stdenv.cc -p python27Packages.bootstrapped-pip -p python27Packages.pbr -p python27Packages.setuptools_scm
set -e

declare -a pipArgs
if [ -n "$pip_index_url" ]; then pipArgs+=(--index-url $pip_index_url); fi
if [ -n "$pip_trusted_host" ]; then pipArgs+=(--trusted-host $pip_trusted_host); fi

cachePackages() {
  local root=$PWD

  mkdir -p cache gcroots

  for f in $(cd gcroots; nix-build "$root" -A pythonSources); do
    ln -sfn "$f" "cache/${f#*-}"
  done
}

downloadPackages() {
  local -a pkgs
  mkdir -p cache

  while (($#)); do
    case $1 in
      -r)
        downloadPackages "$(cat "$2")"
        shift 2
        ;;
      *==*)
        if ! find cache -type f -iname "${1//==/-}.*"; then
          pkgs+=($1)
        fi
        shift
        ;;
      *)
        pkgs+=($1)
        shift
        ;;
    esac
  done

  for p in "${pkgs[@]}"; do
    pip download "$p" -d cache -f cache --no-binary :all: "${pipArgs[@]}" >&2
  done
}

printExpression() {
  local attr args ext pname version sha256
  local file="$1"
  shift 1

  attr=${file,,}
  attr=${attr%.[^0-9]*}
  attr=${attr%.[^0-9]*}
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

main() {
  cachePackages "$@"
  downloadPackages "$@"

  echo | tee generated-packages.nix
  for f in cache/*; do
    printExpression "${f##*/}" | tee -a generated-packages.nix
    echo | tee -a generated-packages.nix
  done
}

main "$@"
