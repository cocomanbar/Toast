//
//  ToastAnimate.swift
//  Toast
//
//  Created by tanxl on 2023/2/24.
//

import Foundation

public typealias ToastAnimationBlock = ((Bool) -> Void)

public protocol ToastAnimate {
    
    func bindToastView(_ toastView: ToastView)
    
    func showAnimate(_ completion: @escaping ToastAnimationBlock)
    func hiddenAnimate(_ completion: @escaping ToastAnimationBlock)
}


// MARK: - Default Animator

public enum ToastAnimateStyle {
    case fade
    case zoom
}

class ToastAnimator: NSObject, ToastAnimate, CAAnimationDelegate {
    
    private weak var toastView: ToastView?
    
    lazy var animate: ToastAnimateStyle = .fade
    
    func bindToastView(_ toastView: ToastView) {
        
        self.toastView = toastView
    }
    
    func showAnimate(_ completion: @escaping ToastAnimationBlock) {
        
        switch animate {
        case .fade:
            fade(isShow: true, completion)
        case .zoom:
            zoom(isShow: true, completion)
        }
    }
    
    func hiddenAnimate(_ completion: @escaping ToastAnimationBlock) {
        switch animate {
        case .fade:
            fade(isShow: false, completion)
        case .zoom:
            zoom(isShow: false, completion)
        }
    }
    
    private func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let closure = anim.value(forKey: "toast_animate_closure") as? ToastAnimationBlock {
            closure(flag)
        }
    }
    
    private func zoom(isShow: Bool, _ completionClosure: @escaping ToastAnimationBlock) {
        
        if isShow {
    
            let from = CGAffineTransformMakeScale(0.01, 0.01)
            let end   = CGAffineTransformIdentity
            if isShow {
                self.toastView?.contentView.transform = from
                self.toastView?.conetntBackground.transform = from
            }
            
            UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0) {
                
                self.toastView?.alpha = 1
                self.toastView?.background.alpha = 1
                self.toastView?.contentView.alpha = 1
                self.toastView?.conetntBackground.alpha = 1
                self.toastView?.contentView.transform = end
                self.toastView?.conetntBackground.transform = end
                
            } completion: { finished in
                
                completionClosure(finished)
            }
            
        } else {
            
            let ani = CABasicAnimation(keyPath: "transform.scale")
            ani.fromValue = NSNumber(floatLiteral: 1.0)
            ani.toValue = NSNumber(floatLiteral: 0.1)
            ani.duration = 0.25
            ani.autoreverses = false
            ani.repeatCount = 0
            ani.isRemovedOnCompletion = false
            ani.fillMode = "forwards"
            ani.delegate = self
            ani.setValue(completionClosure, forKey: "toast_animate_closure")
            self.toastView?.contentView.layer.add(ani, forKey: "zoom_c_key")
            
            let ani2 = ani.copy() as! CABasicAnimation
            // remove the same value for a key
            ani2.setValue(nil, forKey: "zoom_c_key_value")
            self.toastView?.conetntBackground.layer.add(ani2, forKey: "zoom_cb_key")
        }
    }
    
    private func fade(isShow: Bool, _ completionClosure: @escaping ToastAnimationBlock) {
        let alpha: CGFloat = isShow ? 1.0 : 0.0
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState]) {
            self.toastView?.alpha = alpha
            self.toastView?.background.alpha = alpha
            self.toastView?.contentView.alpha = alpha
            self.toastView?.conetntBackground.alpha = alpha
        } completion: { finished in
            completionClosure(finished)
        }
    }
    
}
