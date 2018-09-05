#!/bin/bash
#
# Cronos Build Script
# For Exynos7870
# Coded by BlackMesa/AnanJaser1211/Prashantp01 @2018
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software

# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Directory Contol
CR_DIR=$(pwd)
CR_TC=/home/prashantp01/UBERTC-aarch64-linux-android-6.0/bin/aarch64-linux-android-
CR_DTS=arch/arm64/boot/dts
CR_DTB=$CR_DIR/boot.img-dtb
# Kernel Variables
CR_VERSION=V1.0
CR_NAME=Quantum_Kernel
CR_JOBS=5
CR_ANDROID=o
CR_PLATFORM=8.0.0
CR_ARCH=arm64
CR_DATE=$(date +%Y%m%d)
# Init build
export CROSS_COMPILE=$CR_TC
export ANDROID_MAJOR_VERSION=$CR_ANDROID
export PLATFORM_VERSION=$CR_PLATFORM
export $CR_ARCH
##########################################
# Device specific Variables [SM-J710F]
CR_DTSFILES_J710F="exynos7420-noblelte_eur_open_06.dtb"
CR_CONFG_J710F=j7xelte_03_defconfig
CR_VARIANT_J710F=J7xelte
##########################################

# Script functions
CLEAN_SOURCE()
{
echo "----------------------------------------------"
echo " "
echo "Cleaning"	
make clean
make mrproper
# rm -r -f $CR_OUT/*
rm -r -f $CR_DTB
rm -rf $CR_DTS/.*.tmp
rm -rf $CR_DTS/.*.cmd
rm -rf $CR_DTS/*.dtb 
echo " "
echo "----------------------------------------------"	
}
BUILD_ZIMAGE()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building zImage for $CR_VARIANT"	
	export LOCALVERSION=-$CR_NAME-$CR_VERSION-$CR_VARIANT-$CR_DATE
	make  $CR_CONFG
	make -j$CR_JOBS
	echo " "
	echo "----------------------------------------------"	
}
BUILD_DTB()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building DTB for $CR_VARIANT"	
	export $CR_ARCH
	export CROSS_COMPILE=$CR_TC
	export ANDROID_MAJOR_VERSION=$CR_ANDROID
	make  $CR_CONFG
	make $CR_DTSFILES
	./scripts/dtbTool/dtbTool -o ./boot.img-dtb -d $CR_DTS/ -s 2048
	du -k "./boot.img-dtb" | cut -f1 >sizT
	sizT=$(head -n 1 sizT)
	rm -rf sizT
	echo "Combined DTB Size = $sizT Kb"
	rm -rf $CR_DTS/.*.tmp
	rm -rf $CR_DTS/.*.cmd
	rm -rf $CR_DTS/*.dtb	
	echo " "
	echo "----------------------------------------------"
}

# Main Menu
clear
echo "----------------------------------------------"
echo "$CR_NAME $CR_VERSION Build Script"
echo "----------------------------------------------"
PS3='Please select your option : '
menuvar=("SM-J710F" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "SM-J710F")
            clear
            CLEAN_SOURCE
            echo "Starting $CR_VARIANT_J710F kernel build..."
	    CR_VARIANT=$CR_VARIANT_J710F
	    CR_CONFG=$CR_CONFG_J710F
	    CR_DTSFILES=$CR_DTSFILES_J710F
	    BUILD_ZIMAGE
	    BUILD_DTB
            echo " "
            echo "----------------------------------------------"
            echo "$CR_VARIANT kernel build finished."
	    echo "Press Any key to end the script"
 	    echo "Combined DTB Size = $sizT Kb"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
        "Exit")
            break
            ;;
        *) echo Invalid option.;;
    esac
done

