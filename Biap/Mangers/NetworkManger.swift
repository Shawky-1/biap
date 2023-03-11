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
    
    static func CreateCustomer(customer: Customer, completion: @escaping (Result<Customer, Error>) -> ()) {
        
        let url = URLS.baseURL + URLS.customer.newCustomer.rawValue
        let headers: HTTPHeaders = [Tokens.headerToken: Tokens.secretToken,
                                    "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = ["customer": ["first_name": customer.firstName!,
                                                      "last_name" : customer.lastName!,
                                                      "email": customer.email,
                                                      "note": customer.note!,
                                                      "phone": customer.phone!]]
        dump(url)
        dump(headers)
        dump(parameters)
        
        AF.request(url, method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers).validate(statusCode: 0 ..< 600).response { response in
            if response.response?.statusCode == 422{
                dump(response.result)
                print(response.result)
            }
            switch response.result {
            case .success(let data):
                do {
                    let customerResponse = try JSONDecoder().decode(CustomerResponse.self, from: data!)
                    completion(.success(customerResponse.customer))
                } catch let error {
                    if let apiError = error as? APIError {
                        completion(.failure(apiError))
                    } else {
                        completion(.failure(AppErrors.emailOrPasswordTaken))
                    }
                }
            case .failure(let error):
                print(error)
                if let statusCode = response.response?.statusCode, statusCode == 422 {
                    if let data = error.localizedDescription.data(using: .utf8) {
                        do {
                            let apiError = try JSONDecoder().decode(APIError.self, from: data)
                            completion(.failure(apiError))
                        } catch let decodingError {
                            completion(.failure(decodingError))
                        }
                    } else {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error))
                }
            }
        }
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
    
    static func fetchOrders(url:String,complition:@escaping (Result<orders, Error>)->Void){
        let url = URL(string:url)
        
        
        
        AF.request(url!).validate().response { responseData in
            
            switch responseData.result{
            case .success(let data):
                do{
                    let orders = try JSONDecoder().decode(orders.self, from: data!)
                    complition(.success(orders))
                    //print(Leagues)
                }catch{
                    complition(.failure(error))
                }
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    static func fetchAddresses(url:String,complition:@escaping (Result<ListOfAddresses, Error>)->Void){
        let url = URL(string: url)
        AF.request(url!).validate().response { responseData in
            
            switch responseData.result{
            case .success(let data):
                do{
                    let addr = try JSONDecoder().decode(ListOfAddresses.self, from: data!)
                    complition(.success(addr))
                    print(addr)
                }catch{
                    complition(.failure(error))
                }
            case .failure(let error):
                complition(.failure(error))
            }
        }
        
        
    }
    
    static func CreateAddress(address: Address, completion: @escaping (Result<Address, Error>) -> ()) {
        
        let url = URLS.baseURL +  "/customers/\(address.customerId)/addresses.json"
        let headers: HTTPHeaders = [Tokens.headerToken: Tokens.secretToken,
                                    "Content-Type": "application/json"]
        let parameters: [String: Any] = ["address": ["customer_id": address.customerId,
                                                     "address1": address.address1!,
                                                     "city": address.city!,
                                                     "country": address.country!]]
        dump(parameters)
        AF.request(url, method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers).validate(statusCode: 200 ..< 550).response { response in
            
            
            switch response.result {
            case .success(let data):
                do {
                    let addResp = try JSONDecoder().decode(AddressResponse.self, from: data!)
                    completion(.success(addResp.customer_address))
                } catch let error {
                    print(error.localizedDescription)
                    print(error)
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
                
            }
        }
    }
    
    static func createOrder(lineItems: [LineItem], completion: @escaping (Result<OrderResponse, Error>) -> ()) {
        let url = URLS.baseURL + "/orders.json"
        let headers: HTTPHeaders = [Tokens.headerToken: Tokens.secretToken,
                                    "Content-Type": "application/json"]
        let userID = UserDefaults.standard.integer(forKey: "id")
        
        let lineItemDicts = lineItems.map { item in
            ["variant_id": item.variantID, "quantity": item.quantity]
        }
        
        let parameters: [String: Any] = [
            "order": [
                "line_items": lineItemDicts,
                "customer": [
                    "id": userID
                ]
            ]
        ]
        print(userID)
        print(parameters)
        print(url)
        
        AF.request(url, method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers).validate(statusCode: 200 ..< 501).response { response in
            switch response.result {
            case .success(let data):
                if let order = try? JSONDecoder().decode(OrderResponse.self, from: data!) {
                    completion(.success(order))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode Order"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }

        }
    }
}


enum AppErrors: Error {
    
    case serverError(Error)
    case noCustomers
    case invalidResponse
    case emailOrPasswordTaken
    
    var errorMessage: String {
        switch self {
        case .serverError(let error):
            return error.localizedDescription
        case .noCustomers:
            return "Invalid email"
        case .invalidResponse:
            return "Invalid response"
        case .emailOrPasswordTaken:
            return "Email or password is already taken!"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .emailOrPasswordTaken:
            return NSLocalizedString("Email or password is taken", comment: "Error message displayed when the email or password is taken")
        case .noCustomers:
            return "Invalid password"
        case .serverError:
            return "Unable to connect to the server. Please check your internet connection and try again."
        case .invalidResponse:
            return "An unknown error occurred. Please try again later."
        }
    }
}





