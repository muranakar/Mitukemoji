//
//  CollectionViewCell.swift
//  CollectionViewSample2022-06-23
//
//  Created by 村中令 on 2022/06/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var label: UILabel!

    func configure(text: String) {
        label.text = text
    }
}
