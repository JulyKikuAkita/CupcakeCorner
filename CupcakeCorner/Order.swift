//
//  Order.swift
//  CupcakeCorner
//
//  Created by Ifang Lee on 10/28/21.
//

import Foundation

struct Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    class orderC: ObservableObject, Codable {
        init() { }

        enum CodingKeys: CodingKey {
            case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(type, forKey: .type)
            try container.encode(quantity, forKey: .quantity)
            try container.encode(extraFrosting, forKey: .extraFrosting)
            try container.encode(addSprinkles, forKey: .addSprinkles)
            try container.encode(name, forKey: .name)
            try container.encode(streetAddress, forKey: .streetAddress)
            try container.encode(city, forKey: .city)
            try container.encode(zip, forKey: .zip)
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            type = try container.decode(Int.self, forKey: .type)
            quantity = try container.decode(Int.self, forKey: .quantity)

            extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
            addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)

            name = try container.decode(String.self, forKey: .name)
            streetAddress = try container.decode(String.self, forKey: .streetAddress)
            city = try container.decode(String.self, forKey: .city)
            zip = try container.decode(String.self, forKey: .zip)
        }

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

        /**
         1. Our address fields are currently considered valid if they contain anything, even if it’s just only whitespace.
         Improve the validation to make sure a string of pure whitespace is invalid.
         */
        var hasValidAddress: Bool {
            if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
}
