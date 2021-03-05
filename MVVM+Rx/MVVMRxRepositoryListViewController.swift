//
//  MVVMRxRepositoryListViewController.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/5.
//

import UIKit
import SafariServices
import RxSwift
import RxCocoa

class MVVMRxRepositoryListViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let chooseLanguageButton = UIBarButtonItem(barButtonSystemItem: .organize,
                                                       target: nil,
                                                       action: nil)
    private let refreshControl = UIRefreshControl()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    var viewModel = MVVMRxRepositoryListViewModel(initialLanguage: "Swift")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        setupBindings()
        
        refreshControl.sendActions(for: .valueChanged)
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = chooseLanguageButton
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.insertSubview(refreshControl, at: 0)
        tableView.register(UINib(nibName: RepositoryCell.className, bundle: nil), forCellReuseIdentifier: RepositoryCell.className)
    }
    
    private func setupBindings() {
        // View Controller UI actions to the View Model
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)

        chooseLanguageButton.rx.tap
            .bind(to: viewModel.chooseLanguage)
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(RepositoryViewModel.self)
            .bind(to: viewModel.selectRepository)
            .disposed(by: disposeBag)
        
        // View Model outputs to the View Controller
        viewModel.repositories
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() })
            .bind(to: tableView.rx.items(cellIdentifier: RepositoryCell.className, cellType: RepositoryCell.self)) { [weak self] (_, repo, cell) in
                self?.setupRepositoryCell(cell, repository: repo)
            }
            .disposed(by: disposeBag)

        viewModel.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.showRepository
            .subscribe(onNext: { [weak self] in self?.openRepository(by: $0) })
            .disposed(by: disposeBag)

        viewModel.showLanguageList
            .subscribe(onNext: { [weak self] in self?.openLanguageList() })
            .disposed(by: disposeBag)

        viewModel.alertMessage
            .subscribe(onNext: { [weak self] in self?.presentAlert(message: $0) })
            .disposed(by: disposeBag)
    }
    
    private func setupRepositoryCell(_ cell: RepositoryCell, repository: RepositoryViewModel) {
        cell.selectionStyle = .none
        cell.setName(repository.name)
        cell.setDescription(repository.description)
        cell.setStarsCountTest(repository.starsCountText)
    }
    
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    // MARK: - Navigation

    private func openRepository(by url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        navigationController?.pushViewController(safariViewController, animated: true)
    }
    
    private func openLanguageList() {
        let viewController = MVVMRxLanguageListViewController()
        let languageListViewModel = MVVMRxLanguageListViewModel()
        
        let dismiss = Observable.merge([
            languageListViewModel.didCancel,
            languageListViewModel.didSelectLanguage.map { _ in }
        ])
        
        dismiss
            .subscribe(onNext: { [weak self] in self?.dismiss(animated: true) })
            .disposed(by: viewController.disposeBag)
        
        languageListViewModel.didSelectLanguage
            .bind(to: viewModel.setCurrentLanguage)
            .disposed(by: viewController.disposeBag)
        
        viewController.viewModel = languageListViewModel
        present(viewController, animated: true)
    }
}
