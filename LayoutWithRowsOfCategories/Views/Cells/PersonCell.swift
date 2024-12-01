//
//  PersonCell.swift
//  MyApp3
//
//  Created by Robert Ryan on 12/1/24.
//

import UIKit

class PersonCell: UICollectionViewCell {
    static let reuseIdentifier = "PersonCell"
    @IBOutlet weak var nameLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
}

private extension PersonCell {
    func configure() {
        contentView.backgroundColor = UIColor(hue: .random(in: 0...1), saturation: 0.5, brightness: 1, alpha: 1)
        contentView.layer.cornerRadius = 5
    }
}
