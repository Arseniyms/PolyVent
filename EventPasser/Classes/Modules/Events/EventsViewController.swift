//
//  EventsViewController.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.10.2022.
//
//

import UIKit

class EventsViewController: UIViewController {
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        setupNavigationItems()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }

    // MARK: - Properties

    var presenter: ViewToPresenterEventsProtocol?

    lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.delegate = presenter
        tableview.dataSource = presenter
        tableview.register(EventTableViewCell.self, forCellReuseIdentifier: Constants.eventCellIdentifier)
        tableview.keyboardDismissMode = .onDrag
        tableview.separatorStyle = .none
        return tableview
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()

    lazy var searchControl: UISearchController = {
        let searchControl = UISearchController()
        searchControl.obscuresBackgroundDuringPresentation = false
        searchControl.searchBar.enablesReturnKeyAutomatically = false
        searchControl.searchBar.returnKeyType = .done
        searchControl.searchBar.placeholder = "Поиск"
        definesPresentationContext = true

        if #available(iOS 16.0, *) {
            searchControl.scopeBarActivation = .onSearchActivation
        }
        searchControl.searchResultsUpdater = presenter
        searchControl.searchBar.delegate = presenter

        return searchControl
    }()

    // MARK: - Functions

    func setupNavigationItems() {
        if #available(iOS 13.0, *) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(addEventTapped))
        } else {
            let button = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addEventTapped))
            self.navigationItem.leftBarButtonItem = button
        }

        var qr = UIBarButtonItem()
        if #available(iOS 13.0, *) {
            qr = UIBarButtonItem(image: UIImage(systemName: "qrcode.viewfinder"), style: .plain, target: self, action: #selector(qrButtonTapped))
        } else {
            qr = UIBarButtonItem(title: "Для охраны", style: .plain, target: self, action: #selector(qrButtonTapped))
        }
        navigationItem.rightBarButtonItem = qr

        self.navigationController?.navigationBar.tintColor = .buttonColor
        navigationItem.searchController = searchControl
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    @objc private func qrButtonTapped() {
        presenter?.goToLoginEvent()
    }

    @objc func addEventTapped(_: UIButton) {
        presenter?.goToAddEvent()
    }

    func setupUI() {
        view.backgroundColor = .customBackgroundColor

        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        tableView.addSubview(refreshControl)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc func refresh() {
        presenter?.refresh(with: searchControl.searchBar.text)
    }
}

extension EventsViewController: PresenterToViewEventsProtocol {
    func setNavigationTitle(_ title: String) {
        self.navigationItem.title = title
    }

    func reloadData() {
        refreshControl.endRefreshing()
        tableView.reloadData()
        searchControl.searchBar.scopeButtonTitles = ["\(tableView.numberOfRows(inSection: 0))"]

    }
    
    func stopRefreshing() {
        refreshControl.endRefreshing()
    }
    
    
}
