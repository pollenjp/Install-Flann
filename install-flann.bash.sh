#!/bin/bash -eux

# [bash - What's a concise way to check that environment variables are set in a Unix shell script? - Stack Overflow](https://stackoverflow.com/a/307735/9316234)
#FLANN_VERSION=1.8.5
: "${FLANN_VERSION:?Need to be set. (ex: '$ FLANN_VERSION=1.8.5 ./xxx.sh')}"

FLANN_DIR=${HOME}/.flann
CMAKE_INSTALL_PREFIX=${FLANN_DIR}/install/flann-${FLANN_VERSION}

# current working directory
CWD=$(pwd)


#=======================================
# if a directory or a symbolic link does not exist
if [ ! -d ${FLANN_DIR} ] && [ ! -L ${FLANN_DIR} ]; then
  mkdir ${FLANN_DIR}
fi

#=======================================
# clone flann
cd ${FLANN_DIR}
if [ ! -d "${FLANN_DIR}/flann" ]; then
  git clone git://github.com/mariusmuja/flann.git
fi

cd "${FLANN_DIR}/flann"
git checkout master
git fetch
git pull --all
git checkout ${FLANN_VERSION}
cd ${FLANN_DIR}
 
#=======================================
# build
directory1=${FLANN_DIR}/flann/build
if [ -d "${directory1}" ]; then
  rm -rf ${directory1}
fi
mkdir ${directory1}
cd ${directory1}
echo ${directory1}

# [How to set C or C++ compiler for CMake – Code Yarns](https://codeyarns.com/2013/12/24/how-to-set-c-or-c-compiler-for-cmake/)
cmake \
      -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
      ..

if [ -d "${CMAKE_INSTALL_PREFIX}" ]; then
  rm -rf ${CMAKE_INSTALL_PREFIX}
fi
make -j4
make install

#===============================================================================
# Back to working directory
cd ${CWD}