#!/bin/bash
# Copyright cc 2023 sirnewbies

echo "Cloning dependencies"
rm -rf AnyKernel
git clone --depth=1 https://github.com/App-tester-ANAGHA/AnyKernel3.git -b RMX1971 AnyKernel
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 los-4.9-64
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 los-4.9-32
echo "Done"

export ARCH=arm64
export KBUILD_BUILD_HOST=Fedora
export KBUILD_BUILD_USER="t.me/rishrishh"
TANGGAL=$(date +"%F-%S")

# setup color
red='\033[0;31m'
green='\e[0;32m'
white='\033[0m'
yellow='\033[0;33m'

# setup dir
WORK_DIR=$(pwd)
KERN_IMG="${WORK_DIR}/out/arch/arm64/boot/Image-gz.dtb"
KERN_IMG2="${WORK_DIR}/out/arch/arm64/boot/Image.gz"

function clean() {
    echo -e "\n"
    echo -e "$red << cleaning up >> \n$white"
    echo -e "\n"
    rm -rf out
}

function build_kernel() {
    export PATH="/home/akufarish/proton-clang/bin:$PATH"
    make -j$(nproc --all) O=out ARCH=arm64 silont_defconfig
    make -j$(nproc --all) ARCH=arm64 O=out \
                          CC=clang \
                          CROSS_COMPILE=aarch64-linux-gnu- \
                          CROSS_COMPILE_ARM32=arm-linux-gnueabi-
    if [ -e "$KERN_IMG" ] || [ -e "$KERN_IMG2" ]; then
        echo -e "\n"
        echo -e "$green << compile kernel success! >> \n$white"
        echo -e "\n"
    else
        echo -e "\n"
        echo -e "$red << compile kernel failed! >> \n$white"
        echo -e "\n"
    fi

    cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
}

function zipping() {
    cd AnyKernel || exit 1
    zip -r9 Silont-Morgan-realme_sdm710-${TANGGAL}.zip *
    cd ..
}

# execute
clean
build_kernel
zipping