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
    @State private var results = [Result]()
    @State private var name = ""
    @State private var email = ""

    var disableSearch: Bool {
        name.contains(" ") || email.isEmpty
    }

    var body: some View {
        Form {
            Section {
                TextField("Artist name:", text: $name)
                TextField("email:", text: $email)
            }

            Section {
                Button("Search") {
                    print("Send itune search api for: \(name)")
                    loadData(search: name)
                }
                .padding()
                .disabled(disableSearch)

            }

            Section {
                List(results, id:\.trackId) { item in
                    VStack(alignment: .leading) {
                        Text(item.trackName)
                            .font(.headline)
                        Text(item.collectionName)
                    }
                }
            }
        }
    }

    /**
     Creating the URL we want to read.
     Wrapping that in a URLRequest, which allows us to configure how the URL should be accessed.
     Create and start a networking task from that URL request.
     Handle the result of that networking task.

      Notice the way we call resume() on the task straight away?
      Without it the request does nothing and you’ll be staring at a blank screen.
      But with it the request starts immediately, and control gets handed over to the system –
      it will automatically run in the background, and won’t be destroyed even after our method ends.

     */
    func loadData(search artist: String? = nil) {
        var queryArtist: String {
            return artist ?? "taylor+swift"
        }

        guard let url = URL(string: "https://itunes.apple.com/search?term=\(queryArtist)&entity=song") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)
        // if an error occurred then data won’t be set, and if data was sent back then error won’t be set
        // URLSession automatically runs in the background thread
        URLSession.shared.dataTask(with: request) { data, response, error in

        // it’s a much better idea to fetch your data in the background,
        // decode it from JSON in the background,
        // then actually update the property on the main thread to avoid any potential for problems.
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {  //go back to main thread,update our UI
                        self.results = decodedResponse.results
                    }
                    return
                }
            }
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
