//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Ifang Lee on 10/28/21.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var confirmationMessage = ""
    @State private var showingConfimation = false
    @State private var showingErrorView = false

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)

                    Text("Your total is $\(self.order.cost, specifier:"%.2f")")
                        .font(.title)

                    Button("Place order") {
                        self.placeOrder()

                    }
                    .padding()

                    if showingErrorView {
                        Text("Error: No internet")
                    }

                    Image("myFutureNoodles")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150, alignment: .center)
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingConfimation) {
            Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
    }

    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded

        // Remember, if you don’t call resume() on your data task it won’t ever start,
        // which is why I nearly always write the task and
        // call resume before actually filling in the body.
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                if let errorCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Http status code: \(errorCode)")
                } else if let error = error, error.localizedDescription.contains("The Internet connection appears to be offline") {
                    showingErrorView = true
                }
                return
            }

            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.confirmationMessage = "Your order for \(decodedOrder.quantity) x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingConfimation = true
                self.showingErrorView = false
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
