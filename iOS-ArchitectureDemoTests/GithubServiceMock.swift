//
//  GithubServiceMock.swift
//  iOS-ArchitectureDemoTests
//
//  Created by Lingye Han on 2021/3/9.
//

@testable import iOS_ArchitectureDemo
import RxSwift

class RxGithubServiceMock: RxGithubService {

    var languageListReturnValue: Observable<[String]> = .empty()
    override func getLanguageList() -> Observable<[String]> {
        return languageListReturnValue
    }

    var repositoriesLanguageArgument: String!
    var repositoriesReturnValue: Observable<[Repository]> = .empty()
    override func getMostPopularRepositories(byLanguage language: String) -> Observable<[Repository]> {
        repositoriesLanguageArgument = language
        return repositoriesReturnValue
    }
}

class GithubServiceMock: GithubService {

    var repositoriesReturnValue: (Result<[Repository], Error>) = .success([])
    override func getMostPopularRepositories(byLanguage language: String, completion: @escaping (Result<[Repository], Error>) -> Void) {

        return completion(repositoriesReturnValue)
    }
}
