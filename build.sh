#!/bin/bash

PLATFORM=macos

ROOT_DIR="./"
DEST_DIR="./lib/bin"

mkdir -p "${DEST_DIR}"

# copy binary file
echo "📦 Copying binary file..."
SRC_DIR="${ROOT_DIR}/bin/macos"
BINARY_FILE="pcl6mac"
cp "${SRC_DIR}/${BINARY_FILE}" "${DEST_DIR}/${BINARY_FILE}"

# clean up previous build
echo "🧹 Cleaning up previous build..."
rm ./installers/dmg_creator/pcl-viewer.dmg

# build
flutter build ${PLATFORM}

echo "🚀 Bundling ${PLATFORM} installer..."
cd installers/dmg_creator && npx appdmg ./config.json ./pcl-viewer.dmg

# cleanup
echo "🧹 Finishing"
cd .. && cd ..
rm -rf "${DEST_DIR}"