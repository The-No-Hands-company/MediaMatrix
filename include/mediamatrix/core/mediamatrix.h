#ifndef MEDIAMATRIX_H
#define MEDIAMATRIX_H

#ifdef __cplusplus
extern "C" {
#endif

// COBOL function declarations
extern void init_mediamatrix(int* return_code);
extern void list_items(int* return_code, char* search_text, char* search_genre,
                      char* search_media_type, int* year_min, int* year_max,
                      int* rating_min);
extern void add_item(int* return_code, char* title, char* genre,
                    char* media_type, int* year, int* rating,
                    char* description);
extern void edit_item(int* return_code, int* item_id, char* title,
                     char* genre, char* media_type, int* year,
                     int* rating, char* description);
extern void delete_item(int* return_code, int* item_id);

// Initialize and cleanup functions
__declspec(dllexport) int init_mediamatrix_wrapper();
__declspec(dllexport) int cleanup_mediamatrix_wrapper();

// List items with search and filter parameters
__declspec(dllexport) const char* list_items_wrapper(const char* search_text,
                      const char* search_genre, const char* search_media_type,
                      int year_min, int year_max, int rating_min);

// Add a new item
__declspec(dllexport) int add_item_wrapper(const char* title, const char* genre,
                      const char* media_type, int year, int rating,
                      const char* description);

// Edit an existing item
__declspec(dllexport) int edit_item_wrapper(int item_id, const char* title,
                      const char* genre, const char* media_type,
                      int year, int rating, const char* description);

// Delete an item
__declspec(dllexport) int delete_item_wrapper(int item_id);

#ifdef __cplusplus
}
#endif

#endif // MEDIAMATRIX_H 