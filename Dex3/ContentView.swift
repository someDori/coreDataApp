import CoreData
import SwiftUI

struct ContentView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    )
    private var pokedex: FetchedResults<Pokemon>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default
    )
    private var favorites: FetchedResults<Pokemon>
    
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
    
    @State var searchQuery: String = ""
    
    @State var filterByFavorites = false
    
    var body: some View {
        switch pokemonVM.status {
        case .success:
            NavigationStack {
                List(filterByFavorites ? favorites : pokedex) { pokemon in
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
