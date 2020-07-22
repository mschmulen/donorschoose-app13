//
//  DCProposalStore.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

/// DonorsChoose Proposal Store
public final class DCProposalStore: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    private let apiKey: String  = "DONORSCHOOSE"
    private let partnerId: String  = "20785042"
    
    private let rootURL: String = "https://api.donorschoose.org/common/json_feed.html"
    private let defaultSort: String = "0"
    
    // TODO convert to QueryItems
    private var url: URL {
        switch requestConfig {
        case .sort( let searchSortOption):
            return URL(string:"\(rootURL)?max=\(ProjectSearchDataModel.max)&sortBy=\(searchSortOption.rawValue)&APIKey=\(apiKey)&partnerId=\(partnerId)")!
            
        case .nearestGeo(let latitude, let longitude):
            return URL(string:"\(rootURL)?max=\(ProjectSearchDataModel.max)&sortBy=\(defaultSort)&APIKey=\(apiKey)&partnerId=\(partnerId)&centerLat=\(latitude)&centerLng=\(longitude)")!
            
            //            if let latitude = searchModel.latitude, let longitude = searchModel.longitude {
            //                let centerLatQueryItem = URLQueryItem(name: "centerLat", value: "\(latitude)")
            //                let centerLngQueryItem = URLQueryItem(name: "centerLng", value: "\(longitude)")
            //                // MAS TODO support other parameters
            //                components.queryItems = [apiKeyQueryItem, centerLatQueryItem,centerLngQueryItem, partnerIdQueryItem ] // sortByQueryItem, maxQueryItem ,]
            //            } else {
            //                components.queryItems = [maxQueryItem, sortByQueryItem, apiKeyQueryItem, partnerIdQueryItem]
            //            }
            
        case .keyword( let keyword):
            return URL(string:"\(rootURL)?max=\(ProjectSearchDataModel.max)&sortBy=\(defaultSort)&keywords=\(keyword)&APIKey=\(apiKey)&partnerId=\(partnerId)")!
            
            //            if let keywords = searchModel.keywords {
            //                let keywordsQueryItem:URLQueryItem = URLQueryItem(name: "keywords", value: "\(keywords.stringByAddingUrlEncoding())")
            //                components.queryItems = [maxQueryItem, keywordsQueryItem, sortByQueryItem, apiKeyQueryItem, partnerIdQueryItem]
            //            } else {
            //                components.queryItems = [maxQueryItem, sortByQueryItem, apiKeyQueryItem, partnerIdQueryItem]
            //            }
            
        case .subject1 ( let searchSubject):
            return URL(string:"\(rootURL)?max=\(ProjectSearchDataModel.max)&sortBy=\(defaultSort)&APIKey=\(apiKey)&partnerId=\(partnerId)")!
            
        case .location( let locationInfo ):
            return URL(string:"\(rootURL)?max=\(ProjectSearchDataModel.max)&sortBy=\(defaultSort)&APIKey=\(apiKey)&partnerId=\(partnerId)")!
            
            //            if let locationInfo = searchModel.locationInfo {
            //                let stateQueryItem = URLQueryItem(name: "state", value: locationInfo.state)
            //
            //                // MAS TODO
            //                // let communityQueryItem = URLQueryItem(name: "community", value: "10007")
            //                // https://api.donorschoose.org/common/json_feed.html?state=NC&community=10007:3&APIKey=DONORSCHOOSE
            //                components.queryItems = [apiKeyQueryItem, stateQueryItem, partnerIdQueryItem ]
            //            }
        }
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


