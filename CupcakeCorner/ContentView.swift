//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Ifang Lee on 10/22/21.
//

import SwiftUI

/**
 1. Our address fields are currently considered valid if they contain anything, even if it’s just only whitespace.
 Improve the validation to make sure a string of pure whitespace is invalid.

 2. If our call to placeOrder() fails – for example if there is no internet connection – show an informative alert for the user.
 To test this, just disable WiFi on your Mac so the simulator has no connection either.

 3. For a more challenging task, see if you can convert our data model from a class to a struct,
 then create an ObservableObject class wrapper around it that gets passed around.
 This will result in your class having one @Published property, which is the data struct inside it,
 and should make supporting Codable on the struct much easier.
 */

class User: ObservableObject, Codable {
    @Published var name = "Darth Vader"

    /**
     create a CodingKeys enum that conforms to CodingKey(which means that every case in our enum is the name of a property we want to load and save), listing all the properties we want to archive and unarchive
     This enum is conventionally called CodingKeys, with an S on the end, but you can call it something else if you want.
     */
    enum CodingKeys: CodingKey {
        case name
    }

    /**
     anyone who subclasses our User class must override this initializer with a custom implementation to make sure they add their own values. We mark this using the required keyword: required init. An alternative is to mark this class as final so that subclassing isn’t allowed, in which case we’d write final class User and drop the required keyword entirely.
     */
    required init(from decoder: Decoder) throws {
        // “this data should have a container where the keys match whatever cases we have in our CodingKeys enum. This is a throwing call, because it’s possible those keys don’t exist.
        let container = try decoder.container(keyedBy: CodingKeys.self)

        //read values directly from that container by referencing cases in our enum
        name = try container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}


struct ContentView: View {
    @ObservedObject var order = Order()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(0..<Order.types.count) {
                            Text(Order.types[$0])
                        }
                    }

                    Stepper(value: $order.quantity, in: 3...20) {
                        Text("Number of cakes: \(order.quantity)")
                    }
                }

                Section {
                    Toggle(isOn: $order.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }

                    if order.specialRequestEnabled {
                        Toggle(isOn: $order.extraFrosting) {
                            Text("Add extra frosting")
                        }

                        Toggle(isOn: $order.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }

                Section {
                    NavigationLink(destination: AddressView(order: order)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
