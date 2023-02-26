//
//  ToastContent.swift
//  Toast
//
//  Created by tanxl on 2023/2/24.
//

import UIKit

public class ToastContent: UIView {

    // MARK: - Set
    
    private var option: ToastOption?
    
    public var customView: UIView? {
        willSet {
            customView?.removeFromSuperview()
        }
        didSet {
            if let customView = customView {
                addSubview(customView)
            }
        }
    }
    
    public var text: String? {
        willSet {
            textLabel.removeFromSuperview()
            textLabel.attributedText = nil
        }
        didSet {
            if let text = text, text.count > 0 {
                addSubview(textLabel)
            }
        }
    }
    
    public var detailText: String? {
        willSet {
            detailTextLabel.removeFromSuperview()
            detailTextLabel.attributedText = nil
        }
        didSet {
            if let detailText = text, detailText.count > 0 {
                addSubview(detailTextLabel)
            }
        }
    }
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutOption(_ option: ToastOption) {
        self.option = option
    }
    
    /// please set a option before call it
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        sizeThatFits(size, option: option ?? ToastOption.default)
    }
    
    public func sizeThatFits(_ size: CGSize, option: ToastOption) -> CGSize {
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        var hasText: Bool = false
        var hasDetailText: Bool = false
        var hasCustomView: Bool = false
        
        if let _ = customView {
            hasCustomView = true
        }
        
        if let text = text, text.count > 0 {
            hasText = true
            textLabel.attributedText = NSAttributedString(string: text, attributes: option.textAttributes)
        }
        
        if let detailText = detailText, detailText.count > 0 {
            hasDetailText = true
            detailTextLabel.attributedText = NSAttributedString(string: detailText, attributes: option.detailTextAttributes)
        }
        
        let maxWidth: CGFloat = size.width - option.contentInset.left - option.contentInset.right
        let maxHeight: CGFloat = size.height - option.contentInset.top - option.contentInset.bottom
        
        if hasCustomView {
            
            let viewSize: CGSize = customView?.frame.size ?? .zero
            width = max(width, viewSize.width)
            width = min(width, maxWidth)
            
            height = height + viewSize.height
        }
        
        if hasText {
            
            let textSize = textLabel.sizeThatFits(CGSize(width: maxWidth, height: maxHeight))
            width = max(width, textSize.width)
            width = min(width, maxWidth)
            
            height = height + textSize.height + (hasCustomView ? option.textTopSpace : 0)
        }
        
        if hasDetailText {
            
            let textSize = detailTextLabel.sizeThatFits(CGSize(width: maxWidth, height: maxHeight))
            width = max(width, textSize.width)
            width = min(width, maxWidth)
            
            height = height + textSize.height + ((hasCustomView || hasText) ? option.detailTextTopSpace : 0)
        }
        
        width = width + option.contentInset.left + option.contentInset.right
        height = height + option.contentInset.top + option.contentInset.bottom
        
        if let contentMinimumSize = option.contentMinimumSize {
            
            width = max(width, contentMinimumSize.width)
            height = max(height, contentMinimumSize.height)
        }

        width = ceil(width)
        height = ceil(height)
        
        return CGSize(width: width, height: height)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let hasText: Bool = textLabel.superview == self
        let hasDetailText: Bool = detailTextLabel.superview == self
        let hasCustomView: Bool = customView?.superview == self
        
        let width: CGFloat = self.frame.width
        let height: CGFloat = self.frame.height
        
        let option: ToastOption = option ?? ToastOption.default
        
        let limitWidth: CGFloat = width - option.contentInset.left - option.contentInset.right
        let contentSize: CGSize = sizeThatFits(bounds.size)
        
        var min_y: CGFloat = option.contentInset.top + (height - contentSize.height) / 2.0
        
        if let customView = customView {
            
            var frame: CGRect = customView.frame
            frame.origin.y = min_y
            frame.origin.x = option.contentInset.left + (limitWidth - frame.width) / 2.0
            customView.frame = frame
            min_y = CGRectGetMaxY(frame)
        }
        
        if hasText {
            var frame: CGRect = textLabel.frame
            let textSize: CGSize = textLabel.sizeThatFits(CGSize(width: limitWidth, height: CGFloat.infinity))
            
            frame.origin.x = option.contentInset.left
            frame.origin.y = min_y + (hasCustomView ? option.textTopSpace : 0)
            frame.size.width = limitWidth
            frame.size.height = textSize.height
            textLabel.frame = frame
            min_y = CGRectGetMaxY(frame)
        }
        
        if hasDetailText {
            var frame: CGRect = detailTextLabel.frame
            let textSize: CGSize = detailTextLabel.sizeThatFits(CGSize(width: limitWidth, height: CGFloat.infinity))
            
            frame.origin.x = option.contentInset.left
            frame.origin.y = min_y + ((hasCustomView || hasText) ? option.detailTextTopSpace : 0)
            frame.size.width = limitWidth
            frame.size.height = textSize.height
            detailTextLabel.frame = frame
            min_y = CGRectGetMaxY(frame)
        }
    }
    
    
    // MARK: - lazy
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.isOpaque = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var detailTextLabel: UILabel = {
        let label = UILabel()
        label.isOpaque = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
}
