//
//  DetailVIPER.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/3/8.
//

import Foundation

import UIKit

// MARK: - DetailInterface declaration
protocol DetailInputInterface: class {
    
    func setupController(model: Repository?)
}

// MARK: - DetailViewController

class DetailViewController: UIViewController {
    
    // Reference to the Presenter's interface.
    var presenter: DetailPresenterInputInterface!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    class var controllerIdentifier: String {
        return String(describing: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.updateView()
    }
}

// MARK: - DetailInterface

extension DetailViewController: DetailInputInterface {

    func setupController(model: Repository?) {
        
        navigationItem.title = model?.fullName
        detailLabel.text = model?.description
    }
}

// MARK: - DetailInteractorInputInterface declaration

protocol DetailInteractorInputInterface: class { }

// MARK: - DetailInteractorInputInterface declaration

protocol DetailInteractorOutputInterface: class { }

// MARK: - DetailInteractor declaration

class DetailInteractor {
    
    // Reference to the Presenter by Interactor interface
    weak var presenter: DetailInteractorOutputInterface?
}

// MARK: - DetailInteractorInputInterface

extension DetailInteractor: DetailInteractorInputInterface {

}




// MARK: - DetailPresenterInputInterface declaration

protocol DetailPresenterInputInterface {
    
    func updateView()
}

// MARK: - DetailPresenter declaration

class DetailPresenter {
    
    // Reference to the View
    weak var view: DetailInputInterface?
    
    // Reference to the Interactor's interface.
    var interactor: DetailInteractorInputInterface?
    
    // Reference to the Router
    var router: DetailRouter?
    
    var model: Repository?
}

// MARK: - DetailPresenterInputInterface

extension DetailPresenter: DetailPresenterInputInterface {
    
    func updateView() {

        view?.setupController(model: model)
    }
}

// MARK: - DetailInteractorOutputInterface

extension DetailPresenter: DetailInteractorOutputInterface {
    
}


class DetailRouter {
    weak var viewController: UIViewController?
    
    static func assembleModule(model: Repository) -> UIViewController? {
        let view = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DetailViewController.controllerIdentifier)) as? DetailViewController
        let presenter = DetailPresenter()
        let interactor = DetailInteractor()
        let router = DetailRouter()

        view?.presenter = presenter
        presenter.view = view
        presenter.model = model
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        return router.viewController
    }
}
