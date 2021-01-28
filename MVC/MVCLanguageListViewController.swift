//
//  MVCLanguageListViewController.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/1/27.
//

import UIKit

protocol LanguageListViewControllerDelegate: class {
    func languageListViewController(_ viewController: UIViewController, didSelectLanguage language: String)
    func languageListViewControllerDidCancel(_ viewController: UIViewController)
}

class MVCLanguageListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private let githubService = GithubService()
    fileprivate var languages = [String]()
    
    weak var delegate: LanguageListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadData()
    }

    private func setupUI() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Choose a language"

        tableView.rowHeight = 48.0
    }

    private func loadData() {
        githubService.getLanguageList { [weak self] languages in
            self?.languages = languages
            self?.tableView.reloadData()
        }
    }

    @objc
    private func cancel() {
        delegate?.languageListViewControllerDidCancel(self)
    }
}

extension MVCLanguageListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
        let language = languages[indexPath.row]
        cell.textLabel?.text = language
        cell.selectionStyle = .none
        return cell
    }
}

extension MVCLanguageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = languages[indexPath.row]
        delegate?.languageListViewController(self, didSelectLanguage: language)
    }
}

