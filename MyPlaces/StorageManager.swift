//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Roman on 08.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import RealmSwift

let realm = try! Realm()


// тут мы либо сохранияем либо удаляем из базы объекты
class StorageManager {
    
    // необходимо лишь вызвать этот метод
    static func saveObject(_ place: Place){
        
        try! realm.write{
            realm.add(place)
        }
    }
    
    static func deleteObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
