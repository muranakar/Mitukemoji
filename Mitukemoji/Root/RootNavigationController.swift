//
//  RootNavigationController.swift
//  CollectionViewSample2022-06-23
//
//  Created by 村中令 on 2022/06/29.
//

import UIKit

class RootNavigationController: UINavigationController {
    override func awakeFromNib() {
        super.awakeFromNib()
        UINavigationBar.setupAppearance()
    }
}

private extension UINavigationBar {
    static func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = Colors.baseColor

        let navigationBar = self.appearance()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}
