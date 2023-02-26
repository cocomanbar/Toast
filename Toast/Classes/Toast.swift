//
//  Toast.swift
//  Toast
//
//  Created by tanxl on 2023/2/25.
//

import Foundation

// MARK: - Simple Examples
public class Toast {
    
    public static func toastText(_ text: String) {
        
        toastText(text, detailText: nil, in: nil)
    }
    
    public static func toastText(_ text: String, in view: UIView) {
        
        toastText(text, detailText: nil, in: view)
    }
    
    public static func toastText(_ text: String, detailText: String) {
        
        toastText(text, detailText: detailText, in: nil)
    }
    
    public static func toastText(_ text: String?, detailText: String?, in view: UIView?) {
        
        toastText(text, detailText: detailText, customView: nil, in: view)
    }
    
    public static func toastSuccessText(_ text: String) {
        
        toastSuccessText(text, in: nil)
    }
    
    public static func toastSuccessText(_ text: String, in view: UIView?) {
        
        let image: UIImage? = UIImage.toastImageName("success")
        let imageView: UIImageView = UIImageView(image: image)
        toastText(text, detailText: nil, customView: imageView, in: view)
    }
    
    public static func toastErrorText(_ text: String) {
        
        toastErrorText(text, in: nil)
    }
    
    public static func toastErrorText(_ text: String, in view: UIView?) {
        
        let image: UIImage? = UIImage.toastImageName("error")
        let imageView: UIImageView = UIImageView(image: image)
        toastText(text, detailText: nil, customView: imageView, in: view)
    }
    
    public static func toastText(_ text: String?, detailText: String?, customView: UIView?, in view: UIView?) {
        
        if text == nil && detailText == nil && customView == nil {
            return
        }
        guard let targetView: UIView = view ?? UIApplication.shared.delegate?.window as? UIView else { return }
        
        let textTime: TimeInterval = Toast.smartDelaySecondsForToastsText(text)
        let detailTextTime: TimeInterval = Toast.smartDelaySecondsForToastsText(text)
        var shouldTime: TimeInterval = max(textTime, detailTextTime)
        if shouldTime == 0 {
            shouldTime = 1.5
        }
        
        let option = ToastOption.default
        let toastView = ToastView(with: targetView, option: option)
        toastView.contentView.customView = customView
        toastView.contentView.text = text
        toastView.contentView.detailText = detailText
        targetView.addSubview(toastView)
        toastView.showToast(animate: true)
        weak var weakToastView: ToastView? = toastView
        DispatchQueue.main.asyncAfter(deadline: .now() + shouldTime) {
            guard let weakToastView = weakToastView else { return }
            weakToastView.hiddenToast(animate: true)
        }
    }
}

extension Toast {
    
    public static func hiddenToast(_ toast: ToastView?) {
        hiddenToast(toast, animate: true)
    }
    
    public static func hiddenToast(_ toast: ToastView?, animate: Bool = true) {
        guard let toast = toast else { return }
        toast.hiddenToast(animate: animate)
    }
    
    public static func hiddenAllToasts(in view: UIView?) {
        hiddenAllToasts(in: view, animate: false)
    }
    
    public static func hiddenAllToasts(in view: UIView?, animate: Bool = false) {
        ToastStorage.shared.hidden(in: view, animate: animate)
    }
}

extension Toast {
    
    public static func smartDelaySecondsForToastsText(_ text: String?) -> TimeInterval {
        
        guard let text = text else { return 0 }
        
        var length: Int = 0
        
        for value in text {
            if value.isASCII {
                length += 1
            } else {
                length += 2
            }
        }
        
        if length < 20 {
            return 1.5
        } else if length <= 40 {
            return 2.0
        } else if length <= 50 {
            return 2.5
        }
        
        return 3.0
    }
}
