#ifndef MM_ITEM_DIALOG_H
#define MM_ITEM_DIALOG_H

#include <QDialog>
#include "core/mm_wrapper.h"

QT_BEGIN_NAMESPACE
class QLineEdit;
class QComboBox;
class QSpinBox;
class QTextEdit;
class QDialogButtonBox;
QT_END_NAMESPACE

class MediaMatrixItemDialog : public QDialog {
    Q_OBJECT

public:
    enum Mode {
        Add,
        Edit
    };

    explicit MediaMatrixItemDialog(Mode mode, QWidget *parent = nullptr);
    ~MediaMatrixItemDialog();

    void loadItem(int id);

private slots:
    void accept() override;
    void reject() override;

private:
    void setupUi();
    void saveItem();

    Mode mode;
    int itemId;

    QLineEdit *titleEdit;
    QComboBox *genreCombo;
    QSpinBox *yearSpin;
    QSpinBox *ratingSpin;
    QComboBox *mediaTypeCombo;
    QTextEdit *descriptionEdit;
    QDialogButtonBox *buttonBox;
};

#endif // MM_ITEM_DIALOG_H 