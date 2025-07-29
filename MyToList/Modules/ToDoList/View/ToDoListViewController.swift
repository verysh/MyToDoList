//
//  ToDoListViewController.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//

import Foundation
import UIKit

protocol ToDoListViewProtocol: AnyObject {
    func reloadRow(at indexPath: IndexPath, updatedItems: [ToDoItem])
    func updateSearchItems(_ items: [ToDoItem])
    func reloadData()
    func showToDoItems(_ items: [ToDoItem])
    func showError(error: Error)
    func deteleteRow(at indexPath: IndexPath, updatedItems: [ToDoItem])
}

final class ToDoListViewController: UIViewController {
    
    // MARK: - Public Properties
    var presenter: ToDoListPresenterProtocol?
    
    // MARK: - Private Properties
    
    private var toDoListItems: [ToDoItem] = [] {
        didSet {
            onListUpdated?()
        }
    }
    private var onListUpdated: (() -> Void)?
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = TextConstants.searchBarPlaceholder
        return searchController
    }()

    private lazy var loadingView: LoadingPlaceholderView = {
        let view = LoadingPlaceholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cellTypes: [ToDoListItemViewCell.self])
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        return tableView
    }()
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .changeableLightGray
        footerView.translatesAutoresizingMaskIntoConstraints = false
        return footerView
    }()
    
    private lazy var safeAreaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .changeableLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.changeableBlack
        label.font = UIFont.regular_11
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .changeableYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNewTaskTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializers
    init(presenter: ToDoListPresenterProtocol? = nil) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchToDoList()
        searchController.isActive = false
    }
}

// MARK: - UITableViewDataSource
extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoListItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withType: ToDoListItemViewCell.self,
                                                 for: indexPath)
        let toDoListItem = toDoListItems[indexPath.row]
        cell.configure(with: toDoListItem) { [weak self] in
            guard let self,
                    let currentIndexPath = tableView.indexPath(for: cell) else { return }
            self.checkmarkToDoItem(at: currentIndexPath)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Context Menu Configuration
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        setContextConfiguration(indexPath)
    }
}

// MARK: - UISearchResultsUpdating
extension ToDoListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        searchToDoItemBy(searchText)
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        searchCancel()
    }
}

// MARK: - ToDoListViewProtocol
extension ToDoListViewController: ToDoListViewProtocol {
    
    func updateSearchItems(_ items: [ToDoItem]) {
        DispatchQueue.main.async {
            self.switchLoadingPlaceholder(isLoading: false)
            self.toDoListItems = items
            self.tableView.reloadData()
        }
    }
    
    func showToDoItems(_ items: [ToDoItem]) {
        toDoListItems = items
        reloadData()
    }
    
    func showError(error: any Error) {
        DispatchQueue.main.async {
            self.displayMessage(error.localizedDescription)
        }
    }
    
    // MARK: - Public Methods
    func reloadData() {
        DispatchQueue.main.async {
            self.switchLoadingPlaceholder(isLoading: false)
            self.tableView.reloadData()
            self.cancelSearchState()
        }
    }
    
    func reloadRow(at indexPath: IndexPath, updatedItems: [ToDoItem]) {
        DispatchQueue.main.async {
            self.toDoListItems = updatedItems
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func deteleteRow(at indexPath: IndexPath, updatedItems: [ToDoItem]) {
        DispatchQueue.main.async {
            self.toDoListItems = updatedItems
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.cancelSearchState()
        }
    }
}

// MARK: - Private Methods
private extension ToDoListViewController {
   
    func setUI() {
        commonSetUp()
        switchLoadingPlaceholder(isLoading: true)
        setUpdateFooterLabel()
    }
    
    func commonSetUp() {
        setupCustomBackButton()
        addSubviews()
        setupNavigation()
        setupConstraints()
    }

    func setupCustomBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = TextConstants.back
        backButton.tintColor = .changeableYellow
        navigationItem.backBarButtonItem = backButton
    }
    
    func addSubviews(){
        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.addSubview(footerView)
        view.addSubview(safeAreaBackgroundView)
        footerView.addSubview(footerLabel)
        footerView.addSubview(addTaskButton)
    }
    
    func setupNavigation() {
        title = TextConstants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func updateFooter(text: String) {
        DispatchQueue.main.async {
            self.footerLabel.text = text
        }
    }
       
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            safeAreaBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            safeAreaBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 50),
            
            footerLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            footerLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            
            addTaskButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            addTaskButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20)
        ])
    }
    
    func switchLoadingPlaceholder(isLoading: Bool) {
        tableView.isHidden = isLoading
        footerView.isHidden = isLoading
        loadingView.isHidden = !isLoading
    }
 
    func searchToDoItemBy(_ title: String) {
        presenter?.searchToDoItemBy(title)
    }
    
    func searchCancel() {
        presenter?.searchToDoItemCancel()
    }

    func checkmarkToDoItem(at indexPath: IndexPath) {
        presenter?.checkmarkToDoItem(at: indexPath)
    }
 
    func createToDoItem(for item: ToDoItem, isNewTask: Bool, indexPath: IndexPath? = nil) {
        presenter?.detailToDoItemEdit(for: item,
                                      isNewTask: isNewTask,
                                      indexPath: indexPath)
    }
    
    func editToDoItem(at indexPath: IndexPath) {
        let item = toDoListItems[indexPath.row]
        createToDoItem(for: item, isNewTask: false, indexPath: indexPath)
    }

    func shareToDoItem(_ item: ToDoItem) {
        displayShareVC([item.title, item.taskDescription ?? ""])
    }

    func removeToDoItem(at indexPath: IndexPath) {
        presenter?.removeToDoItem(at: indexPath)
    }
    
    func setUpdateFooterLabel() {
        onListUpdated = { [weak self] in
            guard let self else { return }
            let text = "\(self.toDoListItems.count) \(TextConstants.footerText)"
            self.updateFooter(text: text)
        }
    }
    
    func setContextConfiguration(_ indexPath: IndexPath) -> UIContextMenuConfiguration {
       
        let toDoListItem = toDoListItems[indexPath.row]
        let config = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ in
            
            let editToDoItem = UIAction(title: TextConstants.edit) { [weak self] _ in
                guard let self else { return }
                self.editToDoItem(at: indexPath)
            }

            let shareToDoItem = UIAction(title: TextConstants.share) { [weak self] _ in
                guard let self else { return }
                self.shareToDoItem(toDoListItem)
            }
            
            let deleteToDoItem = UIAction(title: TextConstants.remove, attributes: .destructive) { [weak self] _ in
                guard let self else { return }
                self.removeToDoItem(at: indexPath)
            }
            
            return UIMenu(title: "", children: [editToDoItem, shareToDoItem, deleteToDoItem])
        }
        return config
    }
    
    func cancelSearchState() {
        self.searchController.searchBar.text = ""
        self.searchCancel()
    }
    
    // MARK: - Actions
    @objc func addNewTaskTapped() {
        createToDoItem(for: ToDoListItemConstants.newToDoListItem,
                       isNewTask: true)
    }
}

