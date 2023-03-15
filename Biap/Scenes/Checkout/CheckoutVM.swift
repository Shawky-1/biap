//
//  CheckoutVM.swift
//  Biap
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import Foundation

class CheckOutVM: ViewModel {
    var cart: [Cart]!
    var discountAmmount = 0.0
    //    let customer: Customer!
    let currency = UserDefaults.standard.string(forKey: "currency") ?? ""

    func viewDidLoad(){
    }
    var orderSucessful: ((Bool) -> ()) = {_ in }
    
//    func totalAmmount()-> Double{
//        var totalAmmount:Double = 0
//        cart.forEach { cart in
//            for _ in 1...cart.quantity{
//                totalAmmount = totalAmmount + Double(cart.price)
//                
//            }
//        }
//        let discount = totalAmmount * (discountAmmount / 100)
//        let sumAfterDiscount = totalAmmount - discount
//        return sumAfterDiscount
//    }
    
    func createOrder(){
        var lineitem: [LineItem] = []
        cart.forEach { cart in
            let item = LineItem(variantID: cart.variantId, quantity: cart.quantity)
            lineitem.append(item)
        }
        NetworkManger.createOrder(lineItems: lineitem) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.orderSucessful(true)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func subtotal()->Double{
        let subtotal:Double = {
            var total:Double = 0
            self.cart.forEach { cart in
                for _ in 1...cart.quantity{
                    total += cart.price
                }
            }
            return total
        }()
        return subtotal
    }
    
    func currencyStr()->String{
        if currency == "USD" || currency == ""{
            return "USD"
        }else{
            return "EGP"
        }
    }
    
    func discountPrice() -> Double{
        return subtotal() * discountAmmount / 100
    }
    
    func taxesPrice()->Double{
        subtotal() * 0.14
    }
    
    func totalAmmount()->Double{
        (subtotal() - discountPrice()) + taxesPrice()
    }
    
//    func configDiscounts(){
//
//
//        let discountPrice = subtotal * discountAmmount / 100
//        let taxesPrice = subtotal * 0.14
//        let totalAmmount = (subtotal - discountPrice) + taxesPrice
//
//    }
}
