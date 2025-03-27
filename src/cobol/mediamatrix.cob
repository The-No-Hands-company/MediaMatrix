       IDENTIFICATION DIVISION.
       PROGRAM-ID. MEDIAMATRIX IS INITIAL.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ITEMS-FILE ASSIGN TO "data/items.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS ITEM-ID
               ALTERNATE RECORD KEY IS ITEM-TITLE WITH DUPLICATES
               FILE STATUS IS WS-FILE-STATUS.
       
       DATA DIVISION.
       FILE SECTION.
       FD ITEMS-FILE.
       01 ITEM-RECORD.
           05 ITEM-ID              PIC 9(6).
           05 ITEM-TITLE           PIC X(100).
           05 ITEM-YEAR            PIC 9(4).
           05 ITEM-GENRE           PIC X(50).
           05 ITEM-MEDIA-TYPE      PIC X(20).
           05 ITEM-RATING          PIC 9(2).
           05 ITEM-DESCRIPTION     PIC X(500).
       
       WORKING-STORAGE SECTION.
       01 WS-FILE-STATUS          PIC X(2).
       01 WS-FILE-MODE            PIC X.
       01 WS-FILES-OPEN           PIC X.
       01 WS-EOF                  PIC X.
       01 WS-RECORD-COUNT         PIC 9(6).
       01 WS-NEXT-ID             PIC 9(6).
       01 WS-SEARCH-TEXT         PIC X(100).
       01 WS-SEARCH-GENRE        PIC X(50).
       01 WS-SEARCH-MEDIA-TYPE   PIC X(20).
       01 WS-SEARCH-YEAR-MIN     PIC 9(4).
       01 WS-SEARCH-YEAR-MAX     PIC 9(4).
       01 WS-SEARCH-RATING-MIN   PIC 9(2).
       01 WS-MATCHES             PIC X VALUE 'Y'.
       01 WS-TITLE-MATCH         PIC 9(4) VALUE 0.
       01 WS-GENRE-MATCH         PIC X VALUE 'N'.
       01 WS-MEDIA-TYPE-MATCH    PIC X VALUE 'N'.
       01 WS-YEAR-MATCH          PIC X VALUE 'N'.
       01 WS-RATING-MATCH        PIC X VALUE 'N'.
       01 WS-DISPLAY-LINE        PIC X(200).
       01 WS-PTR                 PIC 9(4) VALUE 1.
       
       LINKAGE SECTION.
       01 LS-RETURN-CODE         PIC 9(4).
       01 LS-SEARCH-TEXT         PIC X(100).
       01 LS-SEARCH-GENRE        PIC X(50).
       01 LS-SEARCH-MEDIA-TYPE   PIC X(20).
       01 LS-SEARCH-YEAR-MIN     PIC 9(4).
       01 LS-SEARCH-YEAR-MAX     PIC 9(4).
       01 LS-SEARCH-RATING-MIN   PIC 9(2).
       01 LS-ITEM-ID             PIC 9(6).
       01 LS-ITEM-TITLE          PIC X(100).
       01 LS-ITEM-GENRE          PIC X(50).
       01 LS-ITEM-MEDIA-TYPE     PIC X(20).
       01 LS-ITEM-YEAR           PIC 9(4).
       01 LS-ITEM-RATING         PIC 9(2).
       01 LS-ITEM-DESCRIPTION    PIC X(500).
       
       PROCEDURE DIVISION.
       MAIN SECTION.
           CALL "init_mediamatrix" USING LS-RETURN-CODE.
           GOBACK.

       INIT-MEDIAMATRIX SECTION.
           ENTRY "init_mediamatrix" USING LS-RETURN-CODE.
           OPEN I-O ITEMS-FILE.
           IF WS-FILE-STATUS = "35"
               CLOSE ITEMS-FILE
               OPEN OUTPUT ITEMS-FILE
               CLOSE ITEMS-FILE
               OPEN I-O ITEMS-FILE
           END-IF.
           CLOSE ITEMS-FILE.
           MOVE 0 TO LS-RETURN-CODE.
           GOBACK.

       LIST-ITEMS SECTION.
           ENTRY "list_items" USING LS-RETURN-CODE
                                  LS-SEARCH-TEXT
                                  LS-SEARCH-GENRE
                                  LS-SEARCH-MEDIA-TYPE
                                  LS-SEARCH-YEAR-MIN
                                  LS-SEARCH-YEAR-MAX
                                  LS-SEARCH-RATING-MIN.
           PERFORM LIST-ITEMS-PROC.
           GOBACK.

       LIST-ITEMS-PROC SECTION.
           INITIALIZE WS-FILE-STATUS.
           MOVE LS-SEARCH-TEXT TO WS-SEARCH-TEXT.
           MOVE LS-SEARCH-GENRE TO WS-SEARCH-GENRE.
           MOVE LS-SEARCH-MEDIA-TYPE TO WS-SEARCH-MEDIA-TYPE.
           MOVE LS-SEARCH-YEAR-MIN TO WS-SEARCH-YEAR-MIN.
           MOVE LS-SEARCH-YEAR-MAX TO WS-SEARCH-YEAR-MAX.
           MOVE LS-SEARCH-RATING-MIN TO WS-SEARCH-RATING-MIN.
           
           OPEN INPUT ITEMS-FILE.
           IF WS-FILE-STATUS = "00"
               MOVE LOW-VALUES TO ITEM-RECORD
               START ITEMS-FILE KEY IS GREATER THAN ITEM-ID
                   INVALID KEY
                       MOVE "23" TO WS-FILE-STATUS
                   NOT INVALID KEY
                       PERFORM READ-ITEMS-LOOP 
                           UNTIL WS-FILE-STATUS NOT EQUAL "00"
               END-START
               CLOSE ITEMS-FILE
           END-IF.
           MOVE 0 TO LS-RETURN-CODE.
           EXIT SECTION.

       READ-ITEMS-LOOP SECTION.
           READ ITEMS-FILE NEXT RECORD
               AT END
                   MOVE "10" TO WS-FILE-STATUS
               NOT AT END
                   PERFORM CHECK-ITEM-MATCH
                   IF WS-MATCHES = 'Y'
                       DISPLAY ITEM-ID " | " ITEM-TITLE " | " 
                           ITEM-GENRE " | " ITEM-MEDIA-TYPE " | " 
                           ITEM-YEAR " | " ITEM-RATING
                   END-IF
           END-READ.
           EXIT SECTION.

       CHECK-ITEM-MATCH SECTION.
           MOVE 'Y' TO WS-MATCHES.
           IF WS-SEARCH-TEXT NOT EQUAL SPACES
               MOVE 0 TO WS-TITLE-MATCH
               INSPECT ITEM-TITLE TALLYING WS-TITLE-MATCH
                   FOR ALL WS-SEARCH-TEXT
               IF WS-TITLE-MATCH = 0
                   MOVE 'N' TO WS-MATCHES
               END-IF
           END-IF.
           IF WS-MATCHES = 'Y' AND WS-SEARCH-GENRE NOT EQUAL SPACES
               IF WS-SEARCH-GENRE NOT EQUAL ITEM-GENRE
                   MOVE 'N' TO WS-MATCHES
               END-IF
           END-IF.
           IF WS-MATCHES = 'Y' AND WS-SEARCH-MEDIA-TYPE NOT EQUAL SPACES
               IF WS-SEARCH-MEDIA-TYPE NOT EQUAL ITEM-MEDIA-TYPE
                   MOVE 'N' TO WS-MATCHES
               END-IF
           END-IF.
           IF WS-MATCHES = 'Y' AND WS-SEARCH-YEAR-MIN > 0
               IF ITEM-YEAR < WS-SEARCH-YEAR-MIN
                   MOVE 'N' TO WS-MATCHES
               END-IF
           END-IF.
           IF WS-MATCHES = 'Y' AND WS-SEARCH-YEAR-MAX > 0
               IF ITEM-YEAR > WS-SEARCH-YEAR-MAX
                   MOVE 'N' TO WS-MATCHES
               END-IF
           END-IF.
           IF WS-MATCHES = 'Y' AND WS-SEARCH-RATING-MIN > 0
               IF ITEM-RATING < WS-SEARCH-RATING-MIN
                   MOVE 'N' TO WS-MATCHES
               END-IF
           END-IF.
           EXIT SECTION.

       GET-NEXT-ID SECTION.
           MOVE 0 TO WS-NEXT-ID.
           OPEN INPUT ITEMS-FILE.
           IF WS-FILE-STATUS = "00"
               MOVE LOW-VALUES TO ITEM-RECORD
               START ITEMS-FILE KEY IS GREATER THAN ITEM-ID
                   INVALID KEY
                       MOVE "23" TO WS-FILE-STATUS
                   NOT INVALID KEY
                       PERFORM READ-NEXT-ID 
                           UNTIL WS-FILE-STATUS NOT EQUAL "00"
               END-START
               CLOSE ITEMS-FILE
           END-IF.
           ADD 1 TO WS-NEXT-ID.
           EXIT SECTION.

       READ-NEXT-ID SECTION.
           READ ITEMS-FILE NEXT RECORD
               AT END
                   MOVE "10" TO WS-FILE-STATUS
               NOT AT END
                   IF ITEM-ID > WS-NEXT-ID
                       MOVE ITEM-ID TO WS-NEXT-ID
                   END-IF
           END-READ.
           EXIT SECTION.

       ADD-ITEM SECTION.
           ENTRY "add_item" USING LS-RETURN-CODE
                                LS-ITEM-TITLE
                                LS-ITEM-GENRE
                                LS-ITEM-MEDIA-TYPE
                                LS-ITEM-YEAR
                                LS-ITEM-RATING
                                LS-ITEM-DESCRIPTION.
           PERFORM GET-NEXT-ID.
           MOVE WS-NEXT-ID TO ITEM-ID.
           OPEN I-O ITEMS-FILE.
           IF WS-FILE-STATUS = "00"
               MOVE LS-ITEM-TITLE TO ITEM-TITLE
               MOVE LS-ITEM-GENRE TO ITEM-GENRE
               MOVE LS-ITEM-MEDIA-TYPE TO ITEM-MEDIA-TYPE
               MOVE LS-ITEM-YEAR TO ITEM-YEAR
               MOVE LS-ITEM-RATING TO ITEM-RATING
               MOVE LS-ITEM-DESCRIPTION TO ITEM-DESCRIPTION
               WRITE ITEM-RECORD
               IF WS-FILE-STATUS = "00"
                   MOVE 0 TO LS-RETURN-CODE
               ELSE
                   MOVE 1 TO LS-RETURN-CODE
               END-IF
               CLOSE ITEMS-FILE
           ELSE
               MOVE 1 TO LS-RETURN-CODE
           END-IF.
           GOBACK.

       EDIT-ITEM SECTION.
           ENTRY "edit_item" USING LS-RETURN-CODE
                                 LS-ITEM-ID
                                 LS-ITEM-TITLE
                                 LS-ITEM-GENRE
                                 LS-ITEM-MEDIA-TYPE
                                 LS-ITEM-YEAR
                                 LS-ITEM-RATING
                                 LS-ITEM-DESCRIPTION.
           OPEN I-O ITEMS-FILE.
           IF WS-FILE-STATUS = "00"
               MOVE LS-ITEM-ID TO ITEM-ID
               READ ITEMS-FILE RECORD
               IF WS-FILE-STATUS = "00"
                   MOVE LS-ITEM-TITLE TO ITEM-TITLE
                   MOVE LS-ITEM-GENRE TO ITEM-GENRE
                   MOVE LS-ITEM-MEDIA-TYPE TO ITEM-MEDIA-TYPE
                   MOVE LS-ITEM-YEAR TO ITEM-YEAR
                   MOVE LS-ITEM-RATING TO ITEM-RATING
                   MOVE LS-ITEM-DESCRIPTION TO ITEM-DESCRIPTION
                   REWRITE ITEM-RECORD
                   IF WS-FILE-STATUS = "00"
                       MOVE 0 TO LS-RETURN-CODE
                   ELSE
                       MOVE 1 TO LS-RETURN-CODE
                   END-IF
               ELSE
                   MOVE 1 TO LS-RETURN-CODE
               END-IF
               CLOSE ITEMS-FILE
           ELSE
               MOVE 1 TO LS-RETURN-CODE
           END-IF.
           GOBACK.

       DELETE-ITEM SECTION.
           ENTRY "delete_item" USING LS-RETURN-CODE
                                   LS-ITEM-ID.
           OPEN I-O ITEMS-FILE.
           IF WS-FILE-STATUS = "00"
               MOVE LS-ITEM-ID TO ITEM-ID
               DELETE ITEMS-FILE RECORD
               IF WS-FILE-STATUS = "00"
                   MOVE 0 TO LS-RETURN-CODE
               ELSE
                   MOVE 1 TO LS-RETURN-CODE
               END-IF
               CLOSE ITEMS-FILE
           ELSE
               MOVE 1 TO LS-RETURN-CODE
           END-IF.
           GOBACK.

       END PROGRAM MEDIAMATRIX.