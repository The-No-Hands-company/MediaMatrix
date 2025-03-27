#include <QLineEdit>
#include <QComboBox>
#include <QSpinBox>
#include <QTextEdit>
#include <QDialogButtonBox>
#include <QFormLayout>
#include <QLabel>
#include <QDate>
#include <QPushButton>
#include "mediamatrix/gui/mm_item_dialog.h"

MediaMatrixItemDialog::MediaMatrixItemDialog(Mode mode, QWidget *parent)
    : QDialog(parent)
    , mode(mode)
    , itemId(-1)
{
    setupUi();
}

MediaMatrixItemDialog::~MediaMatrixItemDialog()
{
}

void MediaMatrixItemDialog::setupUi()
{
    setWindowTitle(mode == Add ? tr("Add Item") : tr("Edit Item"));
    setModal(true);

    QFormLayout *layout = new QFormLayout(this);

    titleEdit = new QLineEdit(this);
    layout->addRow(tr("Title:"), titleEdit);

    genreCombo = new QComboBox(this);
    genreCombo->setEditable(true);
    genreCombo->addItems({
        "Action", "Adventure", "Comedy", "Drama", "Fantasy",
        "Horror", "Mystery", "Romance", "Sci-Fi", "Thriller"
    });
    layout->addRow(tr("Genre:"), genreCombo);

    yearSpin = new QSpinBox(this);
    yearSpin->setRange(1900, QDate::currentDate().year());
    yearSpin->setValue(QDate::currentDate().year());
    layout->addRow(tr("Year:"), yearSpin);

    ratingSpin = new QSpinBox(this);
    ratingSpin->setRange(0, 10);
    ratingSpin->setValue(5);
    layout->addRow(tr("Rating (0-10):"), ratingSpin);

    mediaTypeCombo = new QComboBox(this);
    mediaTypeCombo->addItems({
        "Movie", "Series", "Game", "Book", "Comic", "Magazine"
    });
    layout->addRow(tr("Media Type:"), mediaTypeCombo);

    descriptionEdit = new QTextEdit(this);
    layout->addRow(tr("Description:"), descriptionEdit);

    buttonBox = new QDialogButtonBox(
        QDialogButtonBox::Ok | QDialogButtonBox::Cancel,
        Qt::Horizontal, this);
    layout->addRow(buttonBox);

    connect(buttonBox, &QDialogButtonBox::accepted, this, &MediaMatrixItemDialog::accept);
    connect(buttonBox, &QDialogButtonBox::rejected, this, &MediaMatrixItemDialog::reject);
    connect(titleEdit, &QLineEdit::textChanged, this, [this]() {
        buttonBox->button(QDialogButtonBox::Ok)->setEnabled(!titleEdit->text().trimmed().isEmpty());
    });

    // Initial validation
    buttonBox->button(QDialogButtonBox::Ok)->setEnabled(false);
}

void MediaMatrixItemDialog::accept()
{
    saveItem();
    QDialog::accept();
}

void MediaMatrixItemDialog::reject()
{
    QDialog::reject();
}

void MediaMatrixItemDialog::loadItem(int id)
{
    itemId = id;
    // TODO: Load item data from the database
}

void MediaMatrixItemDialog::saveItem()
{
    // TODO: Save item data to the database
}

#include "mm_item_dialog.moc" 