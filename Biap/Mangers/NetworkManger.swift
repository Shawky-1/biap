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

//    static func createNewCustomer(customer: Customer,Complition:@escaping(Result<Customer, Error>) ->()){
//
//        let url = URLS.baseURL + URLS.customer.newCustomer.rawValue
//        let parameters:[String: Any] = ["customer": ["first_name": customer.firstName,
//                                                     "last_name" : customer.lastName,
//                                                     "email": customer.email,
//                                                     "phone": customer.phone,
//                                                     "password": customer.password,
//                                                     "password_confirmation": customer.password]]
//
//
//
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
//
//    }
    
    
    static func fetchBrand(complition:@escaping (Result<brands, Error>)->Void){
        let url = URL(string: "https://80300e359dad594ca2466b7c53e94435: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@mad-ism202.myshopify.com/admin/api/2023-01/smart_collections.json")
        AF.request(url!).validate().response { responseData in
            
            switch responseData.result{
            case .success(let data):
                do{
                    let brands = try JSONDecoder().decode(brands.self, from: data!)
                    complition(.success(brands))
                    //print(Leagues)
                }catch{
                    complition(.failure(error))
                }
            case .failure(let error):
                complition(.failure(error))
            }
        }
        
        
    }
    
    
    static func fetchSPRODUCT(url:String,vendor:String,complition:@escaping (Result<product, Error>)->Void){
        let url = URL(string: url)
        AF.request(url!).validate().response { responseData in
            
            switch responseData.result{
            case .success(let data):
                do{
                    let product = try JSONDecoder().decode(product.self, from: data!)
                    complition(.success(product))
                    //print(Leagues)
                }catch{
                    complition(.failure(error))
                }
            case .failure(let error):
                complition(.failure(error))
            }
        }
        
        
    }
}
