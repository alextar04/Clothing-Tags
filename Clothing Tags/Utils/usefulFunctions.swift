//
//  usefulFunctions.swift
//  
//
//  Created by Alexey Taran on 18.08.2020.
//

import Foundation

/* Конвертирование информации об id-стикеров
   Строка -> Массив */
func getStickersIdFromString(_ idsString: String)->[Int]{
    let listIdsString = idsString.split(separator: ",")
    var listIdsInt = [Int]()
    
    listIdsString.map{
        listIdsInt.append(Int(String($0))!)
    }
    return listIdsInt
}
