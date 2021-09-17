//
//  Extensions.swift
//  Challenge #11
//
//  Created by Bruno Benčević on 8/27/21.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        let threshold: CGFloat = 0.25
        return UIColor(red: CGFloat.maximum(CGFloat.random(in: 0...1), threshold),
                       green: CGFloat.maximum(CGFloat.random(in: 0...1), threshold),
                       blue: CGFloat.maximum(CGFloat.random(in: 0...1), threshold),
                       alpha: 1.0)
    }
}
