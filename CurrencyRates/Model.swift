//
//  Model.swift
//  CurrencyRates
//
//  Created by Alexander on 13.02.2021.
//

import UIKit

/*
 <NumCode>036</NumCode><CharCode>AUD</CharCode><Nominal>1</Nominal><Name>¿‚ÒÚ‡ÎËÈÒÍËÈ ‰ÓÎÎ‡</Name><Value>57,1181</Value>
 */
class Currency {
    var numCode: String?
    var charCode: String?
    
    var nominal: String?
    var nominalDouble: Double?
    
    var name: String?
    
    var value: String?
    var valueDouble: Double?
}

class Model: NSObject {
    static let shared = Model()
    
    var currencies: [Currency] = []
    
    var pathForXML: String {
        return ""
    }
    
    var urlForXML: URL? {
        return nil
    }
    
    //Загрузка XML с cbr.ru и сохранение его в каталоге приложения
    func loadXMLFile(data: Data){
        
    }
    
    //Парсим XML и помещаем его в currencies, отправляем уведомление приложению о том, что данные обновились
    func parseXML() {
        
    }
    
}
