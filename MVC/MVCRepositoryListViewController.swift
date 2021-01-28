//
//  MVCRepositoryListViewController.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/1/27.
//

import UIKit
import SafariServices

class MVCRepositoryListViewController: UITableViewController {
    private let githubService = GithubService()

    fileprivate var currentLanguage = "Swift"
    fileprivate var repositories = [Repository]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        setupUI()
        reloadData()
        
        refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
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
    fileprivate func reloadData() {
        refreshControl?.beginRefreshing()
        navigationItem.title = currentLanguage

        githubService.getMostPopularRepositories(byLanguage: currentLanguage) { [weak self] result in
            self?.refreshControl?.endRefreshing()

            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                self?.tableView.reloadData()
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
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
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.className, for: indexPath) as! RepositoryCell
        let repo = repositories[indexPath.row]
        cell.selectionStyle = .none
        cell.setName(repo.fullName)
        cell.setDescription(repo.description)
        cell.setStarsCountTest("⭐️ \(repo.starsCount)")
        return cell
    }

    // MARK: - UITableViewDelegate {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = repositories[indexPath.row]
        let url = URL(string: repository.url)!
        let safariViewController = SFSafariViewController(url: url)
        navigationController?.pushViewController(safariViewController, animated: true)
    }
}

extension MVCRepositoryListViewController: LanguageListViewControllerDelegate {
    func languageListViewController(_ viewController: UIViewController, didSelectLanguage language: String) {
        currentLanguage = language
        reloadData()
        dismiss(animated: true)
    }

    func languageListViewControllerDidCancel(_ viewController: UIViewController) {
        dismiss(animated: true)
    }
}
