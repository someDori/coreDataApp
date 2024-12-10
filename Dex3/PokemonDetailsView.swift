import CoreData
import SwiftUI

struct PokemonDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var pokemon: Pokemon
    @State private var showShiny = false
    
    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)
                AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 6)
                } placeholder: {
                    ProgressView()
                }
            }
            HStack {
                ForEach(pokemon.types!, id: \.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white, radius: 1)
                        .padding(.vertical, 7)
                        .padding(.horizontal)
                        .background(Color(type.capitalized))
                        .cornerRadius(50)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        pokemon.favorite.toggle()
                        
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                } label: {
                    Image(
                        systemName: pokemon.favorite ? "star.fill" : "star"
                    )
                    .font(.title2)
                    .foregroundStyle(.yellow)
                }
            }
            .padding()
            
            Text("Stats")
                .font(.title)
                .padding(.bottom, -7)
            
            StatsView()
                .environmentObject(pokemon)
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showShiny.toggle()
                } label: {
                    if showShiny {
                        Image(systemName: "wand.and.stars")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "wand.and.stars.inverse")
                    }
                }
            }
        }
    }
}

#Preview {
    PokemonDetailsView()
        .environmentObject(SamplePokemon.samplePokemon)
}
