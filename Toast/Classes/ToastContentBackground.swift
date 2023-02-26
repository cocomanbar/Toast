//
//  ToastContentBackground.swift
//  Toast
//
//  Created by tanxl on 2023/2/24.
//

import UIKit

// MARK: - make toast content background style
public class ToastContentBackground: UIView {
        
    // MARK: - Pirvate
    
    private var visualEffect: ToastVisualEffect?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.allowsGroupOpacity = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        visualEffect?.frame = bounds
    }
    
    // MARK: - layout option
    
    func layoutOption(_ option: ToastOption) {
        
        visualEffect?.removeFromSuperview()
        visualEffect = nil
        backgroundColor = option.contentColor
        layer.cornerRadius = option.contentCornerRadius
        
        if let style = option.contentBlurStyle {
            
            let blurEffect = UIBlurEffect(style: style)
            visualEffect = ToastVisualEffect(effect: blurEffect)
            visualEffect?.foregroundColor = option.contentForegroundColor
            visualEffect?.layer.masksToBounds = true
            if let visualEffect = visualEffect {
                visualEffect.layer.cornerRadius = layer.cornerRadius
                addSubview(visualEffect)
            }
        }
    }
    
}
