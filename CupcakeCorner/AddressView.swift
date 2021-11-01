//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Ifang Lee on 10/28/21.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order.orderC

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }

            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Check out")
                }
            }
            .disabled(order.hasValidAddress == false)

            Image("darthVader")
                .resizable()
                .scaledToFit()
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order.orderC())
    }
}
