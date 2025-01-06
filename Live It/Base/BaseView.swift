//
//  BaseView.swift
//  Live It
//
//  Created by Muniyaraj on 20/08/24.
//

import UIKit

/// Base View
class BaseView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalizeUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initalizeUI()
    }
    func initalizeUI(){}
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initalizeUI()
    }
}


/// Base Button
class BaseButton: UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalizeUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initalizeUI()
    }
    func initalizeUI(){
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initalizeUI()
    }
}

/// Base Label
class BaseLabel: UILabel{
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalizeUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initalizeUI()
    }
    func initalizeUI(){}
}

/// Base ImageView
class BaseImageView: UIImageView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalizeUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initalizeUI()
    }
    func initalizeUI(){}
}
