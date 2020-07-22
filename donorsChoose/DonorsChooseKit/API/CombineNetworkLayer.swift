//
//  CombineNetworkLayer.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import Combine

struct Agent {
    let session = URLSession.shared
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum DonorsChooseAPI {
    static let agent = Agent()
    //static let base = URL(string: "https://api.github.com")!
    static let base = URL(string: "http://api.donorschoose.org")!
    
//    var components = URLComponents()
//    components.scheme = "http"
//    components.host = "api.donorschoose.org"
//    components.path = "/common/json_feed.html"
        
    
}

extension DonorsChooseAPI {
    
    static func urgent(username: String) -> AnyPublisher<[ProposalModel], Error> {
        return run(URLRequest(url: base.appendingPathComponent("common/json_feed.html?max=20&sortBy=0&APIKey=DONORSCHOOSE&partnerId=20785042")))
    }
    
    //
    // http://api.donorschoose.org/common/json_feed.html?max=20&sortBy=0&APIKey=DONORSCHOOSE&partnerId=20785042
    
    
    
    // http://api.donorschoose.org/common/json_feed.html?APIKey=DONORSCHOOSE&centerLat=9.759211&centerLng=-33.984638&partnerId=20785042

    
        
//    static func repos(username: String) -> AnyPublisher<[Repository], Error> {
//        return run(URLRequest(url: base.appendingPathComponent("users/\(username)/repos")))
//    }
    
//    static func issues(repo: String, owner: String) -> AnyPublisher<[Issue], Error> {
//        return run(URLRequest(url: base.appendingPathComponent("repos/\(owner)/\(repo)/issues")))
//    }
//
//    static func repos(org: String) -> AnyPublisher<[Repository], Error> {
//        return run(URLRequest(url: base.appendingPathComponent("orgs/\(org)/repos")))
//    }
//
//    static func members(org: String) -> AnyPublisher<[User], Error> {
//        return run(URLRequest(url: base.appendingPathComponent("orgs/\(org)/members")))
//    }
    
    static func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}




// MARK: - Usage
// MARK: - Chain

//func chain() {
//    let me = "V8tr"
//    let repos = GithubAPI.repos(username: me)
//    let firstRepo = repos.compactMap { $0.first }
//    let issues = firstRepo.flatMap { repo in
//        GithubAPI.issues(repo: repo.name, owner: me)
//    }
//
//    let token = issues.sink(receiveCompletion: { _ in },
//                            receiveValue: { print($0) })
//
//    RunLoop.main.run(until: Date(timeIntervalSinceNow: 10))
//
//    withExtendedLifetime(token, {})
//}
//
//
//// MARK: - Parallel
//
//func parallel() {
//    let members = GithubAPI.members(org: "apple")
//    let repos = GithubAPI.repos(org: "apple")
//    let token = Publishers.Zip(members, repos)
//        .sink(receiveCompletion: { _ in },
//              receiveValue: { (members, repos) in print(members, repos) })
//
//    RunLoop.main.run(until: Date(timeIntervalSinceNow: 10))
//
//    withExtendedLifetime(token, {})
//}
