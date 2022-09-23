//
//  CollectionViewCell.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/09/12.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
//        backgroundColor = .blue
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
//        layer.shadowRadius = 5
//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOffset = .zero
//        layer.shadowOpacity = 0.5
//    }

}

extension CollectionViewCell {
    
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        contentView.addSubview(label)
        
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .white
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
            ])
    }
}

