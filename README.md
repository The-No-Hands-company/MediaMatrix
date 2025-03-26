# MediaMatrix

A media collection management application built with COBOL and Qt. This application allows users to track their collections of movies, TV series, anime, games, manga, comics, books, and magazines.

## Features

- GUI interface built with Qt
- Console interface for command-line operations
- COBOL backend for data management
- Support for multiple media types:
  - Movies
  - TV Series
  - Anime
  - Games
  - Manga
  - Comics
  - Books
  - Magazines

## Prerequisites

- Visual Studio 2022 with C++ development tools
- CMake 3.10 or later
- Qt 6.8.1 (msvc2022_64)
- GnuCOBOL 3.1.2 or later
- Windows 10 or later

## Building the Application

1. Clone the repository:
   ```bash
   git clone https://github.com/The-No-Hands-company/MediaMatrix.git
   cd MediaMatrix
   ```

2. Run the build script:
   ```bash
   build.bat
   ```

3. The application will be built in the `build/bin` directory.

## Running the Application

You can run the application in two modes:

1. GUI Mode:
   ```bash
   build/bin/collector_gui.exe
   ```

2. Console Mode:
   ```bash
   build/bin/collector_wrapper.exe --console
   ```

## Project Structure

```
MediaMatrix/
├── build/           # Build directory (created during build)
├── data/           # Data files directory
├── include/        # Header files
├── src/
│   ├── c/         # C source files
│   ├── cpp/       # C++ source files
│   └── cobol/     # COBOL source files
├── build.bat      # Build script
├── CMakeLists.txt # CMake configuration
└── README.md      # This file
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

- Zajan (erichakansson84@gmail.com) 