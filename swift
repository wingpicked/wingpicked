# Install Swift
cd "$BUILD_DIR"
SWIFT_PREFIX="$(swiftenv prefix || true)"
if ! [ -d "$SWIFT_PREFIX" ]; then
  VERSION="$(env DONT_CHECK=true swiftenv version-name)"
  puts-step "Installing $VERSION"
  swiftenv install
fi
