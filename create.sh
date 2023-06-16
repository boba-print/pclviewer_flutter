#!/bin/bash

# input parameters
PLATFORM=$1

# check if platform is either 'macos' or 'windows'
if [ "${PLATFORM}" != "macos" ] && [ "${PLATFORM}" != "windows" ]; then
    echo "Error: Platform should be either 'macos' or 'windows'."
    exit 1
fi

# paths (make sure to replace these with actual paths in your system)
ROOT_DIR="./"
DEST_DIR="./lib/bin"

mkdir -p "${DEST_DIR}"

# copy binary file
if [ "${PLATFORM}" == "macos" ]; then
    SRC_DIR="${ROOT_DIR}/bin/macos"
    BINARY_FILE="pcl6mac"
    cp "${SRC_DIR}/${BINARY_FILE}" "${DEST_DIR}/${BINARY_FILE}"
elif [ "${PLATFORM}" == "windows" ]; then
    SRC_DIR="${ROOT_DIR}/bin/windows"
    BINARY_FILE1="gpcl6dll64.dll"
    BINARY_FILE2="gpcl6win64.exe"
    cp "${SRC_DIR}/${BINARY_FILE1}" "${DEST_DIR}/${BINARY_FILE1}"
    cp "${SRC_DIR}/${BINARY_FILE2}" "${DEST_DIR}/${BINARY_FILE2}"
fi

# build
flutter build ${PLATFORM}

# cleanup
if [ "${PLATFORM}" == "macos" ]; then
    rm "${DEST_DIR}/${BINARY_FILE}"
elif [ "${PLATFORM}" == "windows" ]; then
    rm "${DEST_DIR}/${BINARY_FILE1}"
    rm "${DEST_DIR}/${BINARY_FILE2}"
fi

# cleanup
rm -rf "${DEST_DIR}"
