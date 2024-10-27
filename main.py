
import json
import base64
import sys
from collections import Counter
from src.view.GenerateUrl import GenerateUrl

from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal
from PyQt5.QtCore import QCoreApplication

if __name__ == "__main__":
    gUrl = GenerateUrl()

    app = QGuiApplication(sys.argv)
    QCoreApplication.setOrganizationName("MiOrganizacion")
    QCoreApplication.setOrganizationDomain("mi.organizacion.com")
    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("generatorUrl", gUrl)
    engine.load("res/main.qml")
    
    sys.exit(app.exec_())
    