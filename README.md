# MediaMatrix

A comprehensive media collection management application built with COBOL and Qt. This application helps users track and organize their collections across multiple media types:
- Movies
- TV Series
- Anime
- Games
- Manga
- Comics
- Books
- Magazines

## Features

- Modern Qt-based graphical interface
- Powerful COBOL backend for reliable data management
- Comprehensive collection tracking:
  - Organize items by media type
  - Track detailed information for each item
  - Maintain organized libraries of your collections
- Advanced search and filtering capabilities:
  - Search by title
  - Filter by genre
  - Filter by media type
  - Filter by year range
  - Filter by rating
- Full CRUD operations:
  - Add new items to your collections
  - Edit existing item details
  - Remove items from collections
  - View and browse your entire library
- Data persistence using COBOL indexed files for reliable storage

## Prerequisites

- GnuCOBOL 3.1.2 or later
- Qt 6.8.1 or later
- CMake 3.31.6 or later
- Visual Studio 2022 with C++ development tools
- PowerShell 7.0 or later

## Building

1. Clone the repository:
   ```powershell
   git clone https://github.com/yourusername/mediamatrix.git
   cd mediamatrix
   ```

2. Run the build script:
   ```powershell
   .\build.bat
   ```

The build script will:
- Initialize the Visual Studio environment
- Compile the COBOL program
- Generate the import library
- Build the Qt GUI application
- Copy all necessary DLLs to the output directory

## Running

After building, you can run the application from the build directory:

```powershell
.\build\Release\mediamatrix_gui.exe
```

## Project Structure

- `src/cobol/` - COBOL source files
  - `mediamatrix.cob` - Main COBOL program
- `src/core/` - C wrapper for COBOL functions
  - `mm_wrapper.c` - C wrapper implementation
- `src/gui/` - Qt GUI implementation
  - `main.cpp` - Application entry point
  - `mm_main_window.cpp` - Main window implementation
  - `mm_item_dialog.cpp` - Item dialog implementation
- `include/mediamatrix/` - Header files
  - `core/` - Core functionality headers
  - `gui/` - GUI headers
- `build.bat` - Build script

## Data Storage

The application stores data in `build/Release/data/items.dat`, which is a COBOL indexed file. Each record contains:
- Item ID
- Title
- Genre
- Media Type (Movie/TV Series/Anime/Game/Manga/Comic/Book/Magazine)
- Year
- Rating
- Notes

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

- Zajan (erichakansson84@gmail.com) 