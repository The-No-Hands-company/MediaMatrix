#include <QApplication>
#include <QMainWindow>
#include <QWidget>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QPushButton>
#include <QListWidget>
#include <QStackedWidget>
#include <QLabel>
#include <QMessageBox>
#include <QDate>
#include "collector_wrapper.h"
#include "item_dialog.h"

class CollectorGUI : public QMainWindow {
    Q_OBJECT

public:
    CollectorGUI(QWidget *parent = nullptr) : QMainWindow(parent), currentMediaType("Movies") {
        setWindowTitle("Media Collector");
        resize(800, 600);

        // Create central widget and main layout
        QWidget *centralWidget = new QWidget(this);
        setCentralWidget(centralWidget);
        QHBoxLayout *mainLayout = new QHBoxLayout(centralWidget);

        // Create sidebar with media type buttons
        QWidget *sidebar = new QWidget;
        QVBoxLayout *sidebarLayout = new QVBoxLayout(sidebar);
        sidebarLayout->setSpacing(5);

        // Create media type buttons
        QPushButton *moviesBtn = new QPushButton("Movies", this);
        QPushButton *tvseriesBtn = new QPushButton("TV Series", this);
        QPushButton *animeBtn = new QPushButton("Anime", this);
        QPushButton *gamesBtn = new QPushButton("Games", this);
        QPushButton *mangaBtn = new QPushButton("Manga", this);
        QPushButton *comicsBtn = new QPushButton("Comics", this);
        QPushButton *booksBtn = new QPushButton("Books", this);
        QPushButton *magazinesBtn = new QPushButton("Magazines", this);

        // Add buttons to sidebar layout
        sidebarLayout->addWidget(moviesBtn);
        sidebarLayout->addWidget(tvseriesBtn);
        sidebarLayout->addWidget(animeBtn);
        sidebarLayout->addWidget(gamesBtn);
        sidebarLayout->addWidget(mangaBtn);
        sidebarLayout->addWidget(comicsBtn);
        sidebarLayout->addWidget(booksBtn);
        sidebarLayout->addWidget(magazinesBtn);
        sidebarLayout->addStretch();

        // Create content area
        QWidget *content = new QWidget;
        QVBoxLayout *contentLayout = new QVBoxLayout(content);

        // Create list widget for displaying items
        listWidget = new QListWidget(this);
        contentLayout->addWidget(listWidget);

        // Create action buttons
        QHBoxLayout *actionLayout = new QHBoxLayout;
        QPushButton *addBtn = new QPushButton("Add New", this);
        QPushButton *editBtn = new QPushButton("Edit", this);
        QPushButton *deleteBtn = new QPushButton("Delete", this);
        actionLayout->addWidget(addBtn);
        actionLayout->addWidget(editBtn);
        actionLayout->addWidget(deleteBtn);
        contentLayout->addLayout(actionLayout);

        // Add sidebar and content to main layout
        mainLayout->addWidget(sidebar, 1);
        mainLayout->addWidget(content, 4);

        // Connect signals and slots
        connect(moviesBtn, &QPushButton::clicked, [this]() { showMediaType("Movies"); });
        connect(tvseriesBtn, &QPushButton::clicked, [this]() { showMediaType("TV Series"); });
        connect(animeBtn, &QPushButton::clicked, [this]() { showMediaType("Anime"); });
        connect(gamesBtn, &QPushButton::clicked, [this]() { showMediaType("Games"); });
        connect(mangaBtn, &QPushButton::clicked, [this]() { showMediaType("Manga"); });
        connect(comicsBtn, &QPushButton::clicked, [this]() { showMediaType("Comics"); });
        connect(booksBtn, &QPushButton::clicked, [this]() { showMediaType("Books"); });
        connect(magazinesBtn, &QPushButton::clicked, [this]() { showMediaType("Magazines"); });

        connect(addBtn, &QPushButton::clicked, this, &CollectorGUI::addItem);
        connect(editBtn, &QPushButton::clicked, this, &CollectorGUI::editItem);
        connect(deleteBtn, &QPushButton::clicked, this, &CollectorGUI::deleteItem);

        // Initialize the collector
        if (!init_collector()) {
            QMessageBox::critical(this, "Error", "Failed to initialize collector");
            close();
        }

        // Show initial media type
        showMediaType("Movies");
    }

    ~CollectorGUI() {
        cleanup_collector();
    }

private:
    QListWidget *listWidget;
    QString currentMediaType;

    void showMediaType(const QString &mediaType) {
        currentMediaType = mediaType;
        listWidget->clear();
        int return_code = 0;

        if (mediaType == "Movies") {
            list_movies(&return_code);
        } else if (mediaType == "TV Series") {
            list_tvseries(&return_code);
        } else if (mediaType == "Anime") {
            list_anime(&return_code);
        } else if (mediaType == "Games") {
            list_games(&return_code);
        } else if (mediaType == "Manga") {
            list_manga(&return_code);
        } else if (mediaType == "Comics") {
            list_comics(&return_code);
        } else if (mediaType == "Books") {
            list_books(&return_code);
        } else if (mediaType == "Magazines") {
            list_magazines(&return_code);
        }

        // TODO: Parse the output from COBOL and populate the list widget
        // For now, we'll just show a placeholder
        listWidget->addItem("Sample Item 1 (Year: 2024, Rating: 8)");
        listWidget->addItem("Sample Item 2 (Year: 2023, Rating: 7)");
    }

private slots:
    void addItem() {
        ItemDialog dialog(currentMediaType, this);
        if (dialog.exec() == QDialog::Accepted) {
            QString title = dialog.getTitle();
            int year = dialog.getYear();
            QString genre = dialog.getGenre();
            int rating = dialog.getRating();
            QString notes = dialog.getNotes();

            // TODO: Call appropriate COBOL function to add the item
            // For now, just add to the list widget
            QString itemText = QString("%1 (Year: %2, Rating: %3)")
                .arg(title)
                .arg(year)
                .arg(rating);
            listWidget->addItem(itemText);
        }
    }

    void editItem() {
        QListWidgetItem *currentItem = listWidget->currentItem();
        if (!currentItem) {
            QMessageBox::warning(this, "No Selection", "Please select an item to edit.");
            return;
        }

        ItemDialog dialog(currentMediaType, this);
        // TODO: Parse the current item's data and set it in the dialog
        // For now, we'll just set some sample data
        dialog.setTitle("Sample Title");
        dialog.setYear(2024);
        dialog.setGenre("Action");
        dialog.setRating(8);
        dialog.setNotes("Sample notes");

        if (dialog.exec() == QDialog::Accepted) {
            QString title = dialog.getTitle();
            int year = dialog.getYear();
            QString genre = dialog.getGenre();
            int rating = dialog.getRating();
            QString notes = dialog.getNotes();

            // TODO: Call appropriate COBOL function to update the item
            // For now, just update the list widget
            QString itemText = QString("%1 (Year: %2, Rating: %3)")
                .arg(title)
                .arg(year)
                .arg(rating);
            currentItem->setText(itemText);
        }
    }

    void deleteItem() {
        QListWidgetItem *currentItem = listWidget->currentItem();
        if (!currentItem) {
            QMessageBox::warning(this, "No Selection", "Please select an item to delete.");
            return;
        }

        QMessageBox::StandardButton reply = QMessageBox::question(
            this, "Confirm Delete",
            "Are you sure you want to delete this item?",
            QMessageBox::Yes | QMessageBox::No
        );

        if (reply == QMessageBox::Yes) {
            // TODO: Call appropriate COBOL function to delete the item
            delete listWidget->takeItem(listWidget->row(currentItem));
        }
    }
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    CollectorGUI window;
    window.show();
    return app.exec();
}

#include "collector_gui.moc" 