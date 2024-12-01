//
//  InterestCell.swift
//  MyApp3
//
//  Created by Robert Ryan on 12/1/24.
//

import UIKit

class InterestCell: UICollectionViewCell {
    static let reuseIdentifier = "InterestCell"
    @IBOutlet weak var interestLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
}

private extension InterestCell {
    func configure() {
        contentView.layer.cornerRadius = 5
    }
}
