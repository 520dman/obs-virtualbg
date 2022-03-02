#!/bin/bash

set -xeu
cd $(dirname $0)/..
DEPS_DIR=$(pwd)/deps

HALIDE_VERSION=13.0.0
HALIDE_URL=https://github.com/halide/Halide/releases/download/v13.0.0/Halide-13.0.0-x86-64-osx-c3641b6850d156aff6bb01a9c01ef475bd069a31.tar.gz
HALIDE_TGZ=${DEPS_DIR}/Halide-${HALIDE_VERSION}.tar.gz
HALIDE_DIR=${DEPS_DIR}/Halide

ONNXRUNTIME_VERSION=1.10.0
ONNXRUNTIME_URL=https://github.com/microsoft/onnxruntime/releases/download/v${ONNXRUNTIME_VERSION}/onnxruntime-osx-universal2-${ONNXRUNTIME_VERSION}.tgz
ONNXRUNTIME_TGZ=${DEPS_DIR}/onnxruntime-osx-universal2-${ONNXRUNTIME_VERSION}.tgz
ONNXRUNTIME_DIR=${DEPS_DIR}/onnxruntime

[ -d ${DEPS_DIR} ] || mkdir ${DEPS_DIR}
[ -e ${HALIDE_TGZ} ] || curl -o ${HALIDE_TGZ} -L ${HALIDE_URL}
[ -d ${HALIDE_DIR} ] || mkdir ${HALIDE_DIR} && tar zxf ${HALIDE_TGZ} -C ${HALIDE_DIR} --strip-components 1

[ -e ${ONNXRUNTIME_TGZ} ] || curl -o ${ONNXRUNTIME_TGZ} -L ${ONNXRUNTIME_URL}
[ -d ${ONNXRUNTIME_DIR} ] || mkdir ${ONNXRUNTIME_DIR} && tar zxf ${ONNXRUNTIME_TGZ} -C ${ONNXRUNTIME_DIR} --strip-components 1

# for update obs version.
brew update

# brew install onnxruntime
brew install llvm@12
brew pin llvm
brew install obs --cask

