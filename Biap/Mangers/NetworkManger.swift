//
//  NetworkManger.swift
//  Biap
//
//  Created by Ahmed Shawky on 01/03/2023.
//

import Foundation
import Alamofire

class NetworkManger{
    static let AFSession = Alamofire.Session()

    static func createNewCustomer(customer: Customer,Complition:@escaping(Result<Data, Error>) ->()){
        
        let url = URLS.baseURL + URLS.customer.newCustomer.rawValue
        let parameters:[String: Any] = ["customer": ["first_name": customer.firstName,
                                                     "last_name" : customer.lastName,
                                                     "email": customer.email,
                                                     "phone": customer.phone,
                                                     "password": customer.password,
                                                     "password_confirmation": customer.password]]
        


//        AFSession.request(url, method: .post,
//                   parameters: parameters,
//                   encoding: JSONEncoding.default).response{ responseData in
//
//            debugPrint(responseData)
//
//            switch responseData.result {
//            case .success(let JSON):
//                let jsonData = try! JSONSerialization.data(withJSONObject: JSON, options: [])
//
//                print(JSON)
//                do{
//                    let customer = try JSONDecoder().decode(CustomerResponse.self, from: jsonData)
//                    Complition(.success(customer))
//                }catch let error {
//                    Complition(.failure(error))
//                }
//            case .failure(let error):
//                Complition(.failure(error))
//            }
//        }
        
    }
}
