//
//  Model.swift
//  CurrencyRates
//
//  Created by Alexander on 13.02.2021.
//

import UIKit

class Currency {
    var numCode: String?
    var charCode: String?
    
    var nominal: String?
    var nominalDouble: Double?
    
    var name: String?
    
    var value: String?
    var valueDouble: Double?
}

class Model: NSObject, XMLParserDelegate {
    static let shared = Model()
    
    var currencies: [Currency] = []
    var currentDate: String = ""
    
    var pathForXML: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
        
        return Bundle.main.path(forResource: "data", ofType: "xml")!
    }
    
    var urlForXML: URL {
        return URL(fileURLWithPath: pathForXML)
    }
    
    //Загрузка XML с cbr.ru и сохранение его в каталоге приложения
    func loadXMLFile(date: Date?){
        var strUrl = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            strUrl = strUrl+dateFormatter.string(from: date!)
        }
        let url = URL(string: strUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            if error == nil {
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
                let urlForSave = URL(fileURLWithPath: path)
                do {
                    try data?.write(to: urlForSave)
                    print(path)
                    print("Файл загружен")
                    self.parseXML()
                } catch {
                    print("Error when save data: \(error.localizedDescription)")
                }
            } else {
                print("Error when loadXMLFile:"+error!.localizedDescription)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startLoadingXML"), object: self)
        
        task.resume()
    }
    
    //Парсим XML и помещаем его в currencies, отправляем уведомление приложению о том, что данные обновились
    func parseXML() {
        currencies = []
        let parser = XMLParser(contentsOf: urlForXML)
        parser?.delegate = self
        parser?.parse()
        
        print("Данные обновлены")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataRefreshed"), object: self)
    }
    
    var currentCurrency: Currency?
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "ValCurs" {
            if let currentDateString = attributeDict["Date"] {
                currentDate = currentDateString
            }
        }
        if elementName == "Valute" {
            currentCurrency = Currency()
        }
    }
    
    var currentCharacters: String = ""
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCharacters = string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "NumCode" {
            currentCurrency?.numCode = currentCharacters
        }
        if elementName == "CharCode" {
            currentCurrency?.charCode = currentCharacters
        }
        if elementName == "Nominal" {
            currentCurrency?.nominal = currentCharacters
            currentCurrency?.nominalDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        if elementName == "Name" {
            currentCurrency?.name = currentCharacters
        }
        if elementName == "Value" {
            currentCurrency?.value = currentCharacters
            currentCurrency?.valueDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        
        if elementName == "Valute" {
            currencies.append(currentCurrency!)
        }
    }
    
}
