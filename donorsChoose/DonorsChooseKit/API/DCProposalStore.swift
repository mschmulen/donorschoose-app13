//
//  DCProposalStore.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

public extension String {
    func stringByAddingUrlEncoding() -> String {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-._* ")
        return addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)?.replacingOccurrences(of: " ", with: "+") ?? self
    }
}

/// DonorsChoose Proposal Store
public final class DCProposalStore: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    private let rootURL: String = "https://api.donorschoose.org/common/json_feed.html"
    private let defaultSort: String = "0"
    
    // TODO convert to QueryItems
    private var url: URL {
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.donorschoose.org"
        components.path = "/common/json_feed.html"
        let maxQueryItem = URLQueryItem(name: "max", value: "\(ProjectSearchDataModel.max)")
        let apiKeyQueryItem = URLQueryItem(name: "APIKey", value: DCAPIKey)
        let partnerIdQueryItem = URLQueryItem(name: "partnerId", value: DCPartnerId)
        
        //let sortByQueryItem:URLQueryItem =  URLQueryItem(name: "sortBy", value: "\(searchModel.sortOption.requestValue())")
        
        switch requestConfig {
        case .sort( let searchSortOption):
            
            let sortByQueryItem:URLQueryItem =  URLQueryItem(name: "sortBy", value: "\(searchSortOption.rawValue)")
            
            components.queryItems = [
                maxQueryItem,
                sortByQueryItem,
                apiKeyQueryItem,
                partnerIdQueryItem
            ]
            
        case .nearestGeo(let latitude, let longitude):
            let centerLatQueryItem = URLQueryItem(name: "centerLat", value: "\(latitude)")
            let centerLngQueryItem = URLQueryItem(name: "centerLng", value: "\(longitude)")
            components.queryItems = [
                apiKeyQueryItem,
                centerLatQueryItem,
                centerLngQueryItem,
                partnerIdQueryItem
            ]
            
        case .keyword( let keyword):
            let keywordsQueryItem:URLQueryItem = URLQueryItem(name: "keywords", value: "\(keyword.stringByAddingUrlEncoding())")
            
            components.queryItems = [
                maxQueryItem,
                keywordsQueryItem,
                apiKeyQueryItem,
                partnerIdQueryItem
            ]
            
//        case .subject1 ( let searchSubject):
//            fatalError("No implimented")
//
//            components.queryItems = [
//                maxQueryItem,
//                apiKeyQueryItem,
//                partnerIdQueryItem
//            ]
            
        case .location( let locationInfo ):
            fatalError("No implimented")

            let stateQueryItem = URLQueryItem(name: "state", value: locationInfo.state)
            // let components.queryItems = [apiKeyQueryItem, stateQueryItem, partnerIdQueryItem ]
            
            //https://api.donorschoose.org/common/json_feed.html?state=NC&community=10007:3&APIKey=DONORSCHOOSE
            
            components.queryItems = [
                maxQueryItem,
                apiKeyQueryItem,
                stateQueryItem,
                partnerIdQueryItem
            ]
            
        }
        
        return components.url!
    }
    
    @Published public var requestConfig:ProjectSearchDataModel = .sort(searchSortOption: SearchSortOption.urgency) {
        didSet {
            refresh()
            updateChanges()
        }
    }
    
    @Published public var models: [ProposalModel] = [ProposalModel]() {
        willSet {
            updateChanges()
        }
    }

    public init() {
        
    }
    
    private func updateChanges() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

extension DCProposalStore {
    
    public func refresh() {
        self.fetchCustom(requestConfig: self.requestConfig)
    }
    
    private func fetchCustom(requestConfig:ProjectSearchDataModel) {
        
        //self.requestConfig = requestConfig
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                //fatalError("Error: \(error.localizedDescription)")
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                //fatalError("Error: invalid HTTP response code")
                print("Error: invalid HTTP response code")
                return
            }
            guard let data = data else {
                //fatalError("Error: missing response data")
                print("Error: missing response data")
                return
            }
            
            do {
                //let decoder = JSONDecoder()
                //let posts = try decoder.decode([Post].self, from: data)
                let projectModel = try JSONDecoder().decode(ProjectNetworkModel.self, from: data)
                //print( "projectModel \(projectModel)")
                //print( "\(projectModel.proposals.count)")
                DispatchQueue.main.async {
                    self.models = projectModel.proposals
                }
            }
            catch {
                print("Error: \(error.localizedDescription)")
                //                    print("error in JSONSerialization \(error)")
                //                    //scallback([ProposalModel](), APIError.networkSerialize)
            }
        }
        task.resume()
        
    }
}

extension DCProposalStore {
    func go() {
            
    //        fetch()
    //        .sink(receiveCompletion: { completion in
    //            switch completion {
    //            case .finished:
    //                break
    //            case .failure(let error):
    //                print(error.localizedDescription)
    //            }
    //        }, receiveValue: { data in
    //            guard let response = String(data: data, encoding: .utf8) else { return }
    //            print(response)
    //        })
            
            let sub = fetch()//url: url)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("*** FINISHED:")
                    break
                case .failure(let error):
                    print("*** ERRROR: \(error.localizedDescription)")
                }
            }, receiveValue: { data in
                guard let response = String(data: data, encoding: .utf8) else { return }
                print("*** RESPONSE: \(response)")
            })
            
            
        }
        
        func fetch() -> AnyPublisher<Data, APIError> {
            
            
            
           let request = URLRequest(url: url)

            return URLSession.DataTaskPublisher(request: request, session: .shared)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                        throw APIError.unknown
                    }
                    return data
                }
                .mapError { error in
                    if let error = error as? APIError {
                        return error
                    } else {
                        return APIError.apiError(reason: error.localizedDescription)
                    }
                }
                .eraseToAnyPublisher()
        }
        
    
}


