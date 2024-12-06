import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    )
    private var pokemons: FetchedResults<Pokemon>

    var body: some View {
        NavigationView {
            List {
                ForEach(pokemons) { pokemon in
                    NavigationLink {
                        Text("\(pokemon.name!.capitalized)")
                    } label: {
                        Text("\(pokemon.id): \(pokemon.name!.capitalized)")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
