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

    static func RegisterCustomer(customer: Customer,Complition:@escaping(Result<Customer, Error>) ->()){

        let url = URLS.baseURL + URLS.customer.newCustomer.rawValue
        let headers:HTTPHeaders = [Tokens.headerToken : Tokens.secretToken]
        let parameters:[String: Any] = ["customer": ["first_name": customer.firstName,
                                                     "last_name" : customer.lastName,
                                                     "email": customer.email,
                                                     "phone": customer.phone,]]
        

    }
    
    static func searchCustomer(email: String, complition: @escaping(Result<Customer, Error>) -> ()){
        let url = URLS.baseURL + URLS.customer.searchCustomer.rawValue
        let query:String = "email:\(email)"
        let parameters:[String: Any] = ["query": query]
        let headers:HTTPHeaders = [Tokens.headerToken : Tokens.secretToken]
        
        AF.request(url, parameters: parameters, headers: headers).validate().response { responseData in
            switch responseData.result {
            case .success(let data):
                do {
                    let customerRawResponse = try JSONDecoder().decode(CustomersResponse.self, from: data!)
                    if !customerRawResponse.customers.isEmpty{
                        complition(.success(customerRawResponse.customers.first!))
                    } else {
                        complition(.failure(AppErrors.noCustomers))
                    }
                } catch let error {
                    complition(.failure(error))
                }
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }

    
    
    
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
    
    
    static func fetchProducts(url:String,complition:@escaping (Result<products, Error>)->Void){
        let url = URL(string: url)
        AF.request(url!).validate().response { responseData in
            
            switch responseData.result{
            case .success(let data):
                do{
                    let product = try JSONDecoder().decode(products.self, from: data!)
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
    
    
    static func fetchSingleProduct(url:String,complition:@escaping (Result<singleProduct, Error>)->Void){
        let url = URL(string: url)
        AF.request(url!).validate().response { responseData in
            
            switch responseData.result{
            case .success(let data):
                do{
                    let product = try JSONDecoder().decode(singleProduct.self, from: data!)
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

enum AppErrors: Error {

    case serverError(Error)
    case noCustomers
    case invalidResponse
    
    var errorMessage: String {
        switch self {
        case .serverError(let error):
            return error.localizedDescription
        case .noCustomers:
            return "Invalid email"
        case .invalidResponse:
            return "Invalid response"
        }
    }
}





