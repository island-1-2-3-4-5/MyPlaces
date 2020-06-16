//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Roman on 03.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedCortingButton: UIBarButtonItem!
    
    //MARK: - Свойства
    // создаем экземпляр поискового контроллера, подписываемся под протокол
    private let searchController = UISearchController(searchResultsController: nil) // говорим ему, чтобы он отображал результат поиска на том же view (nil)
    // создаем переменную которая является хранилищем для объектов в Realm
    private  var places: Results<Place>! // Results - аналог массива
    private  var filteredPlaces: Results<Place>! // сюда помещаем отфильтрованные записи
    private var ascendingSorting = true // логическое свойство для сортировки по возрастанию
    // переменная определяющая явялется ли строка поиска пустой или нет
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    // свойство активирующее поисковый запрос
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
 
  
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // делаем отображение базы данных, делаем запрос к отображаемому типу данных Place
        places = realm.objects(Place.self)

        
        // производим настройку поискового контроллера
        searchController.searchResultsUpdater = self // получателем информации об изменения текста в строке должен быть наш класс
        searchController.obscuresBackgroundDuringPresentation = false // позволяет взаимодействовать с контроллером как с основным, можем смотреть детали записей редактировать и исправлять
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController // добавляем строку поиска в navigationBar
        definesPresentationContext = true // позволяет отпустить строку поиска при переходе на другой экран
    
    }
    

    // MARK: - Table view data source


     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPlaces.count
        }
        
       // зависит от количества элементов в массиве
        return places.count // если в модели пусто возвращаем 0
    }


    //MARK: - Конфигурация ячейки
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // надо работать с другим классом, проэтому делаем приведение типа
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        // в зависимости от фильтра выбираем тот ии иной массив для заполнения
        let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
        
        // Тоже самое что и сверху
//        var place = Place()
//        if isFiltering {
//            place = filteredPlaces[indexPath.row]
//        } else {
//            place = places[indexPath.row]
//        }
        
       
        // присваиваем названия заведений, с помощью сопоставления индексов ячеек и индексов значений массива
        cell.nameLabel.text = place.name// обращаемся к экземпляру и у него берем имя
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!) // данное свойство все есть
        cell.cosmosView.rating = place.rating
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK: - Удаление записей
  
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let place = places[indexPath.row]
        // удаляем из таблицы строку с объектом и сам объект из базы данных
        let contextItem = UIContextualAction(style: .destructive,
                                             title: "Delete") {  (_, _, _) in // (contextualAction, view, boolValue)
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
    
 
    // MARK: - Navigation

    // При нажатии на ячеку будет открываться информация о ней на другом контроллере
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // если срабатывает такой идентификатор (который мы присвоили), то передаем данные на него
        if segue.identifier == "showDetail" {
            // обращаемся к выбранной ячейке по индексу
            guard let indexPath = tableView.indexPathForSelectedRow  else {return}
            
           // в зависимости от фильтра выбираем тот ии иной массив для заполнения
            let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
            
//            var place = Place()
//            if isFiltering{
//                place = filteredPlaces[indexPath.row]
//            } else {
//                place = places[indexPath.row]
//            }
            
            let newPlaceVC = segue.destination as! NewPlaceViewController // сразу извлекаем опционал
            newPlaceVC.currentPlace = place // и обращаемся к свойству currentPlace из NewPlaceViewController, чтобы передать информацию о ячейке туда
        }
    }
    
    
    // MARK: - Выход Segue
    // создаем этот метод для того, чтобы мы могли на него сослаться из последнего контроллера(кнопка cancel)
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        // передаем новое значение в таблицу
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return}
        
        
        newPlaceVC.savePlace()
        // перезагружаем таблицу после добавления объекта
        tableView.reloadData()
    }

    
    // MARK: - IBAction sorting
    // сортируем по имени или дате
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
       sorting()
    }
    

    @IBAction func reversedSorting(_ sender: UIBarButtonItem) {
        
        // toggle - меняе значение на противоположное
        ascendingSorting.toggle()
        
        // меняем иконку кнопки сортировки по возрастанию
        if ascendingSorting {
            reversedCortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedCortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
    }
    
    //MARK: - функция сортировки
    private func sorting() {
        
        // сортируем в зависимости от значения сортировки, либо по убыванию либо по возрастанию
        if segmentedControl.selectedSegmentIndex == 0{
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}


// MARK: - Расширение для поиска
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        // фильтруем realm по полю name и location вне зависимости от регистра, и фильровать будем из параметра searchText
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        
        tableView.reloadData()
    }
}
