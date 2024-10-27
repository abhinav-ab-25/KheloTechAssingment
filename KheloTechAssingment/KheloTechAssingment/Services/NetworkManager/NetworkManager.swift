//
//  NetworkManager.swift
//  KheloIndiaAssingment
//
//  Created by Abhinav on 26/10/24.
//

import Foundation

class NetworkHandler {
    
    enum HTTPMethod:String {
        case GET
        case POST
    }
    
    enum NetworkError:Error{
        case someError
        case invalidData
        case invalidResponse
        case InternetError
    }
    
    func APIRequest<T:Decodable>(requestURL:URL,requestBody:Data? = nil,resultType:T.Type,httpMethod:HTTPMethod,completion:@escaping(Result<T,Error>)->()){
        
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue
        
        if httpMethod == .POST {
            request.httpBody = requestBody
        }
       
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse , (200...209).contains(httpResponse.statusCode) else{
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let jsonData = data else {
                if let error = error {
                    completion(.failure(error))
                }
                else {
                    completion(.failure(NetworkError.invalidData))
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: jsonData)
                completion(.success(result))
            }
            catch {
                completion(.failure(NetworkError.invalidData))
            }
        }.resume()
    }
}
