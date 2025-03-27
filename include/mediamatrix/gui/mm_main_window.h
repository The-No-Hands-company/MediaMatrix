#ifndef MM_MAIN_WINDOW_H
#define MM_MAIN_WINDOW_H

#include <QMainWindow>
#include "core/mm_wrapper.h"

QT_BEGIN_NAMESPACE
class QLineEdit;
class QComboBox;
class QSpinBox;
class QTableWidget;
class QPushButton;
QT_END_NAMESPACE

class MediaMatrixMainWindow : public QMainWindow {
    Q_OBJECT

public:
    explicit MediaMatrixMainWindow(QWidget *parent = nullptr);
    ~MediaMatrixMainWindow();

private slots:
    void addItem();
    void editItem();
    void deleteItem();
    void refreshList();
    void applyFilter();

private:
    void setupUi();
    void setupConnections();
    void loadItems();

    QLineEdit *searchEdit;
    QComboBox *genreCombo;
    QComboBox *mediaTypeCombo;
    QSpinBox *yearMinSpin;
    QSpinBox *yearMaxSpin;
    QSpinBox *ratingMinSpin;
    QTableWidget *itemsTable;
    QPushButton *addButton;
    QPushButton *editButton;
    QPushButton *deleteButton;
    QPushButton *refreshButton;
};

#endif // MM_MAIN_WINDOW_H 