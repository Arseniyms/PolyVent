//
//  EventSecurityViewController.swift
//  EventPasser
//
//  Created by Arseniy Matus on 04.12.2022.
//
//

import AVFoundation
import UIKit

class EventSecurityViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        setupUI()
        setupCameraView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presenter?.stopRunning()
    }

    
    // MARK: - Properties

    var presenter: ViewToPresenterEventSecurityProtocol?
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    var cameraView: UIView = .init()
    var tableContentView: UIView = .init()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 10
        tableView.layer.borderColor = UIColor.systemGray.cgColor
        tableView.layer.borderWidth = 1
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.rowHeight = 44
        
        tableView.delegate = presenter
        tableView.dataSource = presenter
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: Constants.userCellIdentifier)

        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Functions
    
    func setupUI() {
        view.backgroundColor = .customBackgroundColor
        
        self.view.addSubview(tableContentView)
        self.view.addSubview(cameraView)
        
        tableContentView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            cameraView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            tableContentView.topAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: 20),
            tableContentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tableContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
        ])
        
        tableContentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(refreshControl)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableContentView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContentView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableContentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContentView.trailingAnchor),
        ])
        
        self.cameraView.layoutIfNeeded()
    }
    
    func setupCameraView() {
        cameraView.backgroundColor = .black
        
        guard let captureSession = presenter?.captureSession else { return }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
        previewLayer.frame = cameraView.layer.bounds
        previewLayer.cornerRadius = 10
        cameraView.layer.cornerRadius = 10
        cameraView.layer.addSublayer(previewLayer)
        presenter?.startRunning()
    }
    
    @objc func refresh() {
        presenter?.refresh()
    }
    
}

extension EventSecurityViewController: PresenterToViewEventSecurityProtocol {
    func updateTitle(with title: String) {
        self.navigationItem.title = title
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}
