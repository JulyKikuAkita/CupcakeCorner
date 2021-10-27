//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Ifang Lee on 10/22/21.
//

import SwiftUI

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
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
