{ stdenv, types, writeText, pip }:

{ pname
, version
, sha256
, type ? types.targz
, name ? "${pname}-${version}.${type}"
}:

let
  unlessWheel = stdenv.lib.optionalString (type != types.whl);
in

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

    ${pip}/bin/pip download '${pname}==${version}' ${unlessWheel "--no-binary :all:"} -d . --no-cache-dir --no-deps "''${pipArgs[@]}" || true
  '';

  installPhase = ''
    cp ${name} $out
  '';
}
