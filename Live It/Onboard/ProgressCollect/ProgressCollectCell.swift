//
//  ProgressCollectCell.swift
//  Live It
//
//  Created by Muniyaraj on 21/08/24.
//

import UIKit

class ProgressCollectCell: UICollectionViewCell,StoryboardCell{
    
    var segmentedProgressView: SegmentedProgressLoaderView = SegmentedProgressLoaderView()
    
    var localizationService: LocalizationService?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initailzeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initailzeUI()
    }
    private func initailzeUI(){
        addSubview(segmentedProgressView)
        segmentedProgressView.shapeLayer.lineWidth = frame.size.height
        segmentedProgressView.trackLayer.lineWidth = frame.size.height
        segmentedProgressView.makeConstraints(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor,edge: .init(top: 0, left: 0, bottom: 0, right: 0))
        segmentedProgressView.makeCenterConstraints(toView: self,centerY_axis: false)
    }
    func setupConfigure(localizeService: LocalizationService?){
        let sem_attribute: UISemanticContentAttribute = localizeService?.currentLanguage == .arabic ? .forceRightToLeft : .forceLeftToRight
        segmentedProgressView.semanticContentAttribute = sem_attribute
    }
    
}
