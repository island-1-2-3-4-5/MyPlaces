//
//  CustomTableViewCell.swift
//  MyPlaces
//
//  Created by Roman on 03.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import UIKit

// Этот класс нужен бля того, чтобы мы могли работать с содержимым этой ячейки
class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlace: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    

}
