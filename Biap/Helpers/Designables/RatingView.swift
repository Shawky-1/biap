//
//  RatingView.swift
//  Biap
//
//  Created by Ahmed Shawky on 15/03/2023.
//

import Foundation
import UIKit


class RatingView: UIView {
    //MARK: UI Private Configurations
    private let maximumRating = 5
    
    
    //MARK: UI Public Configurations
    var rating: Int = 5
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 2
        return stack
    }()
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
//        configureWithRating(rating: 3)
    }
    
    func setupUI(){
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    func configureWithRating(rating: Int, style: Style = .full){
        switch style {
        case .full:
            // Add filled stars
            if rating > 0 {
                for _ in 1...rating {
                    let image = generateStarView(.filled)
                    stackView.addArrangedSubview(image)
                }
            }
            
            // Add Non-filled stars
            let nonFilledCount = maximumRating - rating
            if nonFilledCount > 0 {
                for _ in 1...nonFilledCount {
                    let image = generateStarView(.nonFilled)
                    stackView.addArrangedSubview(image)
                }
            }
        case .compact:
            let image = generateStarView(.filled)
            let ratingText = UILabel()
            ratingText.text = String(rating)
            ratingText.font = .systemFont(ofSize: 12)
            ratingText.textAlignment = .right
            stackView.addArrangedSubview(ratingText)
            stackView.addArrangedSubview(image)
        }
    }
    
    private func generateStarView(_ type: StarType) -> UIImageView {
        let starImage: UIImage
        switch type {
        case .filled:
            starImage = #imageLiteral(resourceName: "filledStar")
        case .nonFilled:
            starImage = #imageLiteral(resourceName: "star")

        }
        let image = UIImageView(image: starImage)
        image.contentMode = .scaleAspectFit
        image.widthAnchor.constraint(equalToConstant: 17).isActive = true
        return image
    }
    
    enum StarType {
        case filled
        case nonFilled
    }

    enum Style {
        case full
        case compact
    }
}
