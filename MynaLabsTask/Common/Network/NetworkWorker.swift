//
//  NetworkWorker.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import Alamofire

class NetworkWorker {

    private let urlSession: URLSession

    required init(session: URLSession = URLSession.shared) {
        urlSession = session
    }

    func sendRequest<Success: Decodable>(urlRequest: URLRequest, successModel: Success.Type, completion: @escaping (Result<Success>) -> Void) {
        
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        
        manager.request(urlRequest).validate().responseJSON { responseData in
            DispatchQueue.main.async {
                switch responseData.result {
                case .success(let successData):
                    guard let data = try? JSONSerialization.data(withJSONObject: successData, options: .prettyPrinted) else {
                        if let model = self.transformFromJSON(data: responseData.data, objectType: Failure.self) {
                            completion(.badRequest(model))
                        }
                        break
                    }
                    
                    if let json = successData as? [String: Any], let _ = json["data"] {
                        if let object = try? JSONDecoder().decode(successModel, from: data) {
                            completion(.success(object))
                        } else {
                            completion(.failure("Success -> Fail object parsing"))
                        }
                    } else {
                        completion(.failure("Failure -> Fail object parsing"))
                    }
                case .failure(let error):
                    completion(.failure(error.localizedDescription))
                }
            }
        }
    }
        
    private func validateErrors(response: URLResponse?, error: Error?) -> Error? {
        if let error = error {
            return error
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return URLError(.badServerResponse)
        }
        
        switch statusCode {
        case StatusCode.okey.rawValue:
            return nil
        case StatusCode.badRequest.rawValue:
            return NetworkErrors.badRequest
        default:
            break
        }
        
        return nil
    }

    private func transformFromJSON<Model: Codable>(data: Data?, objectType: Model.Type) -> Model? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(Model.self, from: data)
    }
}
