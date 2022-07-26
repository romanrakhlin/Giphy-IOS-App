//
//  UIColor+Extension.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/26/22.
//

import UIKit

extension UIColor {
    
    static var randomColor: UIColor {
        let colorArray: [UIColor] = [
            Asset.ShimmerColors.blue.color,
            Asset.ShimmerColors.green.color,
            Asset.ShimmerColors.pink.color
        ]
        
        let randomIndex = Int.random(in: 0...2)
        return colorArray[randomIndex]
    }
}
