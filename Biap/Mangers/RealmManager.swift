//
//  RealmManager.swift
//  Biap
//
//  Created by Abdelrahman on 08/03/2023.
//

import Foundation
import RealmSwift


import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    private let realm: Realm
    
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    func add(object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Failed to add object to Realm: \(error.localizedDescription)")
        }
    }
    
    func delete(object: Object) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("Failed to delete object from Realm: \(error.localizedDescription)")
        }
    }
    
    func getAllObjects<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    func getObject<T: Object>(_ type: T.Type, primaryKey: Any) -> T? {
        return realm.object(ofType: type, forPrimaryKey: primaryKey)
    }
    
    func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}


extension RealmManager{
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




