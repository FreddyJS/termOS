#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ARCH=i386

SYSROOT=$(realpath "${DIR}/../sysroot")
INCLUDE="${SYSROOT}/usr/include"
LIBS="${SYSROOT}/usr/lib"

# -- Export environment variables -- #
export TARGET="${ARCH}-termos"
export PREFIX="${DIR}/${ARCH}"
export PATH="${PREFIX}/bin:$PATH"

# -- Show final information -- #
echo "Building toolchain for ${TARGET}"
echo "GCC and Binutils dir: ${PREFIX}"
echo ""
echo "SYSROOT: ${SYSROOT}"
echo "INCLUDE: ${INCLUDE}"
echo "LIBS:    ${LIBS}"
echo ""

read -p "Press any key to continue: "

buildstep() {
    NAME=$1
    shift
    "$@" 2>&1 | sed $'s|^|\x1b[34m['"${NAME}"$']\x1b[39m |'
}

# -- cd to our work directory after setup variables -- #
cd ${DIR}

# -- check cache and reuse
mkdir -p cache
echo "Cache (before):"
ls -l cache
CACHED_TOOLCHAIN_ARCHIVE="cache/ToolchainBinariesGithubActions.tar.gz"
if [ -r "${CACHED_TOOLCHAIN_ARCHIVE}" ] ; then
    echo "Cache at ${CACHED_TOOLCHAIN_ARCHIVE} exists!"
    echo "Extracting toolchain from cache:"
    if tar xzf "${CACHED_TOOLCHAIN_ARCHIVE}" ; then
        echo "Done 'building' the toolchain."
        echo "Cache unchanged."
        exit 0
    else
        echo
        echo
        echo
        echo "Could not extract cached toolchain archive."
        echo "This means the cache is broken and *should be removed*!"
        echo "As Github Actions cannot update a cache, this will unnecessarily"
        echo "slow down all future builds for this hash, until someone"
        echo "resets the cache."
        echo
        echo
        echo
        rm -f "${CACHED_TOOLCHAIN_ARCHIVE}"
    fi
else
    echo "Cache at ${CACHED_TOOLCHAIN_ARCHIVE} does not exist."
    echo "Will rebuild toolchain from scratch, and save the result."
fi

# -- Create necessary folders -- #
mkdir -p trash
mkdir -p ${PREFIX}

pushd trash

# -- Download an patch the sources -- #
FILE=binutils-2.35.1.tar.gz
if [ -f "$FILE" ]; then
    echo -e "Bintuils founded! Skip download..."
else 
    curl -O https://ftp.gnu.org/gnu/binutils/binutils-2.35.1.tar.gz
fi

tar xf binutils-2.35.1.tar.gz

cd binutils-2.35.1
git init > /dev/null
git add . > /dev/null
git commit -am "BASE" > /dev/null
git apply ../../patches/binutils.patch
cd ..

FILE=gcc-10.2.0.tar.gz
if [ -f "$FILE" ]; then
    echo -e "GCC founded! Skip download..."
else 
    curl -O https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.gz
fi

tar xf gcc-10.2.0.tar.gz

cd gcc-10.2.0
git init > /dev/null
git add . > /dev/null
git commit -am "BASE" > /dev/null
git apply ../../patches/gcc.patch
cd ..

popd

# -- Ready to build binutils and gcc -- #
pushd trash/binutils-2.35.1

# -- Configure and build binutils -- #
mkdir build
cd build
buildstep "binutils/configure" ../configure --target="$TARGET" --prefix="$PREFIX" --with-sysroot="$SYSROOT" --disable-werrorcd
buildstep "binutils/build" make -j $(nproc)
buildstep "binutils/install" make install
popd

# -- Configure and build gcc -- #
pushd trash/gcc-10.2.0

mkdir build
cd build
buildstep "gcc/configure" ../configure --target="$TARGET" --prefix="$PREFIX" --with-sysroot="$SYSROOT" --enable-shared --enable-languages=c,c++
buildstep "gcc/build" make -j $(nproc) all-target all-target-libgcc
buildstep "gcc/install" make install-gcc install-target-libgcc
cd ..

popd

# -- Save toolchain to cache

echo "Building cache tar:"
rm -f "${CACHED_TOOLCHAIN_ARCHIVE}"  # Just in case
tar czf "${CACHED_TOOLCHAIN_ARCHIVE}" i386
echo "Cache (after):"
ls -l cache
