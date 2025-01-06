//
//  UIStackView+Extension.swift
//  Live It
//
//  Created by Muniyaraj on 20/08/24.
//

import UIKit

extension UIStackView{
    convenience init(arrangedSubViews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) {
        self.init(arrangedSubviews: arrangedSubViews)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        translatesAutoresizingMaskIntoConstraints = false
    }
    func addBackgroundColor(_ color: UIColor){
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
