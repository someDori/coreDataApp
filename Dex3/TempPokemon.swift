import Foundation

struct TempPokemon: Codable {
    let id: Int
    let name: String
    let types: [String]
    var hp = 0
    var attack = 0
    var defence = 0
    var specialAttack = 0
    var specialDefence = 0
    var speed = 0
    let sprite: URL
    let shiny: URL
    
    enum Pokemonkeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
        
        enum StatDictionaryKeys: String, CodingKey {
            case value = "base_stat"
            case stat
            
            enum StatKeys: String, CodingKey {
                case name
            }
        }
        
        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Pokemonkeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: Pokemonkeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(
                keyedBy: Pokemonkeys.TypeDictionaryKeys.TypeKeys.self,
                forKey: .type
            )
            
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        types = decodedTypes
        
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: Pokemonkeys.StatDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(
                keyedBy: Pokemonkeys.StatDictionaryKeys.StatKeys.self,
                forKey: .stat
            )
            
            switch try statContainer.decode(String.self, forKey: .name) {
            case "hp":
                hp = try statsDictionaryContainer
                    .decode(Int.self, forKey: .value)
            case "attack":
                attack = try statsDictionaryContainer
                    .decode(Int.self, forKey: .value)
            case "defence":
                defence = try statsDictionaryContainer
                    .decode(Int.self, forKey: .value)
            case "special-attack":
                specialAttack = try statsDictionaryContainer
                    .decode(Int.self, forKey: .value)
            case "special-defence":
                specialDefence = try statsDictionaryContainer
                    .decode(Int.self, forKey: .value)
            case "speed":
                speed = try statsDictionaryContainer
                    .decode(Int.self, forKey: .value)
            default:
                print("It will never get here")
            }
        }
        
        let spriteContainer = try container.nestedContainer(
            keyedBy: Pokemonkeys.SpriteKeys.self,
            forKey: .sprites
        )
        sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
        shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
    }
}
