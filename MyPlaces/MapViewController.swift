//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Roman on 16.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var place: Place!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlacemark() // вызываем метод установки метки
    }
    
    
    //MARK: - Навигация назад
    @IBAction func closeVC(_ : Any) {
        dismiss(animated: true)
    }
    
    
    //MARK: - установка маркера
    private func setupPlacemark() {
        guard let location = place.location else {return} // если адреса нет, то делаем выход
        
        // отвечает за преобразование географических координат и географических названий
        let geocoder = CLGeocoder()
        // опредеделяет координаты места, из переданной строки с названием
        geocoder.geocodeAddressString(location) { (placemarks, error) in // placemarks - массив меток переданного адреса, бывает что одному и тому же адресу соответствуют несколько меток
            // если есть ошибка, то выводим ее на консоль и выходим из метода
            if let error = error {
                print(error)
                return
            }
            // если нет ошибки, извлекаем опционал
            guard let placemarks = placemarks else {return}
            
            // массив может содержать много меток, нам нужна самая первая
            let placemark = placemarks.first
            
            // выше мы получили метку, теперь описываем её
            let annotation = MKPointAnnotation() // используется для описания какой-либо точки на карте
            // название места
            annotation.title = self.place.name
            // в подзаголовке добавляем тип места
            annotation.subtitle = self.place.type
            // привязываем аннотацию к точке на карте
            guard let placemarkLocation = placemark?.location else {return}
            annotation.coordinate = placemarkLocation.coordinate
            
            // определяем местоположение аннотации
            self.mapView.showAnnotations([annotation], animated: true)
            // выделяем аннотацию (при нажатии она раскрывается)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
}
