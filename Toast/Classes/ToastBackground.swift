//
//  ToastBackground.swift
//  Toast
//
//  Created by tanxl on 2023/2/24.
//

import UIKit

// MARK: - make toast background style
public class ToastBackground: UIView {
    
    // MARK: - Pirvate
    
    private var visualEffect: ToastVisualEffect?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
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
        backgroundColor = .clear
        isUserInteractionEnabled = !(option.isUserInteractionEnabled)
        
        
        if let style = option.backgroundBlurStyle {
            let blurEffect = UIBlurEffect(style: style)
            visualEffect = ToastVisualEffect(effect: blurEffect)
            visualEffect?.foregroundColor = option.backgroundForegroundColor
            visualEffect?.layer.masksToBounds = true
            if let visualEffect = visualEffect {
                addSubview(visualEffect)
            }
        }
    }
    
}
