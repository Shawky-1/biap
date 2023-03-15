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
    func viewDidLoad(){
    }
    var orderSucessful: ((Bool) -> ())?
    
    func totalAmmount()-> Double{
        var totalAmmount:Double = 0
        cart.forEach { cart in
            for _ in 1...cart.quantity{
                totalAmmount = totalAmmount + Double(cart.price)
                
            }
        }
        let discount = totalAmmount * (discountAmmount / 100)
        let sumAfterDiscount = totalAmmount - discount
        return sumAfterDiscount
    }
    
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
                self.orderSucessful!(true)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
