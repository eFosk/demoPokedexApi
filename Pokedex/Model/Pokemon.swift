//
//  Pokemon.swift
//  Pokedex
//
//  Created by Ugo Gregori  on 20/12/22.
//

import Foundation

struct PokemonList: Codable{
    let count: Int
    let results: [Pokemon_name_url]
}

struct Pokemon_name_url:Codable{
    let name :String
    let url: String
}

struct PokemonDetails: Codable {
    struct Stat: Codable {
      struct StatDetail: Codable {
        let name: String
        let url: URL
      }
      let base_stat: Int
      let stat: StatDetail
    }
    struct Sprite: Codable {
      let front_default: String?
      let front_shiny: String?
      let front_female: String?
      let front_shiny_female: String?
      let back_default: String?
      let back_shiny: String?
      let back_female: String?
      let back_shiny_female: String?
    }
    let stats:[Stat]
    let sprites: Sprite
    var id: Int
}

struct PokemonSprite{
    let sprite: Data?
    var id:Int
}

struct PokemonData {
    let pokemonName: String
    let pokemonDetail: PokemonDetails
    let pokemonSprite: Data?
}

struct PokemonAPI {
        
    static func getPokemonList(completion : @escaping (PokemonList) -> Void){
        guard let validURL = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0") else {
            print("URL not valid")
            return
        }
        URLSession.shared.dataTask(with: validURL, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("Error")
                return
            }
            var result : PokemonList
            do{
                result = try JSONDecoder().decode(PokemonList.self, from: data)
                completion(result)
            }catch{
                print("Failed to convert \(error)")
            }
        }).resume()
    }
    
    static func getPokemonDetails(from url:String, _ id:Int, completion : @escaping (PokemonDetails) -> Void){
        guard let validURL = URL(string: url) else {
            print("URL not valid")
            return
        }
        URLSession.shared.dataTask(with: validURL, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("Error")
                return
            }
            var result : PokemonDetails
            do{
                result = try JSONDecoder().decode(PokemonDetails.self, from: data)
                result.id = id
                completion(result)
            }catch{
                print("Failed to convert \(error)")
            }
        }).resume()
    }
    
    static func getPokemonSprites(from url:String, _ id:Int, completion : @escaping (PokemonSprite) -> Void){
        guard let validURL = URL(string: url) else {
            print("URL not valid")
            return
        }
        URLSession.shared.dataTask(with: validURL, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("Error")
                return
            }
            let result = PokemonSprite(sprite: data,id:id)
            completion(result)
        }).resume()
    }
}
