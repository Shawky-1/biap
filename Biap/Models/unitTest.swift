//
//  unitTest.swift
//  Biap
//
//  Created by Abdelrahman on 13/03/2023.
//


import Alamofire
import Foundation


struct ProductA : Codable {
    let products : [ProductB]?

    enum CodingKeys: String, CodingKey {

        case products = "products"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decodeIfPresent([ProductB].self, forKey: .products)
    }

}

struct ProductB : Codable {
    let id : Int?
    let title : String
    let body_html : String?
    let vendor : String?
    let product_type : String?
    let variants : [Vproperties]?
    let images : [ProductImages]?
    //let image : images?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case body_html = "body_html"
        case vendor = "vendor"
        case product_type = "product_type"
        case variants = "variants"
        case images = "images"
        //case image = "image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        body_html = try values.decodeIfPresent(String.self, forKey: .body_html)
        vendor = try values.decodeIfPresent(String.self, forKey: .vendor)
        product_type = try values.decodeIfPresent(String.self, forKey: .product_type)
        variants = try values.decodeIfPresent([Vproperties].self, forKey: .variants)
        images = try values.decodeIfPresent([ProductImages].self, forKey: .images)
        //image = try values.decodeIfPresent(ProductImage.self, forKey: .image)
    }

}

struct ProductImages : Codable {
    let id : Int?
    let product_id : Int?
    let position : Int?
    let created_at : String?
    let updated_at : String?
    let alt : String?
    let width : Int?
    let height : Int?
    let src : String?
    let variant_ids : [String]?
    let admin_graphql_api_id : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case product_id = "product_id"
        case position = "position"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case alt = "alt"
        case width = "width"
        case height = "height"
        case src = "src"
        case variant_ids = "variant_ids"
        case admin_graphql_api_id = "admin_graphql_api_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        product_id = try values.decodeIfPresent(Int.self, forKey: .product_id)
        position = try values.decodeIfPresent(Int.self, forKey: .position)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        alt = try values.decodeIfPresent(String.self, forKey: .alt)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        src = try values.decodeIfPresent(String.self, forKey: .src)
        variant_ids = try values.decodeIfPresent([String].self, forKey: .variant_ids)
        admin_graphql_api_id = try values.decodeIfPresent(String.self, forKey: .admin_graphql_api_id)
    }

}




struct subCatecoryResponse: Decodable {
    let customCollections: [CustomCollection]

    enum CodingKeys: String, CodingKey {
        case customCollections = "custom_collections"
    }
}

// MARK: - CustomCollection
struct CustomCollection: Decodable {
    let id: Int
    let handle, title: String

    enum CodingKeys: String, CodingKey {
        case id, handle, title
    }
}




class CategoryViewModel {
    var subCategoriesNamesModel : subCatecoryResponse?     //variable .to response data
    var productOfbrandsCategoryModel : ProductA?     //variable to response data
    var FilterdArr: [ProductB]? = [ProductB]()
    
    func viewDidLoad(){
        fetchCollections()
        fetchProduct()
    }
    
    var didFetchData: (()->())?
    var didFetchDatapro: (()->())?
    
    
    func fetchCollections() {
        
        guard let url = URL(string: "https://b24cfe7f0d5cba8ddb793790aaefa12a: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@mad-ios-2.myshopify.com/admin/api/2023-01/custom_collections.json") else {return}
        
        AF.request(url).response {[weak self] response in
            guard let self = self  else {return}
            if let data = response.data {
                do{
                    
                    let category = try JSONDecoder().decode(subCatecoryResponse.self, from: data)
                    self.subCategoriesNamesModel = category
                    self.didFetchData?()
                    
                }
                catch let error{
                    print(error.localizedDescription)
                }
            } else {
            }
        }
    }
}



extension CategoryViewModel{
    func fetchProduct(id: String = ""){
        let path = "?collection_id=\(id)"
        var url = URL(string: "https://b24cfe7f0d5cba8ddb793790aaefa12a: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@mad-ios-2.myshopify.com/admin/api/2023-01/products.json\(path)")
        if id == "" {
            url = URL(string: "https://b24cfe7f0d5cba8ddb793790aaefa12a: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@mad-ios-2.myshopify.com/admin/api/2023-01/products.json")
        }
        
        AF.request(url!).response
        { response in
            if let data = response.data {
                do{
                    
                    let product = try JSONDecoder().decode(ProductA.self, from: data)
                    self.productOfbrandsCategoryModel = product
                    self.didFetchDatapro?()
                }
                catch let error{
                    print(error.localizedDescription)
                }
            } else {
            }
        }
    }
    
}
