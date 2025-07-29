//
//  ToDoItemDetailViewController.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//
 
import Foundation
import UIKit

protocol ToDoItemDetailViewProtocol: UIViewController {
    func displayDataItem(title: String, date: String, text: String?)
}

final class ToDoItemDetailViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Public Properties
    var presenter: ToDoItemDetailPresenterProtocol?

    // MARK: - Private Properties
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.bold_34
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular_12
        label.textColor = .changeableGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.regular_16
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.layer.borderWidth = 0
        textView.layer.shadowOpacity = 0
        textView.textAlignment = .left
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = UIEdgeInsets.zero
        return textView
    }()

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.delegate = self
        setupSubviews()
        setupConstraints()
        presenter?.showData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.endEditing(title: titleTextField.text, text: textView.text)
    }
}

extension ToDoItemDetailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController !== self { presenter?.dismiss() }
    }
}

// MARK: - Public Methods
extension ToDoItemDetailViewController: ToDoItemDetailViewProtocol {
    func displayDataItem(title: String, date: String, text: String?) {
        titleTextField.text = title
        dateLabel.text = date
        textView.text = text
    }
}

// MARK: - Private Methods
private extension ToDoItemDetailViewController {
    
    func setupSubviews() {
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(textView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
