//
//  ToastView.swift
//  Toast
//
//  Created by tanxl on 2023/2/24.
//

import UIKit

public class ToastView: UIView {
    
    // MARK: - Public Properties
    
    public var toastDidAppear: (() -> Void)?
    
    public var toastDidDisappear: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var option: ToastOption?
    private weak var targetView: UIView?
    
    // MARK: - Init
    
    private init() {
        super.init(frame: .zero)
    }
    
    public init(with targetView: UIView, option: ToastOption) {
        super.init(frame: targetView.bounds)
        
        self.option = option
        self.targetView = targetView
        
        alpha = 0.0
        backgroundColor = .clear
        isUserInteractionEnabled = !option.isUserInteractionEnabled
        
        // add conetent background firstly
        addSubview(conetntBackground)
        conetntBackground.layoutOption(option)
        
        // add conetent
        addSubview(contentView)
        contentView.layoutOption(option)
        
        // add mask background lastly
        addSubview(background)
        background.layoutOption(option)
        
        // add notifications
        NotificationCenter.default.addObserver(forName: NSNotification.Name.toast_didChangeStatusBarOrientationNotification,
                                               object: nil,
                                               queue: OperationQueue.main)
        { [weak self] notify in
            guard let self = self, let _ = self.targetView else { return }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let targetView = targetView, let option = option else { return }
                
        let targetBounds: CGRect = targetView.bounds
        
        self.frame = targetBounds
        background.frame = targetBounds
        
        var marginInsets: UIEdgeInsets = option.marginInsets
        if #available(iOS 11.0, *) {
            let safeAreaInsets = targetView.safeAreaInsets
            marginInsets.top += safeAreaInsets.top
            marginInsets.left += safeAreaInsets.left
            marginInsets.right += safeAreaInsets.right
            marginInsets.bottom += safeAreaInsets.bottom
        }
        
        let limitWidth: CGFloat = targetBounds.width - marginInsets.left - marginInsets.right
        let limitHeight: CGFloat = targetBounds.height - marginInsets.top - marginInsets.bottom
        
        var contentSize: CGSize = contentView.sizeThatFits(CGSize(width: limitWidth, height: limitHeight))
        contentSize.width = min(contentSize.width, limitWidth)
        contentSize.height = min(contentSize.height, limitHeight)
        
        let content_x: CGFloat = max(marginInsets.left, (targetBounds.width - contentSize.width) / 2.0)
        var content_y: CGFloat = 0
        switch option.toastPosition {
        case .top:
            content_y = marginInsets.top
        case .center:
            content_y = max(marginInsets.top, (targetBounds.height - contentSize.height) / 2.0)
        case .bottom:
            content_y = targetBounds.height - contentSize.height - marginInsets.bottom
        }
        
        let frame: CGRect = CGRect(x: content_x, y: content_y, width: contentSize.width, height: contentSize.height)
        contentView.frame = frame
        conetntBackground.frame = frame
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        
        targetView = nil
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // show
        if let _ = superview {
            ToastStorage.shared.append(self)
        }
        // hidden
        else {
            ToastStorage.shared.remove(self)
        }
    }
    
    // MARK: - Lazy
    
    private(set) lazy var animator: ToastAnimator = {
        ToastAnimator()
    }()
    
    public private(set) lazy var background: ToastBackground = {
        let view = ToastBackground(frame: .zero)
        return view
    }()
    
    public private(set) lazy var contentView: ToastContent = {
        let view = ToastContent(frame: .zero)
        return view
    }()
    
    public private(set) lazy var conetntBackground: ToastContentBackground = {
        let view = ToastContentBackground(frame: .zero)
        return view
    }()
    
}


// MARK: - Animate

extension ToastView {
    
    public func showToast(animate: Bool) {
        
        // make marking before layout different status
        setNeedsLayout()
        
        if animate == false {
            alpha = 1.0
            toastDidAppear?()
            return
        }
        
        if let animator = option?.animator {
            
            animator.bindToastView(self)
            animator.showAnimate { [weak self] finished in
                self?.toastDidAppear?()
            }
        } else {
            
            animator.bindToastView(self)
            animator.animate = option?.animate ?? .fade
            animator.showAnimate { [weak self] finished in
                self?.toastDidAppear?()
            }
        }
    }
    
    public func hiddenToast(animate: Bool) {
        
        if animate == false {
            alpha = 0.0
            removeFromSuperview()
            toastDidDisappear?()
            return
        }
        
        if let animator = option?.animator {
            
            animator.bindToastView(self)
            animator.hiddenAnimate { [weak self] finished in
                self?.removeFromSuperview()
                self?.toastDidDisappear?()
            }
        } else {
            
            animator.bindToastView(self)
            animator.animate = option?.animate ?? .fade
            animator.hiddenAnimate { [weak self] finished in
                self?.removeFromSuperview()
                self?.toastDidDisappear?()
            }
        }
    }
}


// MARK: - Cache Toast

class ToastStorage {
     
    static let shared = ToastStorage()
    
    lazy var kToastViews: [ToastView] = [ToastView]()
    
    lazy var lock: NSLock = {
        let lock = NSLock()
        lock.name = "\(String(describing: self)).Lock"
        return lock
    }()
    
    func append(_ toast: ToastView?) {
        guard let toast = toast else { return }
        
        lock.lock()
        if kToastViews.contains(where: { view in
            view.isEqual(toast)
        }) {
            lock.unlock()
            return
        }
        
        kToastViews.append(toast)
        lock.unlock()
    }
    
    func remove(_ toast: ToastView?) {
        guard let toast = toast else { return }
        
        lock.lock()
        kToastViews.removeAll { view in
            view.isEqual(toast)
        }
        lock.unlock()
    }
    
    func hidden(in targetView: UIView?) {
        
        hidden(in: targetView)
    }
    
    func hidden(in targetView: UIView?, animate: Bool = false) {
        
        guard let result = allToast(in: targetView) else { return }
        
        for toast in result {
            
            toast.hiddenToast(animate: animate)
        }
    }
    
    func allToast(in view: UIView?) -> [ToastView]? {
        
        let toastViews = kToastViews
        
        guard let targetView = view ?? UIApplication.shared.delegate?.window as? UIView, !toastViews.isEmpty else {
            return nil
        }
        
        var result: [ToastView] = [ToastView]()
        
        for toast in toastViews {
            if let superview = toast.superview, superview.isEqual(targetView) {
                result.append(toast)
            }
        }
        return result
    }
}
