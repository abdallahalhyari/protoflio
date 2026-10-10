.PHONY: all analyze test format format-check build deploy deploy-fast clean hooks

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
	flutter build web --wasm --release --no-tree-shake-icons --source-maps
	node patch_flutter_js.js


deploy: format-check analyze test build
	firebase deploy --only hosting

deploy-fast: build
	firebase deploy --only hosting

clean:
	flutter clean
	flutter pub get

# Point git at the repo's hooks (.githooks/pre-push: format + analyze on
# every push, tests too when pushing to main). Once per clone.
hooks:
	git config core.hooksPath .githooks
