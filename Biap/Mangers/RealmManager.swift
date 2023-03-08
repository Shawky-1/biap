//
//  RealmManager.swift
//  Biap
//
//  Created by Abdelrahman on 08/03/2023.
//

import Foundation
import RealmSwift


class RealmManager{
    static func saveDataToCart(obj:Cart){
        try! Realm().beginWrite()
        try! Realm().add(obj)
        try! Realm().commitWrite()
    }
    
    
    static func saveDataToFavorites(obj:Favorite){
        try! Realm().beginWrite()
        try! Realm().add(obj)
        try! Realm().commitWrite()
    }
    
    static func deleteDatafromFavorites(id:Int){
        let delProduct = try! Realm().objects(Favorite.self).filter("productId == %@",id)
         try! Realm().write({
             try! Realm().delete(delProduct)
         })
    }
}




