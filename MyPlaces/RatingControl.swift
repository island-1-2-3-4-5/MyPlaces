//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Roman on 15.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import UIKit

//IBDesignable - позволяет отображать содержимое класса прямо в IB
@IBDesignable class RatingControl: UIStackView {

    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    private var ratingButtons = [UIButton]()
    
    // эти свойства будут заменять свойства из atribute inspector
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    

    
    //MARK: - Инициализаторы
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }

    
    //MARK: - Button actions
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
            return
        }
        
        // Расчет рейтинага для выбранной кнопки
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    
    
    //MARK: - Приватные методы
    private func setupButtons(){
        
        // перед утановкой новых значений из IB очищаем старые значения
        for button in ratingButtons{
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Загружаем картинки со звездами
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle,
                                compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar",
                                      in: bundle,
                                      compatibleWith: self.traitCollection)
        
        
        
        
        for _ in 0..<starCount {
            // создаем кнопки
            let button = UIButton()
            
            // устанавливаем изображения
            button.setImage(emptyStar, for: .normal) // пустая звезда
            button.setImage(filledStar, for: .selected) //
            button.setImage(highlightedStar, for: .highlighted) //
            button.setImage(highlightedStar, for: [.highlighted, .selected]) //
            // Constraints
            button.translatesAutoresizingMaskIntoConstraints = false // отключает автоматические привязки
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
                   
            // добавляем action
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
                   
            // помещаем кнопку в stackView
            addArrangedSubview(button)
            
            // добавляем эти кнопки в массив
            ratingButtons.append(button)
        }
        updateButtonSelectionState()
    }
    
    
    
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
    
}
