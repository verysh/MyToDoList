//
//  LoadingPlaceholderView.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 28.07.2025.
//

import UIKit

final class LoadingPlaceholderView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label, activityIndicator])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.isHidden = false
        return spinner
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Загрузка данных..."
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()

    // MARK: - Initializers
     override init(frame: CGRect) {
       super.init(frame: frame)
        setUpLayout()
     }
     
     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       setUpLayout()
     }
}

private extension LoadingPlaceholderView {
    func setUpLayout() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
