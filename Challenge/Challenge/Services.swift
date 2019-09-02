//
//  Services.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 31/08/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import Foundation
import CoreLocation

class Services {
    
    private static let defaultSession = URLSession(configuration: .default)
    private static var dataTask: URLSessionDataTask?
    static let appId = "2mRxp71DipuiYgTukkOG"
    static let appCode = "UhsZzEig1AqGTSRFp-XT0w"
    
    static func suggestions(query: String,
                            prox: CLLocationCoordinate2D?,
                            completion: @escaping (Suggestions?, Error?) -> Void) {

        var parameters = ["query": query, "maxresults": "20"]
        
        if let prox = prox {
            parameters["prox"] = "\(prox.latitude),\(prox.longitude)"
        }
        makeCall(url: "http://autocomplete.geocoder.api.here.com/6.2/suggest.json", parameters: &parameters, completion: completion)
    }
    
    static func details(locationId: String,
                        prox: CLLocationCoordinate2D?,
                        completion: @escaping (Result?, Error?) -> Void) {
        
        var parameters = ["locationid": locationId, "jsonattributes": "1", "gen": "9"]
        
        if let prox = prox {
            parameters["prox"] = "\(prox.latitude),\(prox.longitude)"
        }
        makeCall(url: "http://geocoder.api.here.com/6.2/geocode.json", parameters: &parameters) { (location: Location?, error) in
            
            if let location = location {
                completion(location.response.view[0].result[0], error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    private static func makeCall<T: Decodable>(url: String,
                                             parameters: inout [String: String],
                                             completion: @escaping (T?, Error?) -> Void) {
        
        parameters["app_id"] = appId
        parameters["app_code"] = appCode
        
        if let language = Locale.current.languageCode {
            parameters["language"] = language
        }
        
        
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (arg) -> URLQueryItem in
            
            return URLQueryItem(name: arg.key, value: arg.value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            defer { self.dataTask = nil }

            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } else if let data = data, let response = response as? HTTPURLResponse {
                
                if response.statusCode == 200 {
                    do {
                        let result = try  JSONDecoder().decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(result, nil)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                } else {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                        let description = dict?["error_description"] as? String
                        let error = dict?["error"] as? String
                        DispatchQueue.main.async {
                            completion(nil, HEREError(error: error, description: description))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
            }
        }
        dataTask?.resume()
    }
}

struct HEREError: Error {
    
    let error: String?
    let description: String?
}
