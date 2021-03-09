//
//  iOS_ArchitectureDemoTests.swift
//  iOS-ArchitectureDemoTests
//
//  Created by Lingye Han on 2021/3/9.
//

import XCTest
@testable import iOS_ArchitectureDemo

class iOS_ArchitectureDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    var testExpectation: XCTestExpectation?
    func testVIPER() {
        
        //set async expectation
        testExpectation = expectation(description: "Testing Async GetData process")
        
        //setup presenter and interactor
        let presenter = RepoListPresenter()
        let interactor = RepoListInteractor()
        
        presenter.interactor = interactor
        presenter.view = self
        interactor.presenter = presenter
        
        //call for data
        presenter.updateView(byLanguage: "Swift")
        
        //time to let the process finish before it fails
        waitForExpectations(timeout: 2, handler: { (error) in
            
        })
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension iOS_ArchitectureDemoTests: RepoListInputInterface {

    func reloadData() {
        //We can check for data here e.g. count > 0 etc
        XCTAssertTrue(true, "We have the data")
    }
    func loadingIndicator(show: Bool) { }
    func showAlert(message: String) { }
}
