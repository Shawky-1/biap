//
//  Coupons.swift
//  Biap
//
//  Created by Bassant on 04/03/2023.
//

import Foundation

struct coupon{
    var code: String?
    var image: String?
    var discountAmmount: Double?
}


class globalCoupons{
    static let shared = globalCoupons()
    var coupones:[coupon] = [coupon(code: "VFSSW20", image: "ad1", discountAmmount: 20.0),
                             coupon(code: "EFYSS10", image: "ad2", discountAmmount: 10.0),
                             coupon(code: "SUVXX50", image: "ad3", discountAmmount: 50.0)]
}
