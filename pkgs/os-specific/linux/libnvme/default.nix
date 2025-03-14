{ fetchFromGitHub
, json_c
, keyutils
, lib
, meson
, ninja
, openssl
, perl
, pkg-config
, python3
, stdenv
, swig
, systemd
}:

stdenv.mkDerivation rec {
  pname = "libnvme";
  version = "1.4";

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "libnvme";
    rev = "v${version}";
    sha256 = "sha256-8DlEQ4LH6UhIHr0znJGqkuCosLHqA6hkJjmiCawNE1k=";
  };

  postPatch = ''
    patchShebangs meson-vcs-tag.sh
    chmod +x doc/kernel-doc-check
    patchShebangs doc/kernel-doc doc/kernel-doc-check doc/list-man-pages.sh
  '';

  nativeBuildInputs = [
    meson
    ninja
    perl # for kernel-doc
    pkg-config
    python3
    swig
  ];

  buildInputs = [
    keyutils
    json_c
    openssl
    systemd
  ];

  mesonFlags = [
    "-Ddocs=man"
    "-Ddocs-build=true"
  ];

  doCheck = true;

  meta = with lib; {
    description = "C Library for NVM Express on Linux";
    homepage = "https://github.com/linux-nvme/libnvme";
    maintainers = with maintainers; [ zseri ];
    license = with licenses; [ lgpl21Plus ];
    platforms = platforms.linux;
  };
}
