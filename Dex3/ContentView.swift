import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    )
    private var pokedex: FetchedResults<Pokemon>
    
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())

    var body: some View {
        switch pokemonVM.status {
        case .success:
            NavigationStack {
                List(pokedex) { pokemon in
                    NavigationLink(value: pokemon) {
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        
                        Text("\(pokemon.name!.capitalized)")
                    }
                }
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self) { pokemon in
                    PokemonDetailsView()
                        .environmentObject(pokemon)
                }
            }
        default:
            ProgressView()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
