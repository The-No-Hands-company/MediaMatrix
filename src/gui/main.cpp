#include <QApplication>
#include "mediamatrix/gui/mm_main_window.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    MediaMatrixMainWindow mainWindow;
    mainWindow.show();
    return app.exec();
} 