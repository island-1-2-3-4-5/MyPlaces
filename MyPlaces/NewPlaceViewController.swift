//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Roman on 03.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

// selection - none для 2-4й ячейки, чтобы они не выделялись
// Для открытия информации о уже имеющейся ячейке с заполнением всех полей, создадим отдельный метод private func setupEditScreen()

import UIKit

class NewPlaceViewController: UITableViewController {
// это свойство содержит информацию о текущей выбранной ячейке
    var currentPlace: Place!
    var imageIsChanged = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // убираем разлиновку после ячеек
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        
        // блокируем кнопку  save
        saveButton.isEnabled = false
        
        // это поле обязательно для заполнения, поэтому будем отслеживать заполнение для разблокировки save
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
       
        // вызываем метод передачи информации об ячейке
        setupEditScreen()
   
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        // если происходит нажатие на первую ячейку, то клавиатура не скрывается, надо для выбора изображения
        if indexPath.row == 0 {
            
            
            // создаем 2 объекта с изображениями для отображения в AlertController
            let cameraIcon = #imageLiteral(resourceName: "camera") // выбрали Image Literal
            let photoIcon = #imageLiteral(resourceName: "photo")
            
        
            
            // экземпляр AlertController
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            // первая кнопка - вызывает камеру
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
               
                // источник данных камера
                self.chooseImagePicker(sourse: .camera)
            }
            
            camera.setValue(cameraIcon, forKey: "image")
            // сдвигаем текст влево на всплывающем уведомлении
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            
            
            // вторая кнопка - вызывает галерею
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                // источник данных - галерея
                self.chooseImagePicker(sourse: .photoLibrary)
            }
            
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            // кнопка выхода
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            // добавляем действия
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            // отображаем AlertController
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    
// MARK: Сохраняем новое место
    func savePlace() {
        
        
        var image: UIImage?
        
        if imageIsChanged{
            image = placeImage.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        // делаем приведение типа, тк наша модель может работать только с Data
        let imageData = image?.pngData()
        
        // инициализируем с помощью вспомогательного инициализатора
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData,
                             rating: Double(ratingControl.rating))
        
        if currentPlace != nil {
            try! realm.write{
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            // сохраняем новый объект в базе
            StorageManager.saveObject(newPlace)
        }
        
        
    }
    
    
    
    // MARK: Функция для редактирования
    private func setupEditScreen() {
        if currentPlace != nil {
            
            // если выбранная ячейка не пустая, то вызывается метод для навигации
            setupNavigationBar()
            imageIsChanged = true // это надо для того, чтобы не пропадало изображение
            
            // т.к. в нашей модели изображение хранится в формате Data, то нам надо обратно преобразовать его в UIImage
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else {return}
            
            // перезаполняем наши Outlets
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill // для правильного отображения картинки
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            ratingControl.rating = Int(currentPlace.rating)
        }
    }
    
    //MARK: Навигация при редактировании
    private func setupNavigationBar() {
        // если существует Item в навигационном баре, то можно там что-то изменить
        if let topItem = navigationController?.navigationBar.topItem {
            // меняем наименование кнопки возврата
            topItem.backBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)
        }
        
        navigationItem.leftBarButtonItem = nil // убираем кнопку cancel, чтобы вметсо неё была кнопка back
        // меняем заголовок на название выбранного места
        title = currentPlace?.name
        // делаем кнопку save активной
        saveButton.isEnabled = true
    }
    
    
   
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    

}

// MARK: TEXT field delegate

extension NewPlaceViewController: UITextFieldDelegate{
   
    //скрываем клавиатуру при нажатии done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // блокируем кнопку save
    @objc private func textFieldChanged(){
        if placeName.text?.isEmpty == false{
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}


// MARK: Работа с изображением
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // выбор фото из библиотеки пользователя
    func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
        
        // определяем источник данных, если он доступен тогда
        if UIImagePickerController.isSourceTypeAvailable(sourse){
            let imagePicker = UIImagePickerController()
            
            //imagePicker должен делегировать обязанности
            imagePicker.delegate = self
             // позволим пользователю редактировать изображение, например обрезать
            imagePicker.allowsEditing = true
            // определяем тип источника
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
        }
    }
    
    // этот метод позволяет присвоить выбранное изображение аутлету
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // взяли значение по ключу editedImage и присвоили это значение  как UIImage свойству imageOfPlace
        placeImage.image = info[.editedImage] as? UIImage // данный тип контента позволяет использовать  отредактированное пользователем изображение
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        
        imageIsChanged = true
        // закрываем imagePickerController
        dismiss(animated: true)
    }
}
