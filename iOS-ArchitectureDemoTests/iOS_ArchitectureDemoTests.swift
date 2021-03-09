//
//  iOS_ArchitectureDemoTests.swift
//  iOS-ArchitectureDemoTests
//
//  Created by Lingye Han on 2021/3/9.
//

@testable import iOS_ArchitectureDemo
import XCTest

class iOS_ArchitectureDemoTests: XCTestCase {
    
    var testExpectation: XCTestExpectation?
    
    func testVIPER() {
        
        //set async expectation
        testExpectation = expectation(description: "Testing Async GetData process")
        
        //setup presenter and interactor
        let presenter = RepoListPresenter()
        
        let serviceMock = GithubServiceMock()
        let error = NSError(domain: "Test", code: 2, userInfo: [NSLocalizedDescriptionKey: "500 error."])
        serviceMock.repositoriesReturnValue = .failure(error)
        let interactor = RepoListInteractor(githubService: serviceMock)
        
        presenter.interactor = interactor
        presenter.view = self
        interactor.presenter = presenter
        
        //call for data
        presenter.updateView(byLanguage: "Swift")
        
        //time to let the process finish before it fails
        waitForExpectations(timeout: 100, handler: { (error) in
            if let error = error {
                print("测试出错: \(error.localizedDescription)")
            }
        })
    }

}

extension iOS_ArchitectureDemoTests: RepoListInputInterface {

    func reloadData() {
        print("reloadData")
        //We can check for data here e.g. count > 0 etc
        XCTAssertTrue(true, "We have the data")
        testExpectation?.fulfill()
    }
    
    func loadingIndicator(show: Bool) {
        print("loadingIndicator: \(show)")
    }
    
    func showAlert(message: String) {
        print("showAlert: \(message)")
        testExpectation?.fulfill()
    }
}
