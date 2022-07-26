//
//  NibLoadableView.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import UIKit

public protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
}

public extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
