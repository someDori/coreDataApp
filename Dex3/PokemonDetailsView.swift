//
//  PokemonDetailsView.swift
//  Dex3
//
//  Created by Demetre Panjakidze on 08.12.24.
//

import SwiftUI
import CoreData

struct PokemonDetailsView: View {
    @EnvironmentObject var pokemon: Pokemon
    
    var body: some View {
        Text(pokemon.description)
    }
}

#Preview {
    PokemonDetailsView()
        .environmentObject(SamplePokemon.samplePokemon)
}
