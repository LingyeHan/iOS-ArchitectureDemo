//
//  MVVMRxLanguageListViewController.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/5.
//

import UIKit
import RxSwift
import RxCocoa

/// Shows a list languages.
class MVVMRxLanguageListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    var viewModel: MVVMRxLanguageListViewModel!

    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }

    private func setupUI() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Choose a language"

        tableView.rowHeight = 48.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LanguageCell")
    }

    private func setupBindings() {
        viewModel.languages
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "LanguageCell", cellType: UITableViewCell.self)) { (_, language, cell) in
                cell.textLabel?.text = language
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(String.self)
            .bind(to: viewModel.selectLanguage)
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .bind(to: viewModel.cancel)
            .disposed(by: disposeBag)
    }
}
