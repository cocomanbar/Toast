//
//  ToastOption.swift
//  Toast
//
//  Created by tanxl on 2023/2/25.
//

import Foundation

public struct ToastOption {
    
    public enum Position {
        case top
        case center
        case bottom
    }
    
    public static let `default` = ToastOption()
    
    
    /// user interaction enabled
    public var isUserInteractionEnabled: Bool = true
    
    /// toast animate style，base on `animate = true`
    public var animate: ToastAnimateStyle = .fade
    
    /// custom toast animator
    public var animator: ToastAnimate?
    
    /// the content background cornerRadius
    public var contentCornerRadius: CGFloat = 10
    
    /// text attributes
    public var textAttributes: [NSAttributedStringKey: Any] = {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byCharWrapping
        style.alignment = .center
        style.lineSpacing = 4.5
        return [.font: UIFont.systemFont(ofSize: 17, weight: .medium), .foregroundColor: UIColor.white, .paragraphStyle: style]
    }()
    
    /// detail text attributes
    public var detailTextAttributes: [NSAttributedStringKey: Any] = {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byCharWrapping
        style.alignment = .center
        style.lineSpacing = 4.5
        return [.font: UIFont.systemFont(ofSize: 15, weight: .regular), .foregroundColor: UIColor.white, .paragraphStyle: style]
    }()
    
    /// text numberOfLines
    public var textNumberOfLines: Int = 0
    
    /// detail text numberOfLines
    public var detailTextNumberOfLines: Int = 0
        
    /// text label top space value，valid when top view existed
    public var textTopSpace: CGFloat = 8
    
    /// detail text view top space value，valid when top view existed
    public var detailTextTopSpace: CGFloat = 8
    
    /// conetnt limit mini size
    public var contentMinimumSize: CGSize?
    
    /// toast position
    public var toastPosition: Position = .center
    
    /// toast marginInsets  in supper view without safeAreaInsets
    public var marginInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    
    /// the background blurEffect style
    public var backgroundBlurStyle: UIBlurEffect.Style?
    
    /// the background blurEffect foreground color，base on `backgroundBlurStyle`
    public var backgroundForegroundColor: UIColor?
    
    
    // MARK: - content background style
    
    /// the content insets
    public var contentInset: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    /// the content background blurEffect style
    public var contentBlurStyle: UIBlurEffect.Style?
    
    /// the content background blurEffect foreground color，base on `contentBackgroundBlurStyle`
    public var contentForegroundColor: UIColor?
    
    /// the content background color，if not blurEffect
    public var contentColor: UIColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
    
}
