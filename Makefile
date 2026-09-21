.PHONY: all analyze test format format-check build deploy deploy-fast clean

all: format-check analyze test build

format:
	dart format lib/ test/

format-check:
	dart format --output=none --set-exit-if-changed lib/ test/

analyze:
	flutter analyze

test:
	flutter test

build:
	flutter build web --wasm --release --tree-shake-icons --no-source-maps
	node patch_flutter_js.js

deploy: format-check analyze test build
	firebase deploy --only hosting

deploy-fast: build
	firebase deploy --only hosting

clean:
	flutter clean
	flutter pub get
