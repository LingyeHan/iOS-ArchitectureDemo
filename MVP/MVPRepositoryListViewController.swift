//
//  MVPRepositoryListViewController.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/1/28.
//

import UIKit
import SafariServices

class MVPRepositoryListViewController: UITableViewController {
    private lazy var presenter = RepositoryListPresenter(view: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        setupUI()
        loadData()
        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }

    private func setupUI() {
        let chooseLanguageButton = UIBarButtonItem(barButtonSystemItem: .organize,
                                                   target: self,
                                                   action: #selector(openLanguageList))
        navigationItem.rightBarButtonItem = chooseLanguageButton

        refreshControl = UIRefreshControl()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.insertSubview(refreshControl!, at: 0)
        tableView.register(UINib(nibName: RepositoryCell.className, bundle: nil), forCellReuseIdentifier: RepositoryCell.className)
    }

    @objc
    internal func loadData() {
        presenter.loadData()
    }

    @objc
    private func openLanguageList() {
        let languageListVC = MVPLanguageListViewController()
        languageListVC.delegate = self
        present(languageListVC, animated: true)
    }

    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }

    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.className, for: indexPath) as! RepositoryCell
        let repo = presenter.repositories[indexPath.row]
        cell.selectionStyle = .none
        cell.setName(repo.fullName)
        cell.setDescription(repo.description)
        cell.setStarsCountTest("⭐️ \(repo.starsCount)")
        return cell
    }

    // MARK: - UITableViewDelegate {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = presenter.repositories[indexPath.row]
        let url = URL(string: repository.url)!
        let safariViewController = SFSafariViewController(url: url)
        navigationController?.pushViewController(safariViewController, animated: true)
    }
}

extension MVPRepositoryListViewController: RepositoryListView {
    func startLoading() {
        refreshControl?.beginRefreshing()
        navigationItem.title = presenter.currentLanguage
    }
    
    func finishLoading() {
        refreshControl?.endRefreshing()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showAlert(message: String) {
        presentAlert(message: message)
    }
}


extension MVPRepositoryListViewController: LanguageListViewControllerDelegate {
    func languageListViewController(_ viewController: UIViewController, didSelectLanguage language: String) {
        presenter.loadData(byLanguage: language)
        dismiss(animated: true)
    }

    func languageListViewControllerDidCancel(_ viewController: UIViewController) {
        dismiss(animated: true)
    }
}

