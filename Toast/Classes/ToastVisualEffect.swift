//
//  ToastVisualEffect.swift
//  Toast
//
//  Created by tanxl on 2023/2/24.
//

import UIKit

class ToastVisualEffect: UIVisualEffectView {

    // MARK: - Set
    
    var foregroundColor: UIColor? {
        didSet {
            foregroundLayer.backgroundColor = foregroundColor?.cgColor
        }
    }
    
    // MARK: - Init
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        contentView.layer.addSublayer(foregroundLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        foregroundLayer.frame = contentView.bounds
    }
    
    // MARK: - Lazy
    
    private lazy var foregroundLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.clear.cgColor
        return layer
    }()

}
