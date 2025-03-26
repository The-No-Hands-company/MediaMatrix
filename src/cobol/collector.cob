       IDENTIFICATION DIVISION.
       PROGRAM-ID. COLLECTOR.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MOVIES-FILE ASSIGN TO "movies.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TVSERIES-FILE ASSIGN TO "tvseries.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT ANIME-FILE ASSIGN TO "anime.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT GAMES-FILE ASSIGN TO "games.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT MANGA-FILE ASSIGN TO "manga.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT COMICS-FILE ASSIGN TO "comics.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT BOOKS-FILE ASSIGN TO "books.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT MAGAZINES-FILE ASSIGN TO "magazines.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD MOVIES-FILE.
       01 MOVIE-RECORD.
           05 MOVIE-TITLE           PIC X(100).
           05 MOVIE-YEAR            PIC 9(4).
           05 MOVIE-GENRE           PIC X(50).
           05 MOVIE-RATING          PIC 9(2).
           05 MOVIE-NOTES           PIC X(200).
       
       FD TVSERIES-FILE.
       01 TVSERIES-RECORD.
           05 TVSERIES-TITLE        PIC X(100).
           05 TVSERIES-YEAR         PIC 9(4).
           05 TVSERIES-GENRE        PIC X(50).
           05 TVSERIES-RATING       PIC 9(2).
           05 TVSERIES-NOTES        PIC X(200).
       
       FD ANIME-FILE.
       01 ANIME-RECORD.
           05 ANIME-TITLE           PIC X(100).
           05 ANIME-YEAR            PIC 9(4).
           05 ANIME-GENRE           PIC X(50).
           05 ANIME-RATING          PIC 9(2).
           05 ANIME-NOTES           PIC X(200).
       
       FD GAMES-FILE.
       01 GAME-RECORD.
           05 GAME-TITLE            PIC X(100).
           05 GAME-YEAR             PIC 9(4).
           05 GAME-GENRE            PIC X(50).
           05 GAME-RATING           PIC 9(2).
           05 GAME-NOTES            PIC X(200).
       
       FD MANGA-FILE.
       01 MANGA-RECORD.
           05 MANGA-TITLE           PIC X(100).
           05 MANGA-YEAR            PIC 9(4).
           05 MANGA-GENRE           PIC X(50).
           05 MANGA-RATING          PIC 9(2).
           05 MANGA-NOTES           PIC X(200).
       
       FD COMICS-FILE.
       01 COMIC-RECORD.
           05 COMIC-TITLE           PIC X(100).
           05 COMIC-YEAR            PIC 9(4).
           05 COMIC-GENRE           PIC X(50).
           05 COMIC-RATING          PIC 9(2).
           05 COMIC-NOTES           PIC X(200).
       
       FD BOOKS-FILE.
       01 BOOK-RECORD.
           05 BOOK-TITLE            PIC X(100).
           05 BOOK-YEAR            PIC 9(4).
           05 BOOK-GENRE           PIC X(50).
           05 BOOK-RATING          PIC 9(2).
           05 BOOK-NOTES           PIC X(200).
       
       FD MAGAZINES-FILE.
       01 MAGAZINE-RECORD.
           05 MAGAZINE-TITLE        PIC X(100).
           05 MAGAZINE-YEAR         PIC 9(4).
           05 MAGAZINE-GENRE        PIC X(50).
           05 MAGAZINE-RATING       PIC 9(2).
           05 MAGAZINE-NOTES        PIC X(200).
       
       WORKING-STORAGE SECTION.
       01 WS-CHOICE PIC 9 VALUE 0.
       01 WS-SUBCHOICE PIC 9 VALUE 0.
       01 WS-EOF PIC X VALUE 'N'.
       01 WS-RECORD-COUNT PIC 9(4) VALUE 0.
       01 WS-INPUT-VALID PIC X VALUE 'N'.
       01 WS-FILES-OPEN PIC X VALUE 'N'.
       01 WS-FILE-MODE PIC X VALUE 'I'.
       
       LINKAGE SECTION.
       01 WS-RETURN-CODE PIC S9(9) COMP-5.
       
       PROCEDURE DIVISION.
           ENTRY "init_collector" USING WS-RETURN-CODE.
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.

           ENTRY "cleanup_collector" USING WS-RETURN-CODE.
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.

           ENTRY "main_paragraph" USING WS-RETURN-CODE.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'Y' TO WS-FILES-OPEN
           PERFORM UNTIL WS-CHOICE = 9
               DISPLAY "=== COLLECTOR - Media Collection Manager ==="
               DISPLAY "1. Movies"
               DISPLAY "2. TV Series"
               DISPLAY "3. Anime"
               DISPLAY "4. Games"
               DISPLAY "5. Manga"
               DISPLAY "6. Comics"
               DISPLAY "7. Books"
               DISPLAY "8. Magazines"
               DISPLAY "9. Exit"
               DISPLAY "Enter your choice (1-9): " WITH NO ADVANCING
               ACCEPT WS-CHOICE
               
               IF WS-CHOICE NOT = 9
                   PERFORM MEDIA-MENU
               END-IF
           END-PERFORM
           PERFORM CLOSE-FILES
           MOVE 'N' TO WS-FILES-OPEN
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.

           ENTRY "list_movies" USING WS-RETURN-CODE.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'Y' TO WS-FILES-OPEN
           PERFORM LIST-MOVIES
           PERFORM CLOSE-FILES
           MOVE 'N' TO WS-FILES-OPEN
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.

           ENTRY "list_tvseries" USING WS-RETURN-CODE.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'Y' TO WS-FILES-OPEN
           PERFORM LIST-TVSERIES
           PERFORM CLOSE-FILES
           MOVE 'N' TO WS-FILES-OPEN
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.

           ENTRY "list_anime" USING WS-RETURN-CODE.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'Y' TO WS-FILES-OPEN
           PERFORM LIST-ANIME
           PERFORM CLOSE-FILES
           MOVE 'N' TO WS-FILES-OPEN
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.

           ENTRY "list_games" USING WS-RETURN-CODE.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'Y' TO WS-FILES-OPEN
           PERFORM LIST-GAMES
           PERFORM CLOSE-FILES
           MOVE 'N' TO WS-FILES-OPEN
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.

           ENTRY "list_manga" USING WS-RETURN-CODE.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'Y' TO WS-FILES-OPEN
           PERFORM LIST-MANGA
           PERFORM CLOSE-FILES
           MOVE 'N' TO WS-FILES-OPEN
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.

           ENTRY "list_comics" USING WS-RETURN-CODE.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'Y' TO WS-FILES-OPEN
           PERFORM LIST-COMICS
           PERFORM CLOSE-FILES
           MOVE 'N' TO WS-FILES-OPEN
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.

           ENTRY "list_books" USING WS-RETURN-CODE.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'Y' TO WS-FILES-OPEN
           PERFORM LIST-BOOKS
           PERFORM CLOSE-FILES
           MOVE 'N' TO WS-FILES-OPEN
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.

           ENTRY "list_magazines" USING WS-RETURN-CODE.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'Y' TO WS-FILES-OPEN
           PERFORM LIST-MAGAZINES
           PERFORM CLOSE-FILES
           MOVE 'N' TO WS-FILES-OPEN
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.
       
       INITIALIZE-FILES.
           IF WS-FILES-OPEN = 'N'
               IF WS-FILE-MODE = "I"
                   OPEN INPUT MOVIES-FILE
                   OPEN INPUT TVSERIES-FILE
                   OPEN INPUT ANIME-FILE
                   OPEN INPUT GAMES-FILE
                   OPEN INPUT MANGA-FILE
                   OPEN INPUT COMICS-FILE
                   OPEN INPUT BOOKS-FILE
                   OPEN INPUT MAGAZINES-FILE
               ELSE
                   OPEN EXTEND MOVIES-FILE
                   OPEN EXTEND TVSERIES-FILE
                   OPEN EXTEND ANIME-FILE
                   OPEN EXTEND GAMES-FILE
                   OPEN EXTEND MANGA-FILE
                   OPEN EXTEND COMICS-FILE
                   OPEN EXTEND BOOKS-FILE
                   OPEN EXTEND MAGAZINES-FILE
               END-IF
           END-IF.
       
       CLOSE-FILES.
           IF WS-FILES-OPEN = 'Y'
               CLOSE MOVIES-FILE
               CLOSE TVSERIES-FILE
               CLOSE ANIME-FILE
               CLOSE GAMES-FILE
               CLOSE MANGA-FILE
               CLOSE COMICS-FILE
               CLOSE BOOKS-FILE
               CLOSE MAGAZINES-FILE
           END-IF.
       
       MEDIA-MENU.
           MOVE 0 TO WS-SUBCHOICE
           PERFORM UNTIL WS-SUBCHOICE = 5
               DISPLAY "=== Media Management ==="
               DISPLAY "1. List All"
               DISPLAY "2. Add New"
               DISPLAY "3. Edit"
               DISPLAY "4. Delete"
               DISPLAY "5. Back to Main Menu"
               DISPLAY "Enter your choice (1-5): " WITH NO ADVANCING
               ACCEPT WS-SUBCHOICE
               
               EVALUATE WS-SUBCHOICE
                   WHEN 1 
                       MOVE "I" TO WS-FILE-MODE
                       PERFORM CLOSE-FILES
                       MOVE "N" TO WS-FILES-OPEN
                       PERFORM LIST-ALL
                   WHEN 2 
                       MOVE "O" TO WS-FILE-MODE
                       PERFORM CLOSE-FILES
                       MOVE "N" TO WS-FILES-OPEN
                       PERFORM ADD-NEW
                   WHEN 3 PERFORM EDIT-ITEM
                   WHEN 4 PERFORM DELETE-ITEM
                   WHEN 5 CONTINUE
                   WHEN OTHER
                       DISPLAY "Invalid choice. Please try again."
               END-EVALUATE
           END-PERFORM.
       
       LIST-ALL.
           EVALUATE WS-CHOICE
               WHEN 1 PERFORM LIST-MOVIES
               WHEN 2 PERFORM LIST-TVSERIES
               WHEN 3 PERFORM LIST-ANIME
               WHEN 4 PERFORM LIST-GAMES
               WHEN 5 PERFORM LIST-MANGA
               WHEN 6 PERFORM LIST-COMICS
               WHEN 7 PERFORM LIST-BOOKS
               WHEN 8 PERFORM LIST-MAGAZINES
           END-EVALUATE.
       
       ADD-NEW.
           EVALUATE WS-CHOICE
               WHEN 1 PERFORM ADD-MOVIE
               WHEN 2 PERFORM ADD-TVSERIES
               WHEN 3 PERFORM ADD-ANIME
               WHEN 4 PERFORM ADD-GAME
               WHEN 5 PERFORM ADD-MANGA
               WHEN 6 PERFORM ADD-COMIC
               WHEN 7 PERFORM ADD-BOOK
               WHEN 8 PERFORM ADD-MAGAZINE
           END-EVALUATE.
       
       EDIT-ITEM.
           EVALUATE WS-CHOICE
               WHEN 1 PERFORM EDIT-MOVIE
               WHEN 2 PERFORM EDIT-TVSERIES
               WHEN 3 PERFORM EDIT-ANIME
               WHEN 4 PERFORM EDIT-GAME
               WHEN 5 PERFORM EDIT-MANGA
               WHEN 6 PERFORM EDIT-COMIC
               WHEN 7 PERFORM EDIT-BOOK
               WHEN 8 PERFORM EDIT-MAGAZINE
           END-EVALUATE.
       
       DELETE-ITEM.
           EVALUATE WS-CHOICE
               WHEN 1 PERFORM DELETE-MOVIE
               WHEN 2 PERFORM DELETE-TVSERIES
               WHEN 3 PERFORM DELETE-ANIME
               WHEN 4 PERFORM DELETE-GAME
               WHEN 5 PERFORM DELETE-MANGA
               WHEN 6 PERFORM DELETE-COMIC
               WHEN 7 PERFORM DELETE-BOOK
               WHEN 8 PERFORM DELETE-MAGAZINE
           END-EVALUATE.
       
       LIST-MOVIES.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'N' TO WS-EOF
           MOVE 0 TO WS-RECORD-COUNT
           PERFORM UNTIL WS-EOF = 'Y'
               READ MOVIES-FILE
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-RECORD-COUNT
                       DISPLAY WS-RECORD-COUNT ". " MOVIE-TITLE
               END-READ
           END-PERFORM
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.
       
       LIST-TVSERIES.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'N' TO WS-EOF
           MOVE 0 TO WS-RECORD-COUNT
           PERFORM UNTIL WS-EOF = 'Y'
               READ TVSERIES-FILE
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-RECORD-COUNT
                       DISPLAY WS-RECORD-COUNT ". " TVSERIES-TITLE
               END-READ
           END-PERFORM
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.
       
       LIST-ANIME.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'N' TO WS-EOF
           MOVE 0 TO WS-RECORD-COUNT
           PERFORM UNTIL WS-EOF = 'Y'
               READ ANIME-FILE
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-RECORD-COUNT
                       DISPLAY WS-RECORD-COUNT ". " ANIME-TITLE
               END-READ
           END-PERFORM
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.
       
       LIST-GAMES.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'N' TO WS-EOF
           MOVE 0 TO WS-RECORD-COUNT
           PERFORM UNTIL WS-EOF = 'Y'
               READ GAMES-FILE
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-RECORD-COUNT
                       DISPLAY WS-RECORD-COUNT ". " GAME-TITLE
               END-READ
           END-PERFORM
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.
       
       LIST-MANGA.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'N' TO WS-EOF
           MOVE 0 TO WS-RECORD-COUNT
           PERFORM UNTIL WS-EOF = 'Y'
               READ MANGA-FILE
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-RECORD-COUNT
                       DISPLAY WS-RECORD-COUNT ". " MANGA-TITLE
               END-READ
           END-PERFORM
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.
       
       LIST-COMICS.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'N' TO WS-EOF
           MOVE 0 TO WS-RECORD-COUNT
           PERFORM UNTIL WS-EOF = 'Y'
               READ COMICS-FILE
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-RECORD-COUNT
                       DISPLAY WS-RECORD-COUNT ". " COMIC-TITLE
               END-READ
           END-PERFORM
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.
       
       LIST-BOOKS.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'N' TO WS-EOF
           MOVE 0 TO WS-RECORD-COUNT
           PERFORM UNTIL WS-EOF = 'Y'
               READ BOOKS-FILE
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-RECORD-COUNT
                       DISPLAY WS-RECORD-COUNT ". " BOOK-TITLE
               END-READ
           END-PERFORM
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.
       
       LIST-MAGAZINES.
           MOVE "I" TO WS-FILE-MODE
           PERFORM INITIALIZE-FILES
           MOVE 'N' TO WS-EOF
           MOVE 0 TO WS-RECORD-COUNT
           PERFORM UNTIL WS-EOF = 'Y'
               READ MAGAZINES-FILE
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-RECORD-COUNT
                       DISPLAY WS-RECORD-COUNT ". " MAGAZINE-TITLE
               END-READ
           END-PERFORM
           MOVE 0 TO WS-RETURN-CODE
           GOBACK.
       
       ADD-MOVIE.
           PERFORM INITIALIZE-FILES
           DISPLAY "Enter movie title: " WITH NO ADVANCING
           ACCEPT MOVIE-TITLE
           DISPLAY "Enter year: " WITH NO ADVANCING
           ACCEPT MOVIE-YEAR
           DISPLAY "Enter genre: " WITH NO ADVANCING
           ACCEPT MOVIE-GENRE
           DISPLAY "Enter rating (1-10): " WITH NO ADVANCING
           ACCEPT MOVIE-RATING
           DISPLAY "Enter notes: " WITH NO ADVANCING
           ACCEPT MOVIE-NOTES
           WRITE MOVIE-RECORD.
       
       ADD-TVSERIES.
           PERFORM INITIALIZE-FILES
           DISPLAY "Enter TV series title: " WITH NO ADVANCING
           ACCEPT TVSERIES-TITLE
           DISPLAY "Enter year: " WITH NO ADVANCING
           ACCEPT TVSERIES-YEAR
           DISPLAY "Enter genre: " WITH NO ADVANCING
           ACCEPT TVSERIES-GENRE
           DISPLAY "Enter rating (1-10): " WITH NO ADVANCING
           ACCEPT TVSERIES-RATING
           DISPLAY "Enter notes: " WITH NO ADVANCING
           ACCEPT TVSERIES-NOTES
           WRITE TVSERIES-RECORD.
       
       ADD-ANIME.
           PERFORM INITIALIZE-FILES
           DISPLAY "Enter anime title: " WITH NO ADVANCING
           ACCEPT ANIME-TITLE
           DISPLAY "Enter year: " WITH NO ADVANCING
           ACCEPT ANIME-YEAR
           DISPLAY "Enter genre: " WITH NO ADVANCING
           ACCEPT ANIME-GENRE
           DISPLAY "Enter rating (1-10): " WITH NO ADVANCING
           ACCEPT ANIME-RATING
           DISPLAY "Enter notes: " WITH NO ADVANCING
           ACCEPT ANIME-NOTES
           WRITE ANIME-RECORD.
       
       ADD-GAME.
           PERFORM INITIALIZE-FILES
           DISPLAY "Enter game title: " WITH NO ADVANCING
           ACCEPT GAME-TITLE
           DISPLAY "Enter year: " WITH NO ADVANCING
           ACCEPT GAME-YEAR
           DISPLAY "Enter genre: " WITH NO ADVANCING
           ACCEPT GAME-GENRE
           DISPLAY "Enter rating (1-10): " WITH NO ADVANCING
           ACCEPT GAME-RATING
           DISPLAY "Enter notes: " WITH NO ADVANCING
           ACCEPT GAME-NOTES
           WRITE GAME-RECORD.
       
       ADD-MANGA.
           PERFORM INITIALIZE-FILES
           DISPLAY "Enter manga title: " WITH NO ADVANCING
           ACCEPT MANGA-TITLE
           DISPLAY "Enter year: " WITH NO ADVANCING
           ACCEPT MANGA-YEAR
           DISPLAY "Enter genre: " WITH NO ADVANCING
           ACCEPT MANGA-GENRE
           DISPLAY "Enter rating (1-10): " WITH NO ADVANCING
           ACCEPT MANGA-RATING
           DISPLAY "Enter notes: " WITH NO ADVANCING
           ACCEPT MANGA-NOTES
           WRITE MANGA-RECORD.
       
       ADD-COMIC.
           PERFORM INITIALIZE-FILES
           DISPLAY "Enter comic title: " WITH NO ADVANCING
           ACCEPT COMIC-TITLE
           DISPLAY "Enter year: " WITH NO ADVANCING
           ACCEPT COMIC-YEAR
           DISPLAY "Enter genre: " WITH NO ADVANCING
           ACCEPT COMIC-GENRE
           DISPLAY "Enter rating (1-10): " WITH NO ADVANCING
           ACCEPT COMIC-RATING
           DISPLAY "Enter notes: " WITH NO ADVANCING
           ACCEPT COMIC-NOTES
           WRITE COMIC-RECORD.
       
       ADD-BOOK.
           PERFORM INITIALIZE-FILES
           DISPLAY "Enter book title: " WITH NO ADVANCING
           ACCEPT BOOK-TITLE
           DISPLAY "Enter year: " WITH NO ADVANCING
           ACCEPT BOOK-YEAR
           DISPLAY "Enter genre: " WITH NO ADVANCING
           ACCEPT BOOK-GENRE
           DISPLAY "Enter rating (1-10): " WITH NO ADVANCING
           ACCEPT BOOK-RATING
           DISPLAY "Enter notes: " WITH NO ADVANCING
           ACCEPT BOOK-NOTES
           WRITE BOOK-RECORD.
       
       ADD-MAGAZINE.
           PERFORM INITIALIZE-FILES
           DISPLAY "Enter magazine title: " WITH NO ADVANCING
           ACCEPT MAGAZINE-TITLE
           DISPLAY "Enter year: " WITH NO ADVANCING
           ACCEPT MAGAZINE-YEAR
           DISPLAY "Enter genre: " WITH NO ADVANCING
           ACCEPT MAGAZINE-GENRE
           DISPLAY "Enter rating (1-10): " WITH NO ADVANCING
           ACCEPT MAGAZINE-RATING
           DISPLAY "Enter notes: " WITH NO ADVANCING
           ACCEPT MAGAZINE-NOTES
           WRITE MAGAZINE-RECORD.
       
       EDIT-MOVIE.
           DISPLAY "Edit movie functionality to be implemented".
       
       EDIT-TVSERIES.
           DISPLAY "Edit TV series functionality to be implemented".
       
       EDIT-ANIME.
           DISPLAY "Edit anime functionality to be implemented".
       
       EDIT-GAME.
           DISPLAY "Edit game functionality to be implemented".
       
       EDIT-MANGA.
           DISPLAY "Edit manga functionality to be implemented".
       
       EDIT-COMIC.
           DISPLAY "Edit comic functionality to be implemented".
       
       EDIT-BOOK.
           DISPLAY "Edit book functionality to be implemented".
       
       EDIT-MAGAZINE.
           DISPLAY "Edit magazine functionality to be implemented".
       
       DELETE-MOVIE.
           DISPLAY "Delete movie functionality to be implemented".
       
       DELETE-TVSERIES.
           DISPLAY "Delete TV series functionality to be implemented".
       
       DELETE-ANIME.
           DISPLAY "Delete anime functionality to be implemented".
       
       DELETE-GAME.
           DISPLAY "Delete game functionality to be implemented".
       
       DELETE-MANGA.
           DISPLAY "Delete manga functionality to be implemented".
       
       DELETE-COMIC.
           DISPLAY "Delete comic functionality to be implemented".
       
       DELETE-BOOK.
           DISPLAY "Delete book functionality to be implemented".
       
       DELETE-MAGAZINE.
           DISPLAY "Delete magazine functionality to be implemented".
       
       END PROGRAM COLLECTOR. 