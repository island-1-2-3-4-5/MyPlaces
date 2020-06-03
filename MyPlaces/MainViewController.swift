//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Roman on 03.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    
    // массив с названиями заведений заведениями
    let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    // MARK: - Table view data source

    

// MARK: Возвращает количество строк
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // зависит от количества элементов в массиве
        return restaurantNames.count
    }


    // Конфигурация ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // присваиваем названия заведений, с помощью сопоставления индексов ячеек и индексов значений массива
        cell.textLabel?.text = restaurantNames[indexPath.row]
        // Присваиваем изображение, при этом названия изображений должны совпадать с названиями ресторанов
        cell.imageView?.image = UIImage(named: restaurantNames[indexPath.row])

        return cell
    }
    
/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
