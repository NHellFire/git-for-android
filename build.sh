#!/bin/bash
set -e

ANDROID_API=23
ARCH=arm64
NDK_ROOT=${NDK_ROOT:-/opt/android-ndk}

[ -e config.sh ] && . config.sh

# You shouldn't need to change anything below here

TOOLCHAIN="${NDK_ROOT}/toolchains/${HOST}-4.9/prebuilt/linux-x86_64"

TOP="$(realpath "$(dirname "$0")")"

CURL="${TOP}/curl/prebuilt-with-ssl/android"

CURL_HEADERS="${CURL}/include"

case "$ARCH" in
	arm64)
		CURL_LIBS="${CURL}/arm64-v8a"
		GCC_ARCH="aarch64"
	;;
	arm)
		CURL_LIBS="${CURL}/armeabi-v7a"
		GCC_ARCH="arm"
	;;
	mips|mips64)
		CURL_LIBS="${CURL}/${ARCH}"
		GCC_ARCH="${ARCH}el"
	;;
	x86|x86_64)
		CURL_LIBS="${CURL}/${ARCH}"
		GCC_ARCH="${ARCH}"
	;;
	*)
		echo "Unknown architecture: ${ARCH}"
		exit
esac



# Features that need to be disabled on android
export NO_ICONV=1 # --without-iconv doesn't set this apparently

export STRIP="${HOST}-strip"
export DESTDIR="${TOP}/install_dir"
export HOST="${GCC_ARCH}-linux-android"

PATH="$TOOLCHAIN/bin:$PATH"

export CFLAGS="--sysroot=${NDK_ROOT}/platforms/android-${ANDROID_API}/arch-${ARCH} -I${CURL_HEADERS} -L${CURL_LIBS} -lz"

cd git

make configure

./configure --host=${HOST} --prefix=/data/local/git \
	--without-iconv \
	ac_cv_fread_reads_directories=no ac_cv_snprintf_returns_bogus=no

make -j$(nproc)

make strip

make install


printf "\n\nBuild complete! See install_dir/\n"
