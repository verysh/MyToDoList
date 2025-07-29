//
//  UITableView+Extensions.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 28.07.2025.
//

import UIKit

extension UITableView {
    func register(cellTypes: [UITableViewCell.Type]) {
        cellTypes.forEach({ self.register($0, forCellReuseIdentifier: $0.reuseId) })
    }

    func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseId, for: indexPath) as? T else {
            fatalError("\(String(describing: type)) not found")
        }
        return cell
    }
}
