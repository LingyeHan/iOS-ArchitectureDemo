//
//  MVVMRepositoryListViewController.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/5.
//

import UIKit
import SafariServices

class MVVMRepositoryListViewController: UITableViewController {
    
    var viewModel = MVVMRepositoryListViewModel()
    
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
        viewModel.loadData(byLanguage: viewModel.currentLanguage)
    }
    
    @objc
    private func openLanguageList() {
        let languageListVC = MVCLanguageListViewController()
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
        return viewModel.repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.className, for: indexPath) as! RepositoryCell
        let repo = viewModel.repositories[indexPath.row]
        cell.selectionStyle = .none
        cell.setName(repo.fullName)
        cell.setDescription(repo.description)
        cell.setStarsCountTest("⭐️ \(repo.starsCount)")
        return cell
    }
    
    // MARK: - UITableViewDelegate {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = viewModel.repositories[indexPath.row]
        let url = URL(string: repository.url)!
        let safariViewController = SFSafariViewController(url: url)
        navigationController?.pushViewController(safariViewController, animated: true)
    }
}

extension MVVMRepositoryListViewController: MVVMRepositoryListViewModelDelegate {
    func startLoading() {
        refreshControl?.beginRefreshing()
        navigationItem.title = viewModel.currentLanguage
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


extension MVVMRepositoryListViewController: LanguageListViewControllerDelegate {
    func languageListViewController(_ viewController: UIViewController, didSelectLanguage language: String) {
        viewModel.loadData(byLanguage: language)
        dismiss(animated: true)
    }
    
    func languageListViewControllerDidCancel(_ viewController: UIViewController) {
        dismiss(animated: true)
    }
}
