//
//  NetworkManager.swift
//  Music-Project
//
//  Created by Ata Doruk on 13.01.2021.
//

import UIKit

fileprivate enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum APIRequest {
    case search(artist: String, limit: Int)
    case albums(artistId: Int, limit: Int)
    
    private var parameters: [URLQueryItem]? {
        switch self {
        case .search(artist: let artist, limit: let limit):
            return [
                URLQueryItem(name: "term", value: artist),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "entity", value: "allArtist"),
                URLQueryItem(name: "attribute", value: "allArtistTerm")
            ]
        case .albums(artistId: let artistId, limit: let limit):
            return [
                URLQueryItem(name: "id", value: "\(artistId)"),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "entity", value: "album"),
//                URLQueryItem(name: "attribute", value: "albumTerm")
            ]
        default:
            return nil
        }
    }
    
    private var path: String {
        switch self {
        case .search: return "/search"
        case .albums: return "/lookup"
        default: return ""
        }
    }
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = self.path
        urlComponents.queryItems = self.parameters
        
        return urlComponents.url
    }
    
    fileprivate var httpMethod: HTTPMethod {
        .get
    }
}

enum RequestError: Error {
    case cantConstructUrl
    case unacceptableStatusCode(Int)
    case dataNil
    case decodingError
    case generic(Error)
}

class NetworkManager {
    private let session = URLSession.shared
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(_ requestType: APIRequest, decodingTo: T.Type, completion: @escaping (Result<T, RequestError>) -> Void) {
        guard let url = requestType.url else { completion(.failure(.cantConstructUrl)); return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = requestType.httpMethod.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Get a reference in case we want to cancel ongoing requests later
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else { completion(.failure(.generic(error!))); return }
            
            let httpResponse = response as! HTTPURLResponse
            
            guard httpResponse.statusCode == 200 else { completion(.failure(.unacceptableStatusCode(httpResponse.statusCode))); return }
            
            guard let data = data else { completion(.failure(.dataNil)); return }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let object = try decoder.decode(BaseResponse<T>.self, from: data)
                
                completion(.success(object.results))
            } catch let error {
                print("Error: \(error)")
                if error is DecodingError {
                    completion(.failure(.decodingError))
                } else {
                    completion(.failure(.generic(error)))
                }
            }
        }
        
        task.resume()
    }
}
