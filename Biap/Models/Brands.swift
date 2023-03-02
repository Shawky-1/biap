//
//  Brands.swift
//  Biap
//
//  Created by Ahmed Shawky on 01/03/2023.
//

import Foundation

//fileprivate struct RawServerResponse: Decodable {
//    struct Image: Decodable {
//        var src: String
//    }
//    struct smartCollections: Decodable{
//        var id: Int
//        var handle: String
//        var title: String
//        var body_html: String
//        var image: Image
//
//    }
//    var smart_collections:[smartCollections]
//
//}
//
//struct Brand: Decodable {
//
//    struct Item: Decodable {
//        var id: String
//        var handle: String
//        var title: String
//        var body: String
//        var image: String
//        init(id: String, handle: String, title: String, body: String, image: String) {
//            self.id = id
//            self.handle = handle
//            self.title = title
//            self.body = body
//            self.image = image
//        }
//    }
//    var items: [Item]
//
//
//    init(from decoder: Decoder) throws {
//        let rawResponse = try RawServerResponse(from: decoder)
//        var itemsValue = [Item]()
//        for  value in rawResponse.smart_collections {
//            let item = Item(id: String(value.id), handle: value.handle, title: value.title, body: value.body_html, image: value.image.src)
//            itemsValue.append(item)
//        }
//
//        items = itemsValue
//    }
//}



/*struct Brand: Decodable{
    let brands: [SmartCollections]
    enum CodingKeys: String, CodingKey {
        case brands = "smart_collections"
    }
    
    struct SmartCollections: Decodable{
        let id: Int
        let handle: String
        let title: String
        let body: String
        let image:Image
        
        enum CodingKeys: String, CodingKey {
            case id
            case handle
            case title
            case body = "body_html"
            case image
        }
        
    }
    
    struct Image: Decodable{
        let image:String
        
        enum CodingKeys: String, CodingKey{
            case image = "src"
        }
    }
}*/




struct brands:Codable{
    let smart_collections:[brand]
}

struct brand:Codable{
    let id:Int?
    let title:String?
    let handle:String?
    let image:brandLogo
}

struct brandLogo:Codable{
    let src:String?
}

