//
//  RepoListViewController.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/5.
//

import Foundation
import UIKit

/**
 提供完整的视图，负责视图的组合、布局、更新
 向Presenter提供更新视图的接口
 将View相关的事件发送给Presenter
 View:
    Present Data
    Delegate User Interactions
 */

// MARK: - RepoListInputInterface declaration

protocol RepoListInputInterface: class {
    
    func reloadData()
    func loadingIndicator(show: Bool)
    func showAlert(message: String)
}

// MARK: - RepoListViewController

class RepoListViewController: UITableViewController {

    // Reference to the Presenter's interface.
    var presenter: RepoListPresenterInputInterface!

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
        presenter.updateView(byLanguage: presenter.getCurrentLanguage())
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
        return presenter.getDataSource().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.className, for: indexPath) as! RepositoryCell
        let repo = presenter.getDataSource()[indexPath.row]
        cell.selectionStyle = .none
        cell.setName(repo.fullName)
        cell.setDescription(repo.description)
        cell.setStarsCountTest("⭐️ \(repo.starsCount)")
        return cell
    }

    // MARK: - UITableViewDelegate {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = presenter.getDataSource()[indexPath.row]
        presenter.didSelectRepo(repository)
    }
}

// MARK: - RepoListInputInterface

extension RepoListViewController: RepoListInputInterface {
 
    func reloadData() {
        tableView.reloadData()
    }
    
    func loadingIndicator(show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.refreshControl?.beginRefreshing()
                self.navigationItem.title = self.presenter.getCurrentLanguage()
            } else {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func showAlert(message: String) {
        presentAlert(message: message)
    }
}


extension RepoListViewController: LanguageListViewControllerDelegate {
    func languageListViewController(_ viewController: UIViewController, didSelectLanguage language: String) {
        presenter.updateView(byLanguage: language)
        dismiss(animated: true)
    }

    func languageListViewControllerDidCancel(_ viewController: UIViewController) {
        dismiss(animated: true)
    }
}

