{ stdenv, writeText, pip }:

{ pname
, version
, sha256
, type ? "tar.gz"
, name ? "${pname}-${version}.${type}"
}:

stdenv.mkDerivation {
  inherit name version;
  phases = [ "unpackPhase" "installPhase" ];

  impureEnvVars = [ "pip_index_url" "pip_trusted_host" ];

  outputHash = sha256;
  outputHashAlgo = "sha256";

  unpackPhase = ''
    declare -a pipArgs=()
    if [ -n "$pip_index_url" ]; then pipArgs+=(--index-url "$pip_index_url"); fi
    if [ -n "$pip_trusted_host" ]; then pipArgs+=(--trusted-host "$pip_trusted_host"); fi

    ${pip}/bin/pip download '${pname}==${version}' -d . --no-binary :all: --no-cache-dir --no-deps "''${pipArgs[@]}" || true
  '';

  installPhase = ''
    cp ${name} $out
  '';
}
