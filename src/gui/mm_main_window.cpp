#include "mediamatrix/gui/mm_main_window.h"
#include "mediamatrix/gui/mm_item_dialog.h"
#include "mediamatrix/core/mediamatrix.h"

#include <QtWidgets/QApplication>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QGroupBox>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QListWidget>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QLabel>
#include <QtCore/QDate>
#include <QtWidgets/QMessageBox>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QTableWidget>
#include <QtWidgets/QTableWidgetItem>
#include <QtWidgets/QFormLayout>
#include <QtWidgets/QAbstractItemView>

MediaMatrixMainWindow::MediaMatrixMainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    setupUi();
    setupConnections();
    loadItems();
}

MediaMatrixMainWindow::~MediaMatrixMainWindow()
{
}

void MediaMatrixMainWindow::setupUi()
{
    setWindowTitle(tr("MediaMatrix"));
    setMinimumSize(800, 600);

    QWidget *centralWidget = new QWidget(this);
    setCentralWidget(centralWidget);

    QVBoxLayout *mainLayout = new QVBoxLayout(centralWidget);

    // Filter section
    QWidget *filterWidget = new QWidget(this);
    QFormLayout *filterLayout = new QFormLayout(filterWidget);

    searchEdit = new QLineEdit(this);
    filterLayout->addRow(tr("Search:"), searchEdit);

    genreCombo = new QComboBox(this);
    genreCombo->setEditable(true);
    genreCombo->addItems({
        "All", "Action", "Adventure", "Comedy", "Drama", "Fantasy",
        "Horror", "Mystery", "Romance", "Sci-Fi", "Thriller"
    });
    filterLayout->addRow(tr("Genre:"), genreCombo);

    mediaTypeCombo = new QComboBox(this);
    mediaTypeCombo->setEditable(true);
    mediaTypeCombo->addItems({
        "All", "Movie", "TV Show"
    });
    filterLayout->addRow(tr("Type:"), mediaTypeCombo);

    yearMinSpin = new QSpinBox(this);
    yearMinSpin->setRange(1900, QDate::currentDate().year());
    yearMinSpin->setValue(1900);
    filterLayout->addRow(tr("Year from:"), yearMinSpin);

    yearMaxSpin = new QSpinBox(this);
    yearMaxSpin->setRange(1900, QDate::currentDate().year());
    yearMaxSpin->setValue(QDate::currentDate().year());
    filterLayout->addRow(tr("Year to:"), yearMaxSpin);

    ratingMinSpin = new QSpinBox(this);
    ratingMinSpin->setRange(0, 10);
    ratingMinSpin->setValue(0);
    filterLayout->addRow(tr("Min Rating:"), ratingMinSpin);

    mainLayout->addWidget(filterWidget);

    // Table
    itemsTable = new QTableWidget(this);
    itemsTable->setColumnCount(6);
    itemsTable->setHorizontalHeaderLabels({
        tr("ID"), tr("Title"), tr("Genre"), tr("Year"), tr("Rating"), tr("Notes")
    });
    itemsTable->horizontalHeader()->setSectionResizeMode(1, QHeaderView::Stretch);
    itemsTable->horizontalHeader()->setSectionResizeMode(5, QHeaderView::Stretch);
    itemsTable->setSelectionBehavior(QAbstractItemView::SelectRows);
    itemsTable->setSelectionMode(QAbstractItemView::SingleSelection);
    mainLayout->addWidget(itemsTable);

    // Buttons
    QHBoxLayout *buttonLayout = new QHBoxLayout;

    addButton = new QPushButton(tr("Add"), this);
    editButton = new QPushButton(tr("Edit"), this);
    deleteButton = new QPushButton(tr("Delete"), this);
    refreshButton = new QPushButton(tr("Refresh"), this);

    buttonLayout->addWidget(addButton);
    buttonLayout->addWidget(editButton);
    buttonLayout->addWidget(deleteButton);
    buttonLayout->addStretch();
    buttonLayout->addWidget(refreshButton);

    mainLayout->addLayout(buttonLayout);
}

void MediaMatrixMainWindow::setupConnections()
{
    connect(addButton, &QPushButton::clicked, this, &MediaMatrixMainWindow::addItem);
    connect(editButton, &QPushButton::clicked, this, &MediaMatrixMainWindow::editItem);
    connect(deleteButton, &QPushButton::clicked, this, &MediaMatrixMainWindow::deleteItem);
    connect(refreshButton, &QPushButton::clicked, this, &MediaMatrixMainWindow::refreshList);

    connect(searchEdit, &QLineEdit::textChanged, this, &MediaMatrixMainWindow::applyFilter);
    connect(genreCombo, &QComboBox::currentTextChanged, this, &MediaMatrixMainWindow::applyFilter);
    connect(mediaTypeCombo, &QComboBox::currentTextChanged, this, &MediaMatrixMainWindow::applyFilter);
    connect(yearMinSpin, QOverload<int>::of(&QSpinBox::valueChanged), this, &MediaMatrixMainWindow::applyFilter);
    connect(yearMaxSpin, QOverload<int>::of(&QSpinBox::valueChanged), this, &MediaMatrixMainWindow::applyFilter);
    connect(ratingMinSpin, QOverload<int>::of(&QSpinBox::valueChanged), this, &MediaMatrixMainWindow::applyFilter);
}

void MediaMatrixMainWindow::loadItems()
{
    itemsTable->setRowCount(0);
    applyFilter();
}

void MediaMatrixMainWindow::addItem()
{
    MediaMatrixItemDialog dialog(MediaMatrixItemDialog::Add, this);
    if (dialog.exec() == QDialog::Accepted) {
        refreshList();
    }
}

void MediaMatrixMainWindow::editItem()
{
    QModelIndexList selection = itemsTable->selectionModel()->selectedRows();
    if (selection.isEmpty()) {
        QMessageBox::warning(this, tr("No Selection"),
                           tr("Please select an item to edit."));
        return;
    }

    int row = selection.first().row();
    int itemId = itemsTable->item(row, 0)->text().toInt();

    MediaMatrixItemDialog dialog(MediaMatrixItemDialog::Edit, this);
    dialog.loadItem(itemId);
    if (dialog.exec() == QDialog::Accepted) {
        refreshList();
    }
}

void MediaMatrixMainWindow::deleteItem()
{
    QModelIndexList selection = itemsTable->selectionModel()->selectedRows();
    if (selection.isEmpty()) {
        QMessageBox::warning(this, tr("No Selection"),
                           tr("Please select an item to delete."));
        return;
    }

    int row = selection.first().row();
    int itemId = itemsTable->item(row, 0)->text().toInt();

    if (QMessageBox::question(this, tr("Confirm Delete"),
                            tr("Are you sure you want to delete this item?"),
                            QMessageBox::Yes | QMessageBox::No) == QMessageBox::Yes) {
        delete_item_wrapper(itemId);
        refreshList();
    }
}

void MediaMatrixMainWindow::refreshList()
{
    loadItems();
}

void MediaMatrixMainWindow::applyFilter()
{
    const char* result = list_items_wrapper(
        searchEdit->text().toUtf8().constData(),
        genreCombo->currentText() == "All" ? "" : genreCombo->currentText().toUtf8().constData(),
        mediaTypeCombo->currentText() == "All" ? "" : mediaTypeCombo->currentText().toUtf8().constData(),
        yearMinSpin->value(),
        yearMaxSpin->value(),
        ratingMinSpin->value()
    );

    // Parse the result and populate the table
    QString items = QString::fromUtf8(result);
    QStringList lines = items.split('\n', Qt::SkipEmptyParts);

    itemsTable->setRowCount(lines.size());
    for (int i = 0; i < lines.size(); ++i) {
        QStringList fields = lines[i].split('|');
        if (fields.size() >= 6) {
            for (int j = 0; j < 6; ++j) {
                QTableWidgetItem *item = new QTableWidgetItem(fields[j].trimmed());
                itemsTable->setItem(i, j, item);
            }
        }
    }
}

#include "mm_main_window.moc" 