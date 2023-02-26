//
//  UIImage.swift
//  Toast
//
//  Created by tanxl on 2023/2/26.
//

import Foundation

extension UIImage {
    
    static func toastImageName(_ name: String?) -> UIImage? {
        
        guard let name = name, let bundlePath = Bundle(for: Toast.self).path(forResource: "Toast", ofType: "bundle") else { return nil }
        let bundle = Bundle.init(path: bundlePath)
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)
        return image
    }
}
