//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Ugo Gregori  on 20/12/22.
//

import UIKit

class PokemonViewController: UIViewController {
    
    @IBOutlet var pokemonTableView: UITableView!
    
    var pokemonList: PokemonList?
    var pokemonDetails: [PokemonDetails] = []
    var pokemonSprites: [PokemonSprite] = []
    let dispatchGroupForPokemonDetails = DispatchGroup()
    let dispatchGroupForPokemonSprites = DispatchGroup()
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PokemonAPI.getPokemonList(completion: { [self]result in
            self.pokemonList = result
            if let pokemonResults = self.pokemonList?.results{
                for (index, pokemon) in pokemonResults.enumerated(){
                    dispatchGroupForPokemonDetails.enter()
                    PokemonAPI.getPokemonDetails(from: pokemon.url, index, completion: {[self]result  in
                        self.pokemonDetails.append(result)
                        dispatchGroupForPokemonDetails.leave()
                    })
                }
                dispatchGroupForPokemonDetails.notify(queue: .main) {
                    self.pokemonDetails.sort {
                        $0.id < $1.id
                    }
                    for (index,pokemon) in self.pokemonDetails.enumerated() {
                        self.dispatchGroupForPokemonSprites.enter()
                        if let pokemonSpritesFront = pokemon.sprites.front_default{
                            PokemonAPI.getPokemonSprites(from: pokemonSpritesFront, index, completion: {result  in
                                self.pokemonSprites.append(result)
                                self.dispatchGroupForPokemonSprites.leave()

                            })
                        }
                    }
                    self.dispatchGroupForPokemonSprites.notify(queue: .main) {
                        self.pokemonSprites.sort {
                            $0.id < $1.id
                        }
                        DispatchQueue.main.async {
                            self.pokemonTableView.reloadData()
                        }
                    }
                }
           
            }
            
            DispatchQueue.main.async {
                self.pokemonTableView.reloadData()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? PokemonDetailsViewController {
            destinationViewController.pokemonData = sender as? PokemonData
        }
    }
    func saveInDefault(_ list: [Pokemon_name_url]) {
        defaults.set(list, forKey: "PokemonList")
    }
    func checkSaveInDefault() -> Any {
        return defaults.array(forKey: "PokemonList") ?? []
    }
}

extension PokemonViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList?.results.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
          withIdentifier: "pokemonCell",
          for: indexPath) as? PokemonCell{
            cell.textLabel?.text = pokemonList?.results[indexPath.row].name
            if pokemonSprites.count > indexPath.row{
                if let sprite = pokemonSprites[indexPath.row].sprite{
                    cell.activityIndicator.isHidden = true
                    cell.activityIndicator.stopAnimating()
                    cell.pokemonSprite.image = UIImage(data: sprite)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = pokemonList?.results[indexPath.row].name ?? ""
        let details = pokemonDetails[indexPath.row]
        var sprite: Data?
        if pokemonSprites.count > indexPath.row{
            sprite = pokemonSprites[indexPath.row].sprite
        }else{
            sprite = nil
        }
        let data = PokemonData(pokemonName: name, pokemonDetail: details, pokemonSprite: sprite)
                               
        performSegue(withIdentifier: "toPokemonDetails", sender: data)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100    }
    
}
