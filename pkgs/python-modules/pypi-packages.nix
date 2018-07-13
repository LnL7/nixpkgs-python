{ pkgs, callPackage }:

self:

{
  packaging_16_8 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, pyparsing, six }:
     python.mkDerivation {
       pname = "packaging";
       version = "16.8";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz";
         sha256 = "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e";
       };
       pythonDepends = [ pyparsing six ];
       meta = with stdenv.lib; {
         description = "Core utilities for Python packages";
         homepage = "https://github.com/pypa/packaging";
         license = licenses.asl20;
       };
     }) { };

  functools32_3_2_3-2 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "functools32";
       version = "3.2.3-2";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db/functools32-3.2.3-2.tar.gz";
         sha256 = "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d";
       };
       meta = with stdenv.lib; {
         description = "Backport of the functools module from Python 3.2.3 for use on 2.7 and PyPy.";
         homepage = "https://github.com/MiCHiLU/python-functools32";
         license = licenses.psfl;
       };
     }) { };

  monotonic_1_5 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "monotonic";
       version = "1.5";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/19/c1/27f722aaaaf98786a1b338b78cf60960d9fe4849825b071f4e300da29589/monotonic-1.5.tar.gz";
         sha256 = "23953d55076df038541e648a53676fb24980f7a1be290cdda21300b3bc21dfb0";
       };
       meta = with stdenv.lib; {
         description = "An implementation of time.monotonic() for Python 2 & < 3.3";
         homepage = "https://github.com/atdt/monotonic";
         license = licenses.asl20;
       };
     }) { };

  msgpack_0_5_6 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "msgpack";
       version = "0.5.6";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/f3/b6/9affbea179c3c03a0eb53515d9ce404809a122f76bee8fc8c6ec9497f51f/msgpack-0.5.6.tar.gz";
         sha256 = "0ee8c8c85aa651be3aa0cd005b5931769eaa658c948ce79428766f1bd46ae2c3";
       };
       meta = with stdenv.lib; {
         description = "MessagePack (de)serializer.";
         homepage = "http://msgpack.org/";
         license = licenses.asl20;
       };
     }) { };

  pyperclip_1_6_2 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "pyperclip";
       version = "1.6.2";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/33/15/f3c29b381815ae75e27589583655f4a8567721c541b8ba8cd52f76868655/pyperclip-1.6.2.tar.gz";
         sha256 = "43496f0a1f363a5ecfc4cda5eba6a2a3d5056fe6c7ffb9a99fbb1c5a3c7dea05";
       };
       meta = with stdenv.lib; {
         description = "A cross-platform clipboard module for Python. (Only handles plain text for now.)";
         homepage = "https://github.com/asweigart/pyperclip";
         license = licenses.bsd3;
       };
     }) { };

  wcwidth_0_1_7 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "wcwidth";
       version = "0.1.7";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz";
         sha256 = "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e";
       };
       meta = with stdenv.lib; {
         description = "Measures number of Terminal column cells of wide-character codes";
         homepage = "https://github.com/jquast/wcwidth";
         license = licenses.mit;
       };
     }) { };

  netaddr_0_7_19 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "netaddr";
       version = "0.7.19";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/0c/13/7cbb180b52201c07c796243eeff4c256b053656da5cfe3916c3f5b57b3a0/netaddr-0.7.19.tar.gz";
         sha256 = "38aeec7cdd035081d3a4c306394b19d677623bf76fa0913f6695127c7753aefd";
       };
       meta = with stdenv.lib; {
         description = "A network address manipulation library for Python";
         homepage = "https://github.com/drkjam/netaddr/";
         license = licenses.bsd3;
       };
     }) { };

  os-service-types_1_2_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, pbr }:
     python.mkDerivation {
       pname = "os_service_types";
       version = "1.2.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/b3/22/1d0a1f5fd633fdbdff3ac1191f95773e3277d1138e4cee09a891c9ee51aa/os-service-types-1.2.0.tar.gz";
         sha256 = "b08fb4ec1249d313afea2728fa4db916b1907806364126fe46de482671203111";
       };
       pythonDepends = [ pbr ];
       meta = with stdenv.lib; {
         description = "Python library for consuming OpenStack sevice-types-authority data";
         homepage = "http://www.openstack.org/";
       };
     }) { };

  enum34_1_1_6 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "enum34";
       version = "1.1.6";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz";
         sha256 = "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1";
       };
       meta = with stdenv.lib; {
         description = "Python 3.4 Enum backported to 3.3, 3.2, 3.1, 2.7, 2.6, 2.5, and 2.4";
         homepage = "https://bitbucket.org/stoneleaf/enum34";
         license = licenses.bsd3;
         python = pythonPlatform.python27;
       };
     }) { };

  python-keystoneclient_3_17_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, debtcollector, keystoneauth1, oslo-config, oslo-i18n, oslo-serialization, oslo-utils, pbr, requests, six, stevedore }:
     python.mkDerivation {
       pname = "python_keystoneclient";
       version = "3.17.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/f0/b4/f918f4873f1a3d4f7a00e874cddcc1bb67dc5ec1ce58166d96d42738d8fe/python-keystoneclient-3.17.0.tar.gz";
         sha256 = "7fb770e194760fa3508e758e6ad316fc55d5b4ff97aa688867ef50f62f687624";
       };
       pythonDepends = [ debtcollector keystoneauth1 oslo-config oslo-i18n oslo-serialization oslo-utils pbr requests six stevedore ];
       meta = with stdenv.lib; {
         description = "Client Library for OpenStack Identity";
         homepage = "https://docs.openstack.org/python-keystoneclient/latest/";
       };
     }) { };

  chardet_3_0_4 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "chardet";
       version = "3.0.4";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz";
         sha256 = "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae";
       };
       meta = with stdenv.lib; {
         description = "Universal encoding detector for Python 2 and 3";
         homepage = "https://github.com/chardet/chardet";
         license = licenses.lgpl3;
       };
     }) { };

  netifaces_0_10_7 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "netifaces";
       version = "0.10.7";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/81/39/4e9a026265ba944ddf1fea176dbb29e0fe50c43717ba4fcf3646d099fe38/netifaces-0.10.7.tar.gz";
         sha256 = "bd590fcb75421537d4149825e1e63cca225fd47dad861710c46bd1cb329d8cbd";
       };
       meta = with stdenv.lib; {
         description = "Portable network interface information.";
         homepage = "https://github.com/al45tair/netifaces";
         license = licenses.mit;
       };
     }) { };

  osc-lib_1_11_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, babel, cliff, keystoneauth1, openstacksdk, oslo-i18n, oslo-utils, pbr, simplejson, six, stevedore }:
     python.mkDerivation {
       pname = "osc_lib";
       version = "1.11.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/d2/4a/85f07a320b6c76b68cc43161bd7bcfa66af8d016e3b37a14108dd7a7ff2e/osc-lib-1.11.0.tar.gz";
         sha256 = "2cb8fb0e170bdf9f230911bf81e7cb3b488e469365e8b9495ad7291b90b4cb25";
       };
       pythonDepends = [ babel cliff keystoneauth1 openstacksdk oslo-i18n oslo-utils pbr simplejson six stevedore ];
       meta = with stdenv.lib; {
         description = "OpenStackClient Library";
         homepage = "https://docs.openstack.org/osc-lib/latest/";
       };
     }) { };

  requestsexceptions_1_4_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "requestsexceptions";
       version = "1.4.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz";
         sha256 = "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065";
       };
       meta = with stdenv.lib; {
         description = "Import exceptions from potentially bundled packages in requests.";
         homepage = "http://www.openstack.org/";
       };
     }) { };

  futures_3_2_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "futures";
       version = "3.2.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/1f/9e/7b2ff7e965fc654592269f2906ade1c7d705f1bf25b7d469fa153f7d19eb/futures-3.2.0.tar.gz";
         sha256 = "9ec02aa7d674acb8618afb127e27fde7fc68994c0437ad759fa094a574adb265";
       };
       meta = with stdenv.lib; {
         description = "Backport of the concurrent.futures package from Python 3";
         homepage = "https://github.com/agronholm/pythonfutures";
         license = licenses.psfl;
       };
     }) { };

  iso8601_0_1_12 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "iso8601";
       version = "0.1.12";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/45/13/3db24895497345fb44c4248c08b16da34a9eb02643cea2754b21b5ed08b0/iso8601-0.1.12.tar.gz";
         sha256 = "49c4b20e1f38aa5cf109ddcd39647ac419f928512c869dc01d5c7098eddede82";
       };
       meta = with stdenv.lib; {
         description = "Simple module to parse ISO 8601 dates";
         homepage = "https://bitbucket.org/micktwomey/pyiso8601";
         license = licenses.mit;
       };
     }) { };

  pycparser_2_18 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "pycparser";
       version = "2.18";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz";
         sha256 = "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226";
       };
       meta = with stdenv.lib; {
         description = "C parser in Python";
         homepage = "https://github.com/eliben/pycparser";
         license = licenses.bsd3;
       };
     }) { };

  decorator_4_3_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "decorator";
       version = "4.3.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/6f/24/15a229626c775aae5806312f6bf1e2a73785be3402c0acdec5dbddd8c11e/decorator-4.3.0.tar.gz";
         sha256 = "c39efa13fbdeb4506c476c9b3babf6a718da943dab7811c206005a4a956c080c";
       };
       meta = with stdenv.lib; {
         description = "Better living through Python with decorators";
         homepage = "https://github.com/micheles/decorator";
         license = licenses.bsd3;
       };
     }) { };

  pyopenssl_17_5_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, cryptography, six }:
     python.mkDerivation {
       pname = "pyOpenSSL";
       version = "17.5.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/3b/15/a5d90ab1a41075e8f0fae334f13452549528f82142b3b9d0c9d86ab7178c/pyOpenSSL-17.5.0.tar.gz";
         sha256 = "2c10cfba46a52c0b0950118981d61e72c1e5b1aac451ca1bc77de1a679456773";
       };
       pythonDepends = [ cryptography six ];
       meta = with stdenv.lib; {
         description = "Python wrapper module around the OpenSSL library";
         homepage = "https://pyopenssl.org/";
         license = licenses.asl20;
       };
     }) { };

  pyparsing_2_1_10 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "pyparsing";
       version = "2.1.10";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/38/bb/bf325351dd8ab6eb3c3b7c07c3978f38b2103e2ab48d59726916907cd6fb/pyparsing-2.1.10.tar.gz";
         sha256 = "811c3e7b0031021137fc83e051795025fcb98674d07eb8fe922ba4de53d39188";
       };
       meta = with stdenv.lib; {
         description = "Python parsing module";
         homepage = "http://pyparsing.wikispaces.com/";
         license = licenses.mit;
       };
     }) { };

  warlock_1_3_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, jsonpatch, jsonschema, six }:
     python.mkDerivation {
       pname = "warlock";
       version = "1.3.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/2d/40/9f01a5e1574dab946598793351d59c86f58209d182d229aaa545abb98894/warlock-1.3.0.tar.gz";
         sha256 = "d7403f728fce67ee2f22f3d7fa09c9de0bc95c3e7bcf6005b9c1962b77976a06";
       };
       pythonDepends = [ jsonpatch jsonschema six ];
       meta = with stdenv.lib; {
         description = "Python object model built on JSON schema and JSON patch.";
         homepage = "http://github.com/bcwaldon/warlock";
       };
     }) { };

  cryptography_2_2_2 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, openssl, asn1crypto, idna, six, cffi, enum34, ipaddress }:
     python.mkDerivation {
       pname = "cryptography";
       version = "2.2.2";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/ec/b2/faa78c1ab928d2b2c634c8b41ff1181f0abdd9adf9193211bd606ffa57e2/cryptography-2.2.2.tar.gz";
         sha256 = "9fc295bf69130a342e7a19a39d7bbeb15c0bcaabc7382ec33ef3b2b7d18d2f63";
       };
       systemDepends = [ openssl ];
       pythonDepends = [ asn1crypto idna six cffi ]
         ++ stdenv.lib.optionals pythonPlatform.isPython27 [ enum34 ipaddress ];
       meta = with stdenv.lib; {
         description = "cryptography is a package which provides cryptographic recipes and primitives to Python developers.";
         homepage = "https://github.com/pyca/cryptography";
         license = licenses.asl20;
       };
     }) { };

  dogpile-cache_0_6_6 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "dogpile.cache";
       version = "0.6.6";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/48/ca/604154d835c3668efb8a31bd979b0ea4bf39c2934a40ffecc0662296cb51/dogpile.cache-0.6.6.tar.gz";
         sha256 = "044d4ea0a0abc72491044f3d3df8e1fc9e8fa7a436c6e9a0da5850d23a0d16c1";
       };
       meta = with stdenv.lib; {
         description = "A caching front-end based on the Dogpile lock.";
         homepage = "http://bitbucket.org/zzzeek/dogpile.cache";
         license = licenses.bsd3;
       };
     }) { };

  keystoneauth1_3_9_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, iso8601, os-service-types, pbr, requests, six, stevedore }:
     python.mkDerivation {
       pname = "keystoneauth1";
       version = "3.9.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/7b/69/28113a3bc22416c23d4f111984b109aeb09273153abe2d87ccfa0b78a68f/keystoneauth1-3.9.0.tar.gz";
         sha256 = "59060ee313e2c57dcab9bfd59ca555bf9dc8e46cb76a5bbfb4be4eef6da6b016";
       };
       pythonDepends = [ iso8601 os-service-types pbr requests six stevedore ];
       meta = with stdenv.lib; {
         description = "Authentication Library for OpenStack Identity";
         homepage = "https://docs.openstack.org/keystoneauth/latest/";
       };
     }) { };

  cffi_1_11_5 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, libffi, pycparser }:
     python.mkDerivation {
       pname = "cffi";
       version = "1.11.5";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz";
         sha256 = "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4";
       };
       systemDepends = [ libffi ];
       pythonDepends = [ pycparser ];
       meta = with stdenv.lib; {
         description = "Foreign Function Interface for Python calling C code.";
         homepage = "http://cffi.readthedocs.org";
         license = licenses.mit;
       };
     }) { };

  simplejson_3_14_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "simplejson";
       version = "3.14.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/6c/ca/8776e0c494b7f16f98a4f40f1540ed6f7467f75280631d837e9cf3e5796e/simplejson-3.14.0.tar.gz";
         sha256 = "1ebbd84c2d7512f7ba65df0b9cc3cbc1bbd6ef9eab39fc9389dfe7e3681f7bd2";
       };
       meta = with stdenv.lib; {
         description = "Simple, fast, extensible JSON encoder/decoder for Python";
         homepage = "http://github.com/simplejson/simplejson";
         license = licenses.mit;
       };
     }) { };

  ipaddress_1_0_22 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "ipaddress";
       version = "1.0.22";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/97/8d/77b8cedcfbf93676148518036c6b1ce7f8e14bf07e95d7fd4ddcb8cc052f/ipaddress-1.0.22.tar.gz";
         sha256 = "b146c751ea45cad6188dd6cf2d9b757f6f4f8d6ffb96a023e6f2e26eea02a72c";
       };
       meta = with stdenv.lib; {
         description = "IPv4/IPv6 manipulation library";
         homepage = "https://github.com/phihag/ipaddress";
         license = licenses.psfl;
       };
     }) { };

  idna_2_6 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "idna";
       version = "2.6";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz";
         sha256 = "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f";
       };
       meta = with stdenv.lib; {
         description = "Internationalized Domain Names in Applications (IDNA)";
         homepage = "https://github.com/kjd/idna";
         license = licenses.bsd3;
       };
     }) { };

  oslo-config_6_3_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, pyyaml, debtcollector, netaddr, oslo-i18n, rfc3986, six, stevedore, enum34 }:
     python.mkDerivation {
       pname = "oslo.config";
       version = "6.3.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/de/c2/4b653f3db231643e3ee8a61952aaf3df95e5e591075cd3f3bb62928f5d40/oslo.config-6.3.0.tar.gz";
         sha256 = "bffe681bed69882ca8fa12df07b8d5194bbebb54f6ccf73ad096d5f5535ef450";
       };
       pythonDepends = [ pyyaml debtcollector netaddr oslo-i18n rfc3986 six stevedore ]
         ++ stdenv.lib.optional pythonPlatform.isPython27 enum34;
       meta = with stdenv.lib; {
         description = "Oslo Configuration API";
         homepage = "https://docs.openstack.org/oslo.config/latest/";
       };
     }) { };

  oslo-i18n_3_20_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, babel, pbr, six }:
     python.mkDerivation {
       pname = "oslo.i18n";
       version = "3.20.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/cc/8d/9514c0f979c858fcbf3c8300769f8323d5c69c20cffe3543059e978329cd/oslo.i18n-3.20.0.tar.gz";
         sha256 = "c3cf63c01fa3ff1b5ae7d6445d805c6bf5390ac010725cf126b18eb9086f4c4e";
       };
       pythonDepends = [ babel pbr six ];
       meta = with stdenv.lib; {
         description = "Oslo i18n library";
         homepage = "https://docs.openstack.org/oslo.i18n/latest";
       };
     }) { };

  munch_2_3_2 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, six }:
     python.mkDerivation {
       pname = "munch";
       version = "2.3.2";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/68/f4/260ec98ea840757a0da09e0ed8135333d59b8dfebe9752a365b04857660a/munch-2.3.2.tar.gz";
         sha256 = "6ae3d26b837feacf732fb8aa5b842130da1daf221f5af9f9d4b2a0a6414b0d51";
       };
       pythonDepends = [ six ];
       meta = with stdenv.lib; {
         description = "A dot-accessible dictionary (a la JavaScript objects).";
         homepage = "http://github.com/Infinidat/munch";
         license = licenses.mit;
       };
     }) { };

  oslo-utils_3_36_3 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, debtcollector, iso8601, monotonic, netaddr, netifaces, oslo-i18n, pbr, pyparsing, pytz, six, funcsigs }:
     python.mkDerivation {
       pname = "oslo.utils";
       version = "3.36.3";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/88/36/638cadf97ac2f29e6b4c452f7aecb1294c38916ed869a6a23ee0ed794d4c/oslo.utils-3.36.3.tar.gz";
         sha256 = "90ad73099884c6454b33ec809fde72e943b2a4481682a5f4d8aa6d103fddd73f";
       };
       pythonDepends = [ debtcollector iso8601 monotonic netaddr netifaces oslo-i18n pbr pyparsing pytz six ]
         ++ stdenv.lib.optional pythonPlatform.isPython27 funcsigs;
       meta = with stdenv.lib; {
         description = "Oslo Utility library";
         homepage = "https://docs.openstack.org/oslo.utils/latest/";
       };
     }) { };

  cliff_2_13_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, prettytable, pyyaml, pbr, pyparsing, six, stevedore, cmd2, unicodecsv }:
     python.mkDerivation {
       pname = "cliff";
       version = "2.13.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/27/dc/4105138ccdf500a56f782ec2eb8a80eb3e35321133c9159224bda989d362/cliff-2.13.0.tar.gz";
         sha256 = "447f0afe5fab907c51e3e451e6915cba424fe4a98962a5bdd7d4420b9d6aed35";
       };
       pythonDepends = [ prettytable pyyaml pbr pyparsing six stevedore ]
         ++ stdenv.lib.optionals pythonPlatform.isPython27 [ cmd2 unicodecsv ];
       meta = with stdenv.lib; {
         description = "Command Line Interface Formulation Framework";
         homepage = "https://docs.openstack.org/cliff/latest/";
       };
     }) { };

  pytz_2018_4 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "pytz";
       version = "2018.4";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/10/76/52efda4ef98e7544321fd8d5d512e11739c1df18b0649551aeccfb1c8376/pytz-2018.4.tar.gz";
         sha256 = "c06425302f2cf668f1bba7a0a03f3c1d34d4ebeef2c72003da308b3947c7f749";
       };
       meta = with stdenv.lib; {
         description = "World timezone definitions, modern and historical";
         homepage = "http://pythonhosted.org/pytz";
         license = licenses.mit;
       };
     }) { };

  funcsigs_1_0_2 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "funcsigs";
       version = "1.0.2";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz";
         sha256 = "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50";
       };
       meta = with stdenv.lib; {
         description = "Python function signatures from PEP362 for Python 2.6, 2.7 and 3.2+";
         homepage = "http://funcsigs.readthedocs.org";
       };
     }) { };

  wrapt_1_10_11 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "wrapt";
       version = "1.10.11";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/a0/47/66897906448185fcb77fc3c2b1bc20ed0ecca81a0f2f88eda3fc5a34fc3d/wrapt-1.10.11.tar.gz";
         sha256 = "d4d560d479f2c21e1b5443bbd15fe7ec4b37fe7e53d335d3b9b0a7b1226fe3c6";
       };
       meta = with stdenv.lib; {
         description = "Module for decorators, wrappers and monkey patching.";
         homepage = "https://github.com/GrahamDumpleton/wrapt";
         license = licenses.bsd3;
       };
     }) { };

  debtcollector_1_19_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, pbr, six, wrapt, funcsigs }:
     python.mkDerivation {
       pname = "debtcollector";
       version = "1.19.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/44/db/6b54be9367110bc40468f3bcc75b115ab655a9fdd993a4ed01862fdb8d80/debtcollector-1.19.0.tar.gz";
         sha256 = "4e90683553a6bb68d10a29b42c5df90d0e83d5085ff1ac2970c91314acdf8719";
       };
       pythonDepends = [ pbr six wrapt ]
         ++ stdenv.lib.optional pythonPlatform.isPython27 funcsigs;
       meta = with stdenv.lib; {
         description = "A collection of Python deprecation patterns and strategies that help you collect your technical debt in a non-destructive manner.";
         homepage = "https://docs.openstack.org/debtcollector/latest";
       };
     }) { };

  vcversioner_2_16_0_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "vcversioner";
       version = "2.16.0.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/c5/cc/33162c0a7b28a4d8c83da07bc2b12cee58c120b4a9e8bba31c41c8d35a16/vcversioner-2.16.0.0.tar.gz";
         sha256 = "dae60c17a479781f44a4010701833f1829140b1eeccd258762a74974aa06e19b";
       };
       meta = with stdenv.lib; {
         description = "Use version control tags to discover version numbers";
         homepage = "https://github.com/habnabit/vcversioner";
         license = licenses.isc;
       };
     }) { };

  requests_2_18_4 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, certifi, chardet, idna, urllib3 }:
     python.mkDerivation {
       pname = "requests";
       version = "2.18.4";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz";
         sha256 = "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e";
       };
       pythonDepends = [ certifi chardet idna urllib3 ];
       meta = with stdenv.lib; {
         description = "Python HTTP for Humans.";
         homepage = "http://python-requests.org";
         license = licenses.asl20;
       };
     }) { };

  babel_2_6_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, pytz }:
     python.mkDerivation {
       pname = "Babel";
       version = "2.6.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/be/cc/9c981b249a455fa0c76338966325fc70b7265521bad641bf2932f77712f4/Babel-2.6.0.tar.gz";
         sha256 = "8cba50f48c529ca3fa18cf81fa9403be176d374ac4d60738b839122dfaaa3d23";
       };
       pythonDepends = [ pytz ];
       meta = with stdenv.lib; {
         description = "Internationalization utilities";
         homepage = "http://babel.pocoo.org/";
         license = licenses.bsd3;
       };
     }) { };

  rfc3986_1_1_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "rfc3986";
       version = "1.1.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/4b/f6/8f0a24e50454494b0736fe02e6617e7436f2b30148b8f062462177e2ca2d/rfc3986-1.1.0.tar.gz";
         sha256 = "8458571c4c57e1cf23593ad860bb601b6a604df6217f829c2bc70dc4b5af941b";
       };
       meta = with stdenv.lib; {
         description = "Validating URI References per RFC 3986";
         homepage = "http://rfc3986.readthedocs.io";
         license = licenses.asl20;
       };
     }) { };

  asn1crypto_0_24_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "asn1crypto";
       version = "0.24.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz";
         sha256 = "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49";
       };
       meta = with stdenv.lib; {
         description = "Fast ASN.1 parser and serializer with definitions for private keys, public keys, certificates, CRL, OCSP, CMS, PKCS#3, PKCS#7, PKCS#8, PKCS#12, PKCS#5, X.509 and TSP";
         homepage = "https://github.com/wbond/asn1crypto";
         license = licenses.mit;
       };
     }) { };

  certifi_2018_4_16 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "certifi";
       version = "2018.4.16";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz";
         sha256 = "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7";
       };
       meta = with stdenv.lib; {
         description = "Python package for providing Mozilla's CA Bundle.";
         homepage = "http://certifi.io/";
         license = licenses.mpl20;
       };
     }) { };

  python-glanceclient_2_11_1 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, prettytable, keystoneauth1, oslo-i18n, oslo-utils, pbr, pyopenssl, requests, six, warlock, wrapt }:
     python.mkDerivation {
       pname = "python_glanceclient";
       version = "2.11.1";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/72/d1/37b59cdefa42de90dba94a2dc42ceb599e89423cc03ab837fe07dba05732/python-glanceclient-2.11.1.tar.gz";
         sha256 = "4c06dd38d8c95ef5e0bae72133f067da6ee7b710a10b677855beabd3cc7af50e";
       };
       pythonDepends = [ prettytable keystoneauth1 oslo-i18n oslo-utils pbr pyopenssl requests six warlock wrapt ];
       meta = with stdenv.lib; {
         description = "OpenStack Image API Client Library";
         homepage = "https://docs.openstack.org/python-glanceclient/latest/";
         license = licenses.asl20;
       };
     }) { };

  jsonschema_2_6_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, functools32, vcversioner }:
     python.mkDerivation {
       pname = "jsonschema";
       version = "2.6.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/58/b9/171dbb07e18c6346090a37f03c7e74410a1a56123f847efed59af260a298/jsonschema-2.6.0.tar.gz";
         sha256 = "6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02";
       };
       pythonDepends = [ vcversioner ]
         ++ stdenv.lib.optional pythonPlatform.isPython27 functools32;
       meta = with stdenv.lib; {
         description = "An implementation of JSON Schema validation for Python";
         homepage = "http://github.com/Julian/jsonschema";
         license = licenses.mit;
       };
     }) { };

  openstacksdk_0_16_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, pyyaml, appdirs, decorator, deprecation, dogpile-cache, iso8601, jmespath, jsonpatch, keystoneauth1, munch, netifaces, os-service-types, pbr, requestsexceptions, six, ipaddress, futures }:
     python.mkDerivation {
       pname = "openstacksdk";
       version = "0.16.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/13/b7/ef77e4e2053204a5d82d78634c077198f3003518cfe4a103d09b54918119/openstacksdk-0.16.0.tar.gz";
         sha256 = "a3c375ca00365fb359385bde759c8ccbdd63f871199248fab6757e733b7a9b85";
       };
       pythonDepends = [ pyyaml appdirs decorator deprecation dogpile-cache iso8601 jmespath jsonpatch keystoneauth1 munch netifaces os-service-types pbr requestsexceptions six ]
         ++ stdenv.lib.optional pythonPlatform.isPython27 ipaddress
         ++ stdenv.lib.optional pythonPlatform.isPython27 futures;
       meta = with stdenv.lib; {
         description = "An SDK for building applications to work with OpenStack";
         homepage = "http://developer.openstack.org/sdks/python/openstacksdk/";
       };
     }) { };

  deprecation_2_0_5 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, packaging }:
     python.mkDerivation {
       pname = "deprecation";
       version = "2.0.5";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/dd/06/aed49f13984c4acfcd67d699b2a0e96fefd2f9c700ce88a43120eb0363e2/deprecation-2.0.5.tar.gz";
         sha256 = "cbe7d15006bc339709be5e02b14884ecc479639c1a3714a908de3a8ca13b5ca9";
       };
       pythonDepends = [ packaging ];
       meta = with stdenv.lib; {
         description = "A library to handle automated deprecations";
         homepage = "http://deprecation.readthedocs.io/";
         license = licenses.asl20;
       };
     }) { };

  appdirs_1_4_3 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "appdirs";
       version = "1.4.3";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz";
         sha256 = "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92";
       };
       meta = with stdenv.lib; {
         description = "A small Python module for determining appropriate platform-specific dirs, e.g. a \"user data dir\".";
         homepage = "http://github.com/ActiveState/appdirs";
         license = licenses.mit;
       };
     }) { };

  pyyaml_3_13 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, libyaml }:
     python.mkDerivation {
       pname = "PyYAML";
       version = "3.13";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz";
         sha256 = "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf";
       };
       systemDepends = [ libyaml ];
       meta = with stdenv.lib; {
         description = "YAML parser and emitter for Python";
         homepage = "http://pyyaml.org/wiki/PyYAML";
         license = licenses.mit;
       };
     }) { };

  pyyaml_3_12 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, libyaml }:
     python.mkDerivation {
       pname = "PyYAML";
       version = "3.12";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz";
         sha256 = "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab";
       };
       systemDepends = [ libyaml ];
       meta = with stdenv.lib; {
         description = "YAML parser and emitter for Python";
         homepage = "http://pyyaml.org/wiki/PyYAML";
         license = licenses.mit;
       };
     }) { };

  contextlib2_0_5_5 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "contextlib2";
       version = "0.5.5";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/6e/db/41233498c210b03ab8b072c8ee49b1cd63b3b0c76f8ea0a0e5d02df06898/contextlib2-0.5.5.tar.gz";
         sha256 = "509f9419ee91cdd00ba34443217d5ca51f5a364a404e1dce9e8979cea969ca48";
       };
       meta = with stdenv.lib; {
         description = "Backports and enhancements for the contextlib module";
         homepage = "http://contextlib2.readthedocs.org";
         license = licenses.psfl;
       };
     }) { };

  jmespath_0_9_3 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "jmespath";
       version = "0.9.3";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz";
         sha256 = "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64";
       };
       meta = with stdenv.lib; {
         description = "JSON Matching Expressions";
         homepage = "https://github.com/jmespath/jmespath.py";
         license = licenses.mit;
       };
     }) { };

  urllib3_1_22 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "urllib3";
       version = "1.22";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz";
         sha256 = "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f";
       };
       meta = with stdenv.lib; {
         description = "HTTP library with thread-safe connection pooling, file post, and more.";
         homepage = "https://urllib3.readthedocs.io/";
         license = licenses.mit;
       };
     }) { };

  python-cinderclient_3_6_1 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, babel, prettytable, keystoneauth1, oslo-i18n, oslo-utils, pbr, simplejson, six }:
     python.mkDerivation {
       pname = "python_cinderclient";
       version = "3.6.1";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/dd/91/40d557b0760da0776411fcf7a20734de4a6f30b05681c7abcb17b2f777ea/python-cinderclient-3.6.1.tar.gz";
         sha256 = "05085a2692391bb2f000bd64e6ad333783a6fc2e72158fda63375b4d5fc0bf60";
       };
       pythonDepends = [ babel prettytable keystoneauth1 oslo-i18n oslo-utils pbr simplejson six ];
       meta = with stdenv.lib; {
         description = "OpenStack Block Storage API Client Library";
         homepage = "https://docs.openstack.org/python-cinderclient/latest/";
       };
     }) { };

  setuptools_39_1_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "setuptools";
       version = "39.1.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/a6/5b/f399fcffb9128d642387133dc3aa9bb81f127b949cd4d9f63e5602ad1d71/setuptools-39.1.0.zip";
         sha256 = "c5484e13b89927b44fd15897f7ce19dded8e7f035466a4fa7b946c0bdd86edd7";
       };
       meta = with stdenv.lib; {
         description = "Easily download, build, install, upgrade, and uninstall Python packages";
         homepage = "https://github.com/pypa/setuptools";
       };
     }) { };

  subprocess32_3_5_2 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "subprocess32";
       version = "3.5.2";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/c3/5f/7117737fc7114061837a4f51670d863dd7f7f9c762a6546fa8a0dcfe61c8/subprocess32-3.5.2.tar.gz";
         sha256 = "eb2b989cf03ffc7166339eb34f1aa26c5ace255243337b1e22dab7caa1166687";
       };
       meta = with stdenv.lib; {
         description = "A backport of the subprocess module from Python 3 for use on 2.x.";
         homepage = "https://github.com/google/python-subprocess32";
         license = licenses.psfl;
       };
     }) { };

  six_1_11_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "six";
       version = "1.11.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz";
         sha256 = "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9";
       };
       meta = with stdenv.lib; {
         description = "Python 2 and 3 compatibility utilities";
         homepage = "http://pypi.python.org/pypi/six/";
         license = licenses.mit;
       };
     }) { };

  jsonpointer_2_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "jsonpointer";
       version = "2.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/52/e7/246d9ef2366d430f0ce7bdc494ea2df8b49d7a2a41ba51f5655f68cfe85f/jsonpointer-2.0.tar.gz";
         sha256 = "c192ba86648e05fdae4f08a17ec25180a9aef5008d973407b581798a83975362";
       };
       meta = with stdenv.lib; {
         description = "Identify specific nodes in a JSON document (RFC 6901) ";
         homepage = "https://github.com/stefankoegl/python-json-pointer";
         license = licenses.bsd3;
       };
     }) { };

  jsonpatch_1_23 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, jsonpointer }:
     python.mkDerivation {
       pname = "jsonpatch";
       version = "1.23";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/9a/7d/bcf203d81939420e1aaf7478a3efce1efb8ccb4d047a33cb85d7f96d775e/jsonpatch-1.23.tar.gz";
         sha256 = "49f29cab70e9068db3b1dc6b656cbe2ee4edf7dfe9bf5a0055f17a4b6804a4b9";
       };
       pythonDepends = [ jsonpointer ];
       meta = with stdenv.lib; {
         description = "Apply JSON-Patches (RFC 6902) ";
         homepage = "https://github.com/stefankoegl/python-json-patch";
         license = licenses.bsd3;
       };
     }) { };

  cmd2_0_8_8 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, pyparsing, pyperclip, six, wcwidth, subprocess32, enum34, contextlib2 }:
     python.mkDerivation {
       pname = "cmd2";
       version = "0.8.8";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/e8/ee/e9d450ae62cc0bb535c1f9e3f67530abfdb7892a68761d11819b0da65467/cmd2-0.8.8.tar.gz";
         sha256 = "b08bc5088fdd131d659354e6b4f8cf7c01a70566f68aed146e00d296a24b687b";
       };
       pythonDepends = [ pyparsing pyperclip six wcwidth ]
         ++ stdenv.lib.optional pythonPlatform.isPython27 subprocess32
         ++ stdenv.lib.optional pythonPlatform.isPython27 enum34
         ++ stdenv.lib.optional pythonPlatform.isPython27 contextlib2;
       meta = with stdenv.lib; {
         description = "cmd2 - a tool for building interactive command line applications in Python";
         homepage = "https://github.com/python-cmd2/cmd2";
         license = licenses.mit;
       };
     }) { };

  python-openstackclient_3_15_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, babel, cliff, keystoneauth1, openstacksdk, osc-lib, oslo-i18n, oslo-utils, pbr, python-cinderclient, python-glanceclient, python-keystoneclient, python-novaclient, six }:
     python.mkDerivation {
       pname = "python_openstackclient";
       version = "3.15.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/6a/a1/3974a6261ce3eeb52859288934a8d7a8756dc895036fddaddd1d0c23773f/python-openstackclient-3.15.0.tar.gz";
         sha256 = "075a8e38551ae24e32f61083d833990654eeaa7b516c5e3c6cc2a537d6d098d3";
       };
       pythonDepends = [ babel cliff keystoneauth1 openstacksdk osc-lib oslo-i18n oslo-utils pbr python-cinderclient python-glanceclient python-keystoneclient python-novaclient six ];
       meta = with stdenv.lib; {
         description = "OpenStack Command-line Client";
         homepage = "https://docs.openstack.org/python-openstackclient/latest/";
       };
     }) { };

  pbr_4_0_2 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
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
     }) { };

  unicodecsv_0_14_1 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "unicodecsv";
       version = "0.14.1";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz";
         sha256 = "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc";
       };
       meta = with stdenv.lib; {
         description = "Python2's stdlib csv module is nice, but it doesn't support unicode. This module is a drop-in replacement which *does*.";
         homepage = "https://github.com/jdunck/python-unicodecsv";
         license = licenses.bsd3;
       };
     }) { };

  stevedore_1_20_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, pbr, six, setuptools }:
     python.mkDerivation {
       pname = "stevedore";
       version = "1.20.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/ac/72/1e890a8a70ee96edc4cc0fff895f99994e5271df62e0b665b2c54e3eec3c/stevedore-1.20.0.tar.gz";
         sha256 = "83884f80ed0917346e658bfe51cdb2474512ec6521c18480b41f58b54c4a1f83";
       };
       pythonDepends = [ pbr six setuptools ];
       meta = with stdenv.lib; {
         description = "Manage dynamic plugins for Python applications";
         homepage = "http://docs.openstack.org/developer/stevedore/";
       };
     }) { };

  prettytable_0_7_2 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl }:
     python.mkDerivation {
       pname = "prettytable";
       version = "0.7.2";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/e0/a1/36203205f77ccf98f3c6cf17cf068c972e6458d7e58509ca66da949ca347/prettytable-0.7.2.tar.gz";
         sha256 = "2d5460dc9db74a32bcc8f9f67de68b2c4f4d2f01fa3bd518764c69156d9cacd9";
       };
       meta = with stdenv.lib; {
         description = "A simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
         homepage = "http://code.google.com/p/prettytable";
         license = licenses.bsd3;
       };
     }) { };

  oslo-serialization_2_27_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, msgpack, oslo-utils, pbr, pytz, six }:
     python.mkDerivation {
       pname = "oslo.serialization";
       version = "2.27.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/21/b0/15a593a9fe8963cf3798f5b892389036936f0972ddc60d2b089b90c56517/oslo.serialization-2.27.0.tar.gz";
         sha256 = "ec3f8ef108199204dcbded425e940625c3d4d8663cb69724c58d3c29031ab8e3";
       };
       pythonDepends = [ msgpack oslo-utils pbr pytz six ];
       meta = with stdenv.lib; {
         description = "Oslo Serialization library";
         homepage = "http://docs.openstack.org/developer/oslo.serialization/";
       };
     }) { };

  python-novaclient_10_3_0 = callPackage
    ({ python, pythonPlatform, stdenv, fetchurl, babel, prettytable, iso8601, keystoneauth1, oslo-i18n, oslo-serialization, oslo-utils, pbr, simplejson, six }:
     python.mkDerivation {
       pname = "python_novaclient";
       version = "10.3.0";
       src = fetchurl {
         url = "https://files.pythonhosted.org/packages/62/71/6b6a3e2d351c51fdb3449d0f445a379a30f6538e3abe36356e8a533caaf6/python-novaclient-10.3.0.tar.gz";
         sha256 = "221c9a8c406146ebc51f78fe22c0eb0c36780eaef56b05ed0c04ec883bf8f90b";
       };
       pythonDepends = [ babel prettytable iso8601 keystoneauth1 oslo-i18n oslo-serialization oslo-utils pbr simplejson six ];
       meta = with stdenv.lib; {
         description = "Client library for OpenStack Compute API";
         homepage = "https://docs.openstack.org/python-novaclient/latest";
         license = licenses.asl20;
       };
     }) { };
}
