#ifndef COLLECTOR_WRAPPER_H
#define COLLECTOR_WRAPPER_H

#ifdef _WIN32
    #ifdef COLLECTOR_WRAPPER_EXPORTS
        #define COLLECTOR_API __declspec(dllexport)
    #else
        #define COLLECTOR_API __declspec(dllimport)
    #endif
#else
    #define COLLECTOR_API
#endif

#ifdef __cplusplus
extern "C" {
#endif

// Initialize and cleanup functions
COLLECTOR_API int init_collector(void);
COLLECTOR_API void cleanup_collector(void);

// List functions for each media type
COLLECTOR_API void list_movies(int* return_code);
COLLECTOR_API void list_tvseries(int* return_code);
COLLECTOR_API void list_anime(int* return_code);
COLLECTOR_API void list_games(int* return_code);
COLLECTOR_API void list_manga(int* return_code);
COLLECTOR_API void list_comics(int* return_code);
COLLECTOR_API void list_books(int* return_code);
COLLECTOR_API void list_magazines(int* return_code);

#ifdef __cplusplus
}
#endif

#endif // COLLECTOR_WRAPPER_H 