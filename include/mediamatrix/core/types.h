#ifndef MEDIAMATRIX_H
#define MEDIAMATRIX_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef _WIN32
#define MEDIAMATRIX_API __declspec(dllexport)
#else
#define MEDIAMATRIX_API
#endif

// Initialize the collector
MEDIAMATRIX_API int init_collector_wrapper(void);

// Cleanup the collector
MEDIAMATRIX_API int cleanup_collector_wrapper(void);

// List movies with search and filter parameters
MEDIAMATRIX_API const char* list_movies_wrapper(const char* search_text, const char* search_genre,
                                    int year_min, int year_max, int rating_min);

// List TV series with search and filter parameters
MEDIAMATRIX_API const char* list_tvseries_wrapper(const char* search_text, const char* search_genre,
                                      int year_min, int year_max, int rating_min);

// List anime with search and filter parameters
MEDIAMATRIX_API const char* list_anime_wrapper(const char* search_text, const char* search_genre,
                                   int year_min, int year_max, int rating_min);

// List games with search and filter parameters
MEDIAMATRIX_API const char* list_games_wrapper(const char* search_text, const char* search_genre,
                                   int year_min, int year_max, int rating_min);

// List manga with search and filter parameters
MEDIAMATRIX_API const char* list_manga_wrapper(const char* search_text, const char* search_genre,
                                   int year_min, int year_max, int rating_min);

// List comics with search and filter parameters
MEDIAMATRIX_API const char* list_comics_wrapper(const char* search_text, const char* search_genre,
                                    int year_min, int year_max, int rating_min);

// List books with search and filter parameters
MEDIAMATRIX_API const char* list_books_wrapper(const char* search_text, const char* search_genre,
                                   int year_min, int year_max, int rating_min);

// List magazines with search and filter parameters
MEDIAMATRIX_API const char* list_magazines_wrapper(const char* search_text, const char* search_genre,
                                      int year_min, int year_max, int rating_min);

#ifdef __cplusplus
}
#endif

#endif // MEDIAMATRIX_H 