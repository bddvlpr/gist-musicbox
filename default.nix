{
  mkYarnPackage,
  fetchYarnDeps,
  makeWrapper,
  nodejs,
  lib,
}:
mkYarnPackage rec {
  pname = "gist-musicbox";
  version = "0.1.0";

  src = ./.;

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-JQhSy4Eu545urGpJDsv+qQM/MRU/DILBJZrrvTkgoy8=";
  };

  nativeBuildInputs = [makeWrapper];

  buildPhase = ''
    yarn run build
  '';

  postInstall = ''
    makeWrapper ${lib.getExe nodejs} "$out/bin/gist-musicbox" \
      --add-flags "$out/libexec/gist-musicbox/deps/gist-musicbox/dist/index.js"
  '';

  meta = with lib; {
    description = "Updates a given GitHub Gist with your music statistics";
    homepage = "https://github.com/bddvlpr/gist-musicbox";
    license = licenses.bsd3;
    maintainers = with maintainers; [bddvlpr];
    mainProgram = "gist-musicbox";
  };
}
