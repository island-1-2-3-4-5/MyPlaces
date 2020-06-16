//
//  CustomTableViewCell.swift
//  MyPlaces
//
//  Created by Roman on 03.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import UIKit
import Cosmos

// Этот класс нужен бля того, чтобы мы могли работать с содержимым этой ячейки
class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlace: UIImageView! {
        didSet {
            // закругляем картинки, отталкиваемся от высоты изображения
            imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height / 2
            // обрезаем изображение
            imageOfPlace.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!{
        didSet {
            cosmosView.settings.updateOnTouch = false // убираем возможность редактирования рейтинга в ячейке, редактировать можно только в окне редактирования
            
        }}
    

}
