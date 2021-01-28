//
//  MVPLanguageListViewController.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/1/28.
//

import UIKit

class MVPLanguageListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private lazy var presenter = LanguageListPresenter(view: self)
    
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
    }

    private func loadData() {
        presenter.loadData()
    }

    @objc
    private func cancel() {
        delegate?.languageListViewControllerDidCancel(self)
    }
}

extension MVPLanguageListViewController: LanguageListView {
    func reloadData() {
        tableView.reloadData()
    }
}

extension MVPLanguageListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.languages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        let language = presenter.languages[indexPath.row]
        cell.textLabel?.text = language
        cell.selectionStyle = .none
        return cell
    }
}

extension MVPLanguageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = presenter.languages[indexPath.row]
        delegate?.languageListViewController(self, didSelectLanguage: language)
    }
}
