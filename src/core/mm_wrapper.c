#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <libcob.h>
#include "mediamatrix/core/mediamatrix.h"

#define MAX_OUTPUT_SIZE 32768

static char output_buffer[MAX_OUTPUT_SIZE];
static int output_pos = 0;
static int cob_initialized = 0;

// Helper function to capture output
static void capture_output(const char* format, ...) {
    va_list args;
    va_start(args, format);
    int remaining = MAX_OUTPUT_SIZE - output_pos;
    if (remaining > 0) {
        output_pos += vsnprintf(output_buffer + output_pos, remaining, format, args);
    }
    va_end(args);
}

// Initialize GnuCOBOL runtime
static void ensure_cob_initialized() {
    if (!cob_initialized) {
        cob_init(0, NULL);
        cob_initialized = 1;
    }
}

// List items with search and filter parameters
__declspec(dllexport) const char* list_items_wrapper(const char* search_text,
                      const char* search_genre, const char* search_media_type,
                      int year_min, int year_max, int rating_min) {
    ensure_cob_initialized();
    int return_code = 0;
    char* cobol_search_text = strdup(search_text ? search_text : "");
    char* cobol_search_genre = strdup(search_genre ? search_genre : "");
    char* cobol_search_media_type = strdup(search_media_type ? search_media_type : "");
    
    output_pos = 0;
    list_items(&return_code, cobol_search_text, cobol_search_genre,
               cobol_search_media_type, &year_min, &year_max, &rating_min);
    
    free(cobol_search_text);
    free(cobol_search_genre);
    free(cobol_search_media_type);
    return output_buffer;
}

// Add a new item
__declspec(dllexport) int add_item_wrapper(const char* title, const char* genre,
                      const char* media_type, int year, int rating,
                      const char* description) {
    ensure_cob_initialized();
    int return_code = 0;
    char* cobol_title = strdup(title ? title : "");
    char* cobol_genre = strdup(genre ? genre : "");
    char* cobol_media_type = strdup(media_type ? media_type : "");
    char* cobol_description = strdup(description ? description : "");
    
    add_item(&return_code, cobol_title, cobol_genre, cobol_media_type,
             &year, &rating, cobol_description);
    
    free(cobol_title);
    free(cobol_genre);
    free(cobol_media_type);
    free(cobol_description);
    return return_code;
}

// Edit an existing item
__declspec(dllexport) int edit_item_wrapper(int item_id, const char* title,
                      const char* genre, const char* media_type,
                      int year, int rating, const char* description) {
    ensure_cob_initialized();
    int return_code = 0;
    char* cobol_title = strdup(title ? title : "");
    char* cobol_genre = strdup(genre ? genre : "");
    char* cobol_media_type = strdup(media_type ? media_type : "");
    char* cobol_description = strdup(description ? description : "");
    
    edit_item(&return_code, &item_id, cobol_title, cobol_genre,
              cobol_media_type, &year, &rating, cobol_description);
    
    free(cobol_title);
    free(cobol_genre);
    free(cobol_media_type);
    free(cobol_description);
    return return_code;
}

// Delete an item
__declspec(dllexport) int delete_item_wrapper(int item_id) {
    ensure_cob_initialized();
    int return_code = 0;
    delete_item(&return_code, &item_id);
    return return_code;
} 