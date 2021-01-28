//
//  GithubService.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/1/27.
//

import Foundation

enum ServiceError: Error {
    case cannotParse
}

/// A service that knows how to perform requests for GitHub data.
class GithubService {

    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func getLanguageList(completion: ([String]) -> Void) {
        let stubbedListOfPopularLanguages = [
            "Swift",
            "Objective-C",
            "Java",
            "C",
            "C++",
            "Python",
            "C#"
        ]

        completion(stubbedListOfPopularLanguages)
    }

    func getMostPopularRepositories(byLanguage language: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        let encodedLanguage = language.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://api.github.com/search/repositories?q=language:\(encodedLanguage)&sort=stars")!

        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard
                    let data = data,
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                    let jsonDict = jsonObject as? [String: Any],
                    let itemsJSON = jsonDict["items"] as? [[String: Any]]
                else {
                    completion(.failure(ServiceError.cannotParse))
                    return
                }

                let repositories = itemsJSON.compactMap(Repository.init)
                completion(.success(repositories))
            }
        }.resume()
    }
}
