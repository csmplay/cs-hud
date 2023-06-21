#!/bin/bash

# This script is called from within the Docker container created by build.sh.
# Run build.sh instead. Don't run this script directly.

# build the main executables
yarn --frozen-lockfile
yarn licenses generate-disclaimer > assets/licenses.txt
npx esbuild src/server/index.js --bundle --platform=node --outfile=csgo-hud.js
npx pkg --config build/pkg.json csgo-hud.js # --debug

# build Electron-based wrappers
cd src/electron
yarn --frozen-lockfile

node write-package-json.mjs csgo-hud hud.js
yarn electron-forge package -p linux
yarn electron-forge package -p win32

node write-package-json.mjs csgo-hud-config config.js
yarn electron-forge package -p linux
yarn electron-forge package -p win32

node write-package-json.mjs csgo-hud-radar radar.js
yarn electron-forge package -p linux
yarn electron-forge package -p win32

mv out/* /home/node/bin
