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
struct ContentView: View {
    @ObservedObject var order = Order.orderC()

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
