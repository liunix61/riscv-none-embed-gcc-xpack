# Scripts to test the riscv-none-embed-gcc xPack

The binaries can be available from one of the pre-releases:

<https://github.com/xpack-dev-tools/pre-releases/releases>

## Download the repo

The test script is part of the RISC-V xPack:

```sh
rm -rf ${HOME}/Work/riscv-none-embed-gcc-xpack.git; \
git clone \
  --branch xpack-develop \
  https://github.com/xpack-dev-tools/riscv-none-embed-gcc-xpack.git  \
  ${HOME}/Work/riscv-none-embed-gcc-xpack.git; \
git -C ${HOME}/Work/riscv-none-embed-gcc-xpack.git submodule update --init --recursive
```

## Start a local test

To check if riscv-none-embed-gcc starts on the current platform, run a native test:

```sh
bash ${HOME}/Work/riscv-none-embed-gcc-xpack.git/scripts/helper/tests/native-test.sh \
  --base-url "https://github.com/xpack-dev-tools/pre-releases/releases/download/test/"
```

The script stores the downloaded archive in a local cache, and
does not download it again if available locally.

To force a new download, remove the local archive:

```sh
rm -rf ~/Work/cache/xpack-riscv-none-embed-gcc-*
```

## Start the GitHub Actions tests

The multi-platform tests run on GitHub Actions; they do not fire on
git commits, but only via a manual POST to the GitHub API.

```sh
bash ${HOME}/Work/riscv-none-embed-gcc-xpack.git/scripts/tests/trigger-workflow-test-native.sh \
  --branch xpack-develop \
  --base-url "https://github.com/xpack-dev-tools/pre-releases/releases/download/test/"

bash ${HOME}/Work/riscv-none-embed-gcc-xpack.git/scripts/tests/trigger-workflow-test-docker-linux-intel.sh \
  --branch xpack-develop \
  --base-url "https://github.com/xpack-dev-tools/pre-releases/releases/download/test/"

bash ${HOME}/Work/riscv-none-embed-gcc-xpack.git/scripts/tests/trigger-workflow-test-docker-linux-arm.sh \
  --branch xpack-develop \
  --base-url "https://github.com/xpack-dev-tools/pre-releases/releases/download/test/"

```

The results are available at the project
[Actions](https://github.com/xpack-dev-tools/riscv-none-embed-gcc-xpack/actions/) page.
