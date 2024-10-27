from collections import Counter
import json
import os
import base64
import pyperclip

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, pyqtProperty

class GenerateUrl(QObject):
    isCharget = pyqtSignal()

    def __init__(self):
        super().__init__()
        self.filepath = ""
        self.isChargetValue = False

    @pyqtProperty(bool, notify=isCharget)
    def getIsCharget(self):
        return self.isChargetValue
    
    def setIsCharget(self, value):
        if self.isChargetValue != value:
            self.isChargetValue = value
            self.isCharget.emit()
    
    def checkUrlExist(self) -> bool:
        if not os.path.isfile(self.filepath):
            print(f"El archivo {self.filepath} no existe.")
            return False
        try:
            with open(self.filepath, 'r') as file:
                self.data = json.load(file)
                self.exteriorFurniture = self.data.get("exteriorFurniture", None)
                self.interiorFurniture = self.data.get("interiorFurniture", None)
                if self.exteriorFurniture is None or self.interiorFurniture is None:
                    print("Error: Faltan campos requeridos en el JSON.")
                    return False
                self.setIsCharget(True)
                return True
        except json.JSONDecodeError:
            print(f"Error: El archivo {self.filepath} no es un JSON válido.")
            return False
        except Exception as e:
            print(f"Error al abrir el archivo {self.filepath}: {e}")
            return False
    
    @pyqtSlot(str)
    def setFilepath(self, filepath:str)-> bool:
        self.filepath = filepath
        self.exteriorFurniture = None
        self.interiorFurniture = None
        self.data = None
        self.setIsCharget(False)
        return self.checkUrlExist()
    
    def getFilepath(self) -> str:
        return self.filepath
    
    def generateUrl(self, item_list)->str:
        url = "https://ffxivteamcraft.com/import/"
        str_items = ""
        for i, (item_id, count) in enumerate(item_list):
            if i < len(item_list) - 1:
                str_items += f"{item_id},null,{count};"
            else:
                str_items += f"{item_id},null,{count}"
        
        # Convertir str_items a bytes y codificar en Base64
        str_items_bytes = str_items.encode("utf-8")
        str_items_base64 = base64.b64encode(str_items_bytes)

        # Convertir de bytes a string para obtener el resultado final
        str_items_base64_str = str_items_base64.decode("utf-8")
        url += str_items_base64_str
        pyperclip.copy(url)
        return url
    
    @pyqtSlot()
    def generateUrlGarden(self)->str:
        if(self.exteriorFurniture is None):
            return ""
        item_ids = [item.get("itemId") for item in self.exteriorFurniture]
        item_counts = Counter(item_ids)
        item_list = list(item_counts.items())
        return self.generateUrl(item_list)
    
    @pyqtSlot()
    def generateUrlInterior(self)->str:
        if(self.interiorFurniture is None):
            return ""
        item_ids = [item.get("itemId") for item in self.interiorFurniture]
        item_counts = Counter(item_ids)
        item_list = list(item_counts.items())
        return self.generateUrl(item_list)
    
    @pyqtSlot()
    def generateAll(self)->str:
        if(self.interiorFurniture is None or self.interiorFurniture is None):
            return ""
        item_ids = [item.get("itemId") for item in self.exteriorFurniture]
        item_ids += [item.get("itemId") for item in self.interiorFurniture]
        item_counts = Counter(item_ids)
        item_list = list(item_counts.items())
        return self.generateUrl(item_list)
    

        
        
    