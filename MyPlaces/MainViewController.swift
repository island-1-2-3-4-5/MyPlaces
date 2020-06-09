//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Roman on 03.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {

    // создаем переменную которая является хранилищем для объектов в Realm
    var places: Results<Place>! // Results - аналог массива
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // делаем отображение базы данных, делаем запрос к отображаемому типу данных Place
        places = realm.objects(Place.self)


    }

    // MARK: - Table view data source

    

// MARK: Возвращает количество строк
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // зависит от количества элементов в массиве
        return places.isEmpty ? 0 : places.count // если в модели пусто возвращаем 0
    }


    
    //MARK: Конфигурация ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // надо работать с другим классом, проэтому делаем приведение типа
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        // создаем переменную которая построчно обращается к объектам массива
        let place = places[indexPath.row]
        // присваиваем названия заведений, с помощью сопоставления индексов ячеек и индексов значений массива
        cell.nameLabel.text = place.name// обращаемся к экземпляру и у него берем имя
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!) // данное свойство все есть

        // закругляем картинки, отталкиваемся от высоты изображения
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        // обрезаем изображение
        cell.imageOfPlace.clipsToBounds = true

        return cell
    }
    
    
    
    
    // MARK: TableDelegate
   
      
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
          
          let place = places[indexPath.row]
        // удаляем из таблицы строку с объектом и сам объект из базы данных
          let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
              
              StorageManager.deleteObject(place)
              tableView.deleteRows(at: [indexPath], with: .automatic)
          }
          
          return [deleteAction]
      }
    
    
 
    // MARK: - Navigation

    // При нажатии на ячеку будет открываться информация о ней на другом контроллере
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // если срабатывает такой идентификатор (который мы присвоили), то передаем данные на него
        if segue.identifier == "showDetail" {
            // обращаемся к выбранной ячейке по индексу
            guard let indexPath = tableView.indexPathForSelectedRow  else {return}
            let place = places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceViewController // сразу извлекаем опционал
            newPlaceVC.currentPlace = place // и обращаемся к свойству currentPlace из NewPlaceViewController, чтобы передать информацию о ячейке туда
        }
    }
    
    
    // создаем этот метод для того, чтобы мы могли на него сослаться из последнего контроллера(кнопка cancel)
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        // передаем новое значение в таблицу
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return}
        
        
        newPlaceVC.savePlace()
        // перезагружаем таблицу после добавления объекта
        tableView.reloadData()
    }

    
}
