#include "item_dialog.h"

ItemDialog::ItemDialog(const QString &mediaType, QWidget *parent)
    : QDialog(parent)
{
    setWindowTitle(QString("Add %1").arg(mediaType));
    setModal(true);

    QFormLayout *layout = new QFormLayout(this);

    // Create input fields
    titleEdit = new QLineEdit(this);
    yearSpinBox = new QSpinBox(this);
    yearSpinBox->setRange(1800, 2100);
    yearSpinBox->setValue(QDate::currentDate().year());
    
    genreCombo = new QComboBox(this);
    genreCombo->setEditable(true);
    // Add common genres based on media type
    if (mediaType == "Movies" || mediaType == "TV Series" || mediaType == "Anime") {
        genreCombo->addItems({"Action", "Comedy", "Drama", "Horror", "Sci-Fi", "Thriller"});
    } else if (mediaType == "Games") {
        genreCombo->addItems({"Action", "Adventure", "RPG", "Strategy", "Sports", "Simulation"});
    } else if (mediaType == "Manga" || mediaType == "Comics") {
        genreCombo->addItems({"Action", "Adventure", "Comedy", "Drama", "Fantasy", "Slice of Life"});
    } else if (mediaType == "Books") {
        genreCombo->addItems({"Fiction", "Non-Fiction", "Mystery", "Science Fiction", "Fantasy", "Biography"});
    } else if (mediaType == "Magazines") {
        genreCombo->addItems({"News", "Fashion", "Technology", "Science", "Sports", "Entertainment"});
    }

    ratingSpinBox = new QSpinBox(this);
    ratingSpinBox->setRange(0, 10);
    ratingSpinBox->setValue(5);

    notesEdit = new QPlainTextEdit(this);

    // Add fields to layout
    layout->addRow("Title:", titleEdit);
    layout->addRow("Year:", yearSpinBox);
    layout->addRow("Genre:", genreCombo);
    layout->addRow("Rating (0-10):", ratingSpinBox);
    layout->addRow("Notes:", notesEdit);

    // Add OK and Cancel buttons
    QDialogButtonBox *buttonBox = new QDialogButtonBox(
        QDialogButtonBox::Ok | QDialogButtonBox::Cancel,
        Qt::Horizontal, this);
    layout->addRow(buttonBox);

    connect(buttonBox, &QDialogButtonBox::accepted, this, &QDialog::accept);
    connect(buttonBox, &QDialogButtonBox::rejected, this, &QDialog::reject);
    connect(titleEdit, &QLineEdit::textChanged, this, &ItemDialog::validateInput);

    // Initial validation
    validateInput();
}

QString ItemDialog::getTitle() const {
    return titleEdit->text();
}

int ItemDialog::getYear() const {
    return yearSpinBox->value();
}

QString ItemDialog::getGenre() const {
    return genreCombo->currentText();
}

int ItemDialog::getRating() const {
    return ratingSpinBox->value();
}

QString ItemDialog::getNotes() const {
    return notesEdit->toPlainText();
}

void ItemDialog::setTitle(const QString &title) {
    titleEdit->setText(title);
}

void ItemDialog::setYear(int year) {
    yearSpinBox->setValue(year);
}

void ItemDialog::setGenre(const QString &genre) {
    int index = genreCombo->findText(genre);
    if (index >= 0) {
        genreCombo->setCurrentIndex(index);
    } else {
        genreCombo->setCurrentText(genre);
    }
}

void ItemDialog::setRating(int rating) {
    ratingSpinBox->setValue(rating);
}

void ItemDialog::setNotes(const QString &notes) {
    notesEdit->setPlainText(notes);
}

void ItemDialog::validateInput() {
    bool isValid = !titleEdit->text().trimmed().isEmpty();
    if (auto buttonBox = findChild<QDialogButtonBox*>()) {
        buttonBox->button(QDialogButtonBox::Ok)->setEnabled(isValid);
    }
} 