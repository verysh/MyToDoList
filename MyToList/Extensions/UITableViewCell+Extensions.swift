//
//  UITableViewCell+Extensions.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 28.07.2025.
//

import UIKit

extension UITableViewCell {
    class var reuseId: String { return String(describing: self) }
}
