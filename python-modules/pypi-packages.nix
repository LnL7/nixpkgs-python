{ pkgs, callPackage }:

self:

{
  setuptools_39_0_1 = callPackage
    ({ mkPythonPackage, pythonPlatform, stdenv, fetchurl }:
     mkPythonPackage {
       pname = "setuptools";
       version = "39.0.1";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/72/c2/c09362ab29338413ab687b47dab03bab4a792e2bbb727a1eb5e0a88e3b86/setuptools-39.0.1.zip";
         sha256 = "bec7badf0f60e7fc8153fac47836edc41b74e5d541d7692e614e635720d6a7c7";
       };
       meta = with stdenv.lib; {
         description = "Easily download, build, install, upgrade, and uninstall Python packages";
         homepage = "https://github.com/pypa/setuptools";
         license = licenses.mit;
       };
     }) {};
  pbr_4_0_2 = callPackage
    ({ mkPythonPackage, pythonPlatform, stdenv, fetchurl }:
     mkPythonPackage {
       pname = "pbr";
       version = "4.0.2";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/c6/46/f414e7d9ba9621c8acd3e7a82e08c47e0de34ad3e213c16e458b6c04d432/pbr-4.0.2.tar.gz";
         sha256 = "dae4aaa78eafcad10ce2581fc34d694faa616727837fd8e55c1a00951ad6744f";
       };
       meta = with stdenv.lib; {
         description = "Python Build Reasonableness";
         homepage = "https://docs.openstack.org/pbr/latest/";
       };
     }) {};
}
