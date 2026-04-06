# Gravitas Tetris

Gravitas Tetris is a standalone C++ Tetris project built on a custom ECS-based engine included in this repository as a Git submodule. It implements modern Tetris mechanics such as ghost pieces, hold, next-piece preview, and hard drop.

## Built With

This project is built on top of the **Gravitas Engine**, a custom ECS-driven rendering and simulation engine.

The engine is included as a git submodule and provides:

- ECS architecture
- rendering pipeline (Vulkan)
- input handling
- camera systems

Gravitas Engine: https://github.com/nyantropy/Gravitas

## Requirements

- CMake
- A C++ compiler with C++20 support: GCC, Clang, or MSVC
- Git, including submodule support

### Windows

- [CMake](https://cmake.org/)
- [Ninja](https://ninja-build.org/)
- A C++ compiler: MSVC (Visual Studio Build Tools), clang, or MinGW (`gcc`)

⚠️ **Important:**  
Both **Ninja** and your **C++ compiler must be available in your system PATH**.

If they are not in PATH, the build will fail.

## Clone And Initialize Submodules

The engine lives in `/engine` as a Git submodule. You must initialize it before configuring or building the project.

```bash
git clone https://github.com/nyantropy/GtsTetris.git
cd GtsTetris
git submodule update --init --recursive
```

## Build On Linux

Use the standard CMake flow:

```bash
mkdir build
cd build
cmake ..
make
```

This produces the `Tetris` executable in the build directory.

Alternatively, you can also use the build_linux.sh script that is provided in the root directory.

## Windows Build (Recommended: Ninja)

This project uses Ninja for builds on Windows to avoid toolchain inconsistencies with MinGW and Visual Studio generators.

> ⚠️ **Important**
> The build script (`build_windows.bat`) requires:
> - `ninja` to be available in PATH
> - a working C++ compiler in PATH
>
> If either is missing, the script will fail.

### Requirements

- CMake
- Ninja
- A C++ compiler with C++20 support (MSVC, clang, g++)
- Git, including submodule support

### Build Instructions

```bash
git clone https://github.com/nyantropy/GtsTetris.git
cd GtsTetris
git submodule update --init --recursive
mkdir build
cd build
cmake .. -G Ninja
cmake --build .
```

For a Release build, configure with:

```bash
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release
```

The built executable will be available at:

```text
build\Tetris.exe
```

### One-Click Build

Alternatively, run:

```bat
build_windows.bat
```

The script:

- initializes Git submodules
- configures the project with CMake and the Ninja generator
- builds the project with `cmake --build .`

If you are using a GCC-like toolchain with Ninja and specifically need static runtime linking, you can add:

```text
-DCMAKE_EXE_LINKER_FLAGS="-static -static-libgcc -static-libstdc++"
```

Do not use those linker flags with MSVC-based toolchains.

### Troubleshooting

If the build fails immediately:

- Run `ninja --version` in your terminal
- Run your compiler, for example `cl`, `g++`, or `clang++`

If these commands are not recognized, they are not in your PATH and must be configured before building.

## Running The Game

Run the built executable from the build directory:

```bash
./Tetris
```

On Windows:

```bat
Tetris.exe
```

The `resources` directory must be next to the executable at runtime. The CMake build copies it automatically after building.

## Controls

- A / D: move
- Q / E: rotate
- Left/Right Arrow: rotate camera
- Space: hard drop
- R: hold
- X: pause

## Notes

- This project is built on a custom engine included as a submodule.
- The engine version is locked to the submodule revision in this repository.
- There is no save system; high score tracking is session-only.
