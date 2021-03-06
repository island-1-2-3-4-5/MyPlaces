//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Roman on 03.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

// в файле appDelegate добавили пару строк кода для изменений модели данных


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
    @objc dynamic  var date = Date() // надо для сортировки по дате
    @objc dynamic  var rating = 0.0 // по умолчанию рейтинг 0
    
    // вспомогательный инициализатор (не является обязательным), с помощью него вносим новые значения в базу
    convenience init(name: String, location: String?, type: String?, imageData: Data?, rating: Double){
        self.init() //  сначала инициализируется обычный инициализатор а после присваиваем новые значения
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
        self.rating = rating
    }
}
