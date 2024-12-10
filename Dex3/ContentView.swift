import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var searchQuery: String = ""
    @State var filterByFavorites = false
    
    var filteredPokemons: [Pokemon] {
        let predicate: NSPredicate
        
        if filterByFavorites && !searchQuery.isEmpty {
            predicate = NSPredicate(format: "favorite = %d AND name CONTAINS[cd] %@", true, searchQuery)
        } else if filterByFavorites {
            predicate = NSPredicate(format: "favorite = %d", true)
        } else if searchQuery.isEmpty {
            predicate = NSPredicate(value: true)
        } else {
            predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchQuery)
        }
        
        let request = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return try! viewContext.fetch(request)
    }
    
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
    
    
    var body: some View {
        switch pokemonVM.status {
        case .success:
            NavigationStack {
                List(filteredPokemons) { pokemon in
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
                        
                        Image(
                            systemName: pokemon.favorite ? "star.fill" : "star"
                        )
                        .foregroundStyle(.yellow)
                    }
                }
                .searchable(
                    text: $searchQuery,
                    placement: .automatic,
                    prompt: "Search for pokemon"
                )
                .textInputAutocapitalization(.never)
                .onChange(of: searchQuery) {}
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self) { pokemon in
                    PokemonDetailsView()
                        .environmentObject(pokemon)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation {
                                filterByFavorites.toggle()
                                
                                
                            }
                        } label: {
                            Image(systemName: filterByFavorites ? "star.fill" : "star")
                                .font(.title2)
                                .foregroundStyle(.yellow)
                        }
                    }
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
