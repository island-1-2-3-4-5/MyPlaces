//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Roman on 03.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import RealmSwift
// делаем модель хранения данных как класс, с типом данных Object
class Place: Object {
    
    // данные которые мы храним
    @objc dynamic var name: String = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    // изображения хранятся в типе Data
    @objc dynamic  var imageData: Data?
    // изображение будем брать из ImageView
    
    
    // вспомогательный инициализатор, с помощью него вносим новые значения в базу
    convenience init(name: String, location: String?, type: String?, imageData: Data?){
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
}
