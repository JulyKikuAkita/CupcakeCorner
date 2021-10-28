//
//  Order.swift
//  CupcakeCorner
//
//  Created by Ifang Lee on 10/28/21.
//

import Foundation

class Order: ObservableObject {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    @Published var type = 0
    @Published var quantity = 3

    @Published var specialRequestEnabled = false {
        didSet { // make sure defaul state is false when toggle specialRequestEnabled
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    @Published var extraFrosting = false
    @Published var addSprinkles = false

    // Note: if want to preserve change between view while use struct,
    // you should follow the same struct inside class approach we used back in project 7
    // delivery details
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""

    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }

    // cupcake pricing
    // There’s a base cost of $2 per cupcake.
    // We’ll add a little to the cost for more complicated cakes.
    // Extra frosting will cost $1 per cake.
    // Adding sprinkles will be another 50 cents per cake.
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2

        // complicated cakes cost more
        cost += (Double(type) / 2)

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }

        return cost
    }
}
