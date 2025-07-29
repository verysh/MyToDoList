//
//  ToDoListItemViewCell.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 22.07.2025.
//

import Foundation
import UIKit

final class ToDoListItemViewCell: UITableViewCell {
    // MARK: - Public Properties
    var onCheckmarkTapped: (() -> Void)?  // protocol
     
    // MARK: - Private Properties
    private lazy var checkmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let normalImage = UIImage(systemName: "circle")
        let selectedImage = UIImage(systemName: "checkmark.circle")

        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        
        button.tintColor = .changeableBlack
        button.backgroundColor = .clear
        
        button.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular_12
        label.textColor = .changeableBlack
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular_12
        label.textColor = .changeableGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        checkmarkButton.isSelected = false
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
    }

    // MARK: - Public Methods
    func configure(with item: ToDoItem,
                   onCheckmarkTapped: @escaping () -> Void) {
        self.onCheckmarkTapped = onCheckmarkTapped
        titleLabel.text = item.title
        descriptionLabel.text = item.taskDescription
        dateLabel.text = item.createdAt.toString()
        checkmarkButton.isSelected = item.completed
        updateCellState()
    }
}

// MARK: - Private Methods
private extension ToDoListItemViewCell {
    func setupView() {
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            checkmarkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkmarkButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 28),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),

            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func updateCellState() {
        updateButtonState()
        updateTextFontStyle()
    }
    
    func updateButtonState() {
        checkmarkButton.tintColor = checkmarkButton.isSelected ? .changeableYellow : .changeableBlack
    }

    func updateTextFontStyle() {
        descriptionLabel.textColor = checkmarkButton.isSelected ? .changeableGray : .changeableBlack
        
        let attributedText = NSAttributedString(
            string: titleLabel.text ?? "",
            attributes: checkmarkButton.isSelected
                ? [
                    .font: UIFont.regular_16,
                    .foregroundColor: UIColor.changeableGray,
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]
                : [
                    .font: UIFont.regular_16,
                    .foregroundColor: UIColor.changeableBlack,
                    .strikethroughStyle: 0
                ]
        )
        
        titleLabel.attributedText = attributedText
    }
    
    // MARK: - Actions
    @objc func checkmarkTapped() {
        onCheckmarkTapped?()
    }
}
