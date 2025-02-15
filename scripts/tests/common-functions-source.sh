# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Common functions used in various tests.
#
# Requires
# - app_folder_path
# - test_folder_path
# - archive_platform (win32|linux|darwin)

# -----------------------------------------------------------------------------

function run_tests()
{
  GCC_VERSION="$(echo "${RELEASE_VERSION}" | sed -e 's|-.*||')"
  GCC_VERSION_MAJOR=$(echo ${GCC_VERSION} | sed -e 's|\([0-9][0-9]*\)\..*|\1|')

  echo
  env | sort

  test_binutils

  test_gcc

  test_gdb

  test_gdb_py3
}

function update_image()
{
  local image_name="$1"

  # Make sure that the minimum prerequisites are met.
  if [[ ${image_name} == github-actions-ubuntu* ]]
  then
    : # sudo apt-get -qq install -y XXX
  elif [[ ${image_name} == *ubuntu* ]] || [[ ${image_name} == *debian* ]] || [[ ${image_name} == *raspbian* ]]
  then
    run_verbose apt-get -qq update
    run_verbose apt-get -qq install -y git-core curl tar gzip lsb-release binutils
    run_verbose apt-get -qq install -y libc6-dev libstdc++6 # TODO: get rid of them
  elif [[ ${image_name} == *centos* ]] || [[ ${image_name} == *redhat* ]] || [[ ${image_name} == *fedora* ]]
  then
    run_verbose yum install -y -q git curl tar gzip redhat-lsb-core binutils
    run_verbose yum install -y -q glibc-devel glibc-static libstdc++-devel # TODO: get rid of them
  elif [[ ${image_name} == *suse* ]]
  then
    run_verbose zypper -q in -y git-core curl tar gzip lsb-release binutils findutils util-linux
    run_verbose zypper -q in -y glibc-devel glibc-devel-static libstdc++6 # TODO: get rid of them
  elif [[ ${image_name} == *manjaro* ]]
  then
    # run_verbose pacman-mirrors -g
    run_verbose pacman -S -y -q --noconfirm

    # Update even if up to date (-yy) & upgrade (-u).
    # pacman -S -yy -u -q --noconfirm
    run_verbose pacman -S -q --noconfirm --noprogressbar git curl tar gzip lsb-release binutils
    run_verbose pacman -S -q --noconfirm --noprogressbar gcc-libs # TODO: get rid of them
  elif [[ ${image_name} == *archlinux* ]]
  then
    run_verbose pacman -S -y -q --noconfirm

    # Update even if up to date (-yy) & upgrade (-u).
    # pacman -S -yy -u -q --noconfirm
    run_verbose pacman -S -q --noconfirm --noprogressbar git curl tar gzip lsb-release binutils
    run_verbose pacman -S -q --noconfirm --noprogressbar gcc-libs
  fi

  echo
  echo "The system C/C++ libraries..."
  find /usr/lib* /lib -name 'libc.*' -o -name 'libstdc++.*' -o -name 'libgcc_s.*'
}

# -----------------------------------------------------------------------------
