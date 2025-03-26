#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
#include "collector_wrapper.h"

// Function pointer types
typedef int (*InitCollectorFunc)(int*);
typedef int (*MainParagraphFunc)(int*);
typedef void (*ListMoviesFunc)(int*);
typedef void (*ListTVSeriesFunc)(int*);
typedef void (*ListAnimeFunc)(int*);
typedef void (*ListGamesFunc)(int*);
typedef void (*ListMangaFunc)(int*);
typedef void (*ListComicsFunc)(int*);
typedef void (*ListBooksFunc)(int*);
typedef void (*ListMagazinesFunc)(int*);

// Global variables
HMODULE hDll = NULL;
InitCollectorFunc init_collector_ptr = NULL;
MainParagraphFunc main_paragraph = NULL;
ListMoviesFunc list_movies_ptr = NULL;
ListTVSeriesFunc list_tvseries_ptr = NULL;
ListAnimeFunc list_anime_ptr = NULL;
ListGamesFunc list_games_ptr = NULL;
ListMangaFunc list_manga_ptr = NULL;
ListComicsFunc list_comics_ptr = NULL;
ListBooksFunc list_books_ptr = NULL;
ListMagazinesFunc list_magazines_ptr = NULL;

// Helper function to try loading DLL from a specific path
static HMODULE try_load_dll(const char* path) {
    HMODULE dll = LoadLibrary(path);
    if (dll) {
        printf("Successfully loaded DLL from: %s\n", path); fflush(stdout);
    }
    return dll;
}

// Initialize the COBOL environment and load functions
int init_collector(void) {
    printf("Initializing collector...\n"); fflush(stdout);
    
    // Get the full path of the executable
    char exe_path[MAX_PATH];
    char dll_path[MAX_PATH];
    
    if (GetModuleFileName(NULL, exe_path, MAX_PATH) == 0) {
        printf("Failed to get executable path. Error: %lu\n", GetLastError()); fflush(stdout);
        return 1;
    }
    printf("Executable path: %s\n", exe_path); fflush(stdout);
    
    // Try loading from executable directory first
    strcpy(dll_path, exe_path);
    char* last_backslash = strrchr(dll_path, '\\');
    if (last_backslash) {
        strcpy(last_backslash + 1, "collector.dll");
        printf("Attempting to load DLL from: %s\n", dll_path); fflush(stdout);
        hDll = try_load_dll(dll_path);
    }
    
    // If that fails, try current directory
    if (!hDll) {
        printf("Attempting to load DLL from current directory\n"); fflush(stdout);
        hDll = try_load_dll("collector.dll");
    }
    
    // If that fails, try parent directory
    if (!hDll && last_backslash) {
        *last_backslash = '\0';
        last_backslash = strrchr(dll_path, '\\');
        if (last_backslash) {
            strcpy(last_backslash + 1, "collector.dll");
            printf("Attempting to load DLL from parent: %s\n", dll_path); fflush(stdout);
            hDll = try_load_dll(dll_path);
        }
    }
    
    // If we still haven't found it, give up
    if (!hDll) {
        printf("Failed to load collector.dll from any location\n"); fflush(stdout);
        return 1;
    }

    // Get COBOL init function first
    printf("Looking for function: init_collector\n"); fflush(stdout);
    init_collector_ptr = (InitCollectorFunc)GetProcAddress(hDll, "init_collector");
    if (!init_collector_ptr) {
        printf("Failed to find init_collector. Error: %lu\n", GetLastError());
        goto cleanup;
    }

    // Call COBOL initialization
    int cobol_return_code = 0;
    init_collector_ptr(&cobol_return_code);
    if (cobol_return_code != 0) {
        printf("COBOL initialization failed with code: %d\n", cobol_return_code);
        goto cleanup;
    }
    
    // Get remaining function addresses
    printf("Looking for function: main_paragraph\n"); fflush(stdout);
    main_paragraph = (MainParagraphFunc)GetProcAddress(hDll, "main_paragraph");
    if (!main_paragraph) {
        printf("Failed to find main_paragraph. Error: %lu\n", GetLastError());
        goto cleanup;
    }
    
    printf("Looking for function: list_movies\n"); fflush(stdout);
    list_movies_ptr = (ListMoviesFunc)GetProcAddress(hDll, "list_movies");
    if (!list_movies_ptr) {
        printf("Failed to find list_movies. Error: %lu\n", GetLastError());
        goto cleanup;
    }
    
    printf("Looking for function: list_tvseries\n"); fflush(stdout);
    list_tvseries_ptr = (ListTVSeriesFunc)GetProcAddress(hDll, "list_tvseries");
    if (!list_tvseries_ptr) {
        printf("Failed to find list_tvseries. Error: %lu\n", GetLastError());
        goto cleanup;
    }
    
    printf("Looking for function: list_anime\n"); fflush(stdout);
    list_anime_ptr = (ListAnimeFunc)GetProcAddress(hDll, "list_anime");
    if (!list_anime_ptr) {
        printf("Failed to find list_anime. Error: %lu\n", GetLastError());
        goto cleanup;
    }
    
    printf("Looking for function: list_games\n"); fflush(stdout);
    list_games_ptr = (ListGamesFunc)GetProcAddress(hDll, "list_games");
    if (!list_games_ptr) {
        printf("Failed to find list_games. Error: %lu\n", GetLastError());
        goto cleanup;
    }
    
    printf("Looking for function: list_manga\n"); fflush(stdout);
    list_manga_ptr = (ListMangaFunc)GetProcAddress(hDll, "list_manga");
    if (!list_manga_ptr) {
        printf("Failed to find list_manga. Error: %lu\n", GetLastError());
        goto cleanup;
    }
    
    printf("Looking for function: list_comics\n"); fflush(stdout);
    list_comics_ptr = (ListComicsFunc)GetProcAddress(hDll, "list_comics");
    if (!list_comics_ptr) {
        printf("Failed to find list_comics. Error: %lu\n", GetLastError());
        goto cleanup;
    }
    
    printf("Looking for function: list_books\n"); fflush(stdout);
    list_books_ptr = (ListBooksFunc)GetProcAddress(hDll, "list_books");
    if (!list_books_ptr) {
        printf("Failed to find list_books. Error: %lu\n", GetLastError());
        goto cleanup;
    }
    
    printf("Looking for function: list_magazines\n"); fflush(stdout);
    list_magazines_ptr = (ListMagazinesFunc)GetProcAddress(hDll, "list_magazines");
    if (!list_magazines_ptr) {
        printf("Failed to find list_magazines. Error: %lu\n", GetLastError());
        goto cleanup;
    }
    
    // Check if all functions were loaded successfully
    if (!main_paragraph || !list_movies_ptr || !list_tvseries_ptr || !list_anime_ptr ||
        !list_games_ptr || !list_manga_ptr || !list_comics_ptr || !list_books_ptr ||
        !list_magazines_ptr) {
        printf("Failed to get all function addresses\n"); fflush(stdout);
        goto cleanup;
    }
    printf("Successfully loaded all function addresses\n"); fflush(stdout);
    
    return 0;

cleanup:
    if (hDll != NULL) {
        FreeLibrary(hDll);
        hDll = NULL;
    }
    return 1;
}

// Clean up resources
void cleanup_collector(void) {
    if (hDll != NULL) {
        FreeLibrary(hDll);
        hDll = NULL;
    }
}

// Wrapper functions for each media type
void list_movies(int* return_code) {
    if (list_movies_ptr) {
        list_movies_ptr(return_code);
    }
}

void list_tvseries(int* return_code) {
    if (list_tvseries_ptr) {
        list_tvseries_ptr(return_code);
    }
}

void list_anime(int* return_code) {
    if (list_anime_ptr) {
        list_anime_ptr(return_code);
    }
}

void list_games(int* return_code) {
    if (list_games_ptr) {
        list_games_ptr(return_code);
    }
}

void list_manga(int* return_code) {
    if (list_manga_ptr) {
        list_manga_ptr(return_code);
    }
}

void list_comics(int* return_code) {
    if (list_comics_ptr) {
        list_comics_ptr(return_code);
    }
}

void list_books(int* return_code) {
    if (list_books_ptr) {
        list_books_ptr(return_code);
    }
}

void list_magazines(int* return_code) {
    if (list_magazines_ptr) {
        list_magazines_ptr(return_code);
    }
}

// Main entry point for console mode
int main(int argc, char *argv[]) {
    if (argc > 1 && strcmp(argv[1], "--console") == 0) {
        // Console mode
        if (init_collector()) {
            printf("Failed to initialize collector\n");
            return 1;
        }
        int return_code = 0;
        main_paragraph(&return_code);
        cleanup_collector();
        return return_code;
    }
    
    // GUI mode - this will be handled by the Qt application
    printf("Please run collector.exe --console for console mode\n");
    return 0;
} 