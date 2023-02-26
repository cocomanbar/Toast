//
//  ViewController.swift
//  Toast
//
//  Created by cocomanbar on 02/24/2023.
//  Copyright (c) 2023 cocomanbar. All rights reserved.
//

import UIKit
import Toast

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let imageView = UIImageView(image: UIImage(named: "text_bg"))
        imageView.contentMode = .scaleToFill
        view.addSubview(imageView)
        imageView.frame = view.bounds
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("????????")
        
//        test0()
//        test1()
//        test2()
//        test3()
                
        animate()
        
    }
    
    func animate() {
        
        Toast.toastSuccessText("成功操作!")
    }
    
    
    // 一个图片
    func test0() {
        
        var option = ToastOption.default
        option.contentBlurStyle = .dark
//        option.contentColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
        
        let toastView = ToastView(with: view, option: option)
        
        toastView.contentView.customView = UIImageView(image: UIImage(named: "text_bg"))
        
        view.addSubview(toastView)
        
        toastView.showToast(animate: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            toastView.hiddenToast(animate: true)
        }
    }
    
    // 一行字
    func test1() {
        
        var option = ToastOption.default
        option.contentBlurStyle = .dark
//        option.contentColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
        option.textAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        
        let toastView = ToastView(with: view, option: option)
        toastView.contentView.text = "温馨提示"
        
        view.addSubview(toastView)
        
        toastView.showToast(animate: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            toastView.hiddenToast(animate: true)
        }
    }
    
    // 两行字
    func test2() {
        
        var option = ToastOption.default
        option.contentBlurStyle = .light
//        option.contentColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
        
        option.detailTextTopSpace = 20
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.lineBreakMode = .byCharWrapping
        textStyle.alignment = .center
        textStyle.lineSpacing = 0
        option.textAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .medium), .foregroundColor: UIColor.white, .paragraphStyle: textStyle]
        
        let detailStyle = NSMutableParagraphStyle()
        detailStyle.lineBreakMode = .byCharWrapping
        detailStyle.alignment = .center
        detailStyle.lineSpacing = 5
        option.detailTextAttributes = [.font: UIFont.systemFont(ofSize: 15, weight: .regular), .foregroundColor: UIColor.white, .paragraphStyle: detailStyle]
        
        let toastView = ToastView(with: view, option: option)
        
        toastView.contentView.customView = nil
        toastView.contentView.text = "温馨提示"
        toastView.contentView.detailText = "这是一句话，很重要的话。这是一句话，很重要的话。这是一句话，很重要的话。这是一句话，很重要的话。这是一句话，很重要的话。这是一句话，很重要的话。"
        
        view.addSubview(toastView)
        
        toastView.showToast(animate: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            toastView.hiddenToast(animate: true)
        }
    }

    // 两行字 + 图片
    func test3() {
        
        var option = ToastOption.default
        option.contentBlurStyle = .light
//        option.contentColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
        option.toastPosition = .bottom
        option.animate = .zoom
        
        option.textTopSpace = 8
        option.detailTextTopSpace = 10
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.lineBreakMode = .byCharWrapping
        textStyle.alignment = .center
        textStyle.lineSpacing = 0
        option.textAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .medium), .foregroundColor: UIColor.white, .paragraphStyle: textStyle]
        
        let detailStyle = NSMutableParagraphStyle()
        detailStyle.lineBreakMode = .byCharWrapping
        detailStyle.alignment = .center
        detailStyle.lineSpacing = 5
        option.detailTextAttributes = [.font: UIFont.systemFont(ofSize: 15, weight: .regular), .foregroundColor: UIColor.white, .paragraphStyle: detailStyle]
        
        
        option.animator = ToastAnimator111()
        
        let toastView = ToastView(with: view, option: option)
        
        toastView.contentView.customView = UIImageView(image: UIImage(named: "tips_done"))
        toastView.contentView.text = "温馨提示"
        toastView.contentView.detailText = "这是一句话，很重要的话。这是一句话，很重要的话。这是一句话，很重要的话。这是一句话，很重要的话。这是一句话，很重要的话。这是一句话，很重要的话。"
        
        view.addSubview(toastView)
        
        toastView.showToast(animate: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            toastView.hiddenToast(animate: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


class ToastAnimator111: NSObject, ToastAnimate {
    
    private weak var toastView: ToastView?
    
    func bindToastView(_ toastView: ToastView) {
        
        self.toastView = toastView
    }
    
    func showAnimate(_ completion: @escaping ToastAnimationBlock) {
        
        let alpha: CGFloat = 1.0
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState]) {
            self.toastView?.alpha = alpha
            self.toastView?.contentView.alpha = alpha
        } completion: { finished in
            completion(finished)
        }
    }
    
    func hiddenAnimate(_ completion: @escaping ToastAnimationBlock) {
        
        let alpha: CGFloat = 0.0
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState]) {
            self.toastView?.alpha = alpha
            self.toastView?.contentView.alpha = alpha
        } completion: { finished in
            completion(finished)
        }
    }
    
}
