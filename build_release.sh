#!/bin/bash
set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$PROJECT_ROOT/build_release"
TARGET_NAME="Tetris"
CLEAN=0

for arg in "$@"; do
    case "$arg" in
        --clean)
            CLEAN=1
            ;;
        *)
            echo "ERROR: Unknown argument '$arg'"
            echo "Usage: $0 [--clean]"
            exit 1
            ;;
    esac
done

if [ "$CLEAN" -eq 1 ]; then
    echo "=== Removing existing Release build directory ==="
    rm -rf "$BUILD_DIR"
fi

if [ ! -d "$BUILD_DIR" ] || [ ! -f "$BUILD_DIR/CMakeCache.txt" ]; then
    echo "=== Configuring Release build ==="
    cmake -S "$PROJECT_ROOT" -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=Release
fi

echo "=== Building Release target: $TARGET_NAME ==="
cmake --build "$BUILD_DIR" --target "$TARGET_NAME" --parallel

echo "=== Copying executable to project root ==="
BUILT_EXE=$(find "$BUILD_DIR" -path "*/$TARGET_NAME" -type f -executable | head -1)

if [ -z "$BUILT_EXE" ]; then
    echo "ERROR: Could not find executable '$TARGET_NAME' in $BUILD_DIR"
    exit 1
fi

cp "$BUILT_EXE" "$PROJECT_ROOT/$TARGET_NAME"
chmod +x "$PROJECT_ROOT/$TARGET_NAME"
echo "Copied $TARGET_NAME from $BUILT_EXE"

echo ""
echo "=== Done! ==="
echo "Executable: $TARGET_NAME"
echo "Path: $PROJECT_ROOT/$TARGET_NAME"
echo "Run with: ./$TARGET_NAME"
echo "Run from the project root so shaders/resources resolve correctly."
