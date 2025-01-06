//
//  UIImage+Extension.swift
//  Live It
//
//  Created by Muniyaraj on 20/08/24.
//

import UIKit

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
extension UIView{
    func addBlurEffect() {
        let hasBlurEffect = subviews.contains{ $0 is UIVisualEffectView }
        guard !hasBlurEffect else { return }
        let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }
    func removeBlurEffect()  {
        for subview in subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    func cornerLeft()  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [ .topRight , .bottomRight], cornerRadii: CGSize(width: 15, height: 15)).cgPath
        self.layer.mask = rectShape
    }
}
protocol StoryboardCell{
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}
extension StoryboardCell{
    static var reuseIdentifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: reuseIdentifier, bundle: nil) }
}

class BaseCollectCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .BackgroundColor
    }
}
