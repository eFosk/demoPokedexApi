//
//  PokemonDetailsViewController.swift
//  Pokedex
//
//  Created by Ugo Gregori  on 20/12/22.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    
    @IBOutlet var pokemonImage: UIImageView!
    @IBOutlet var pokemonName: UILabel!
    @IBOutlet var pokemonHp: UILabel!
    @IBOutlet var pokemonAttack: UILabel!
    @IBOutlet var pokemonDefense: UILabel!
    @IBOutlet var pokemonSpecialAttack: UILabel!
    @IBOutlet var pokemonSpecialDefense: UILabel!
    @IBOutlet var pokemonSpeed: UILabel!
    
    var pokemonData : PokemonData?

    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonName.text = pokemonData?.pokemonName.uppercased() ?? ""
        pokemonHp.text = "Hp: \(String(pokemonData?.pokemonDetail.stats[0].base_stat ?? 0))"
        pokemonAttack.text = "Attack: \(String(pokemonData?.pokemonDetail.stats[1].base_stat ?? 0))"
        pokemonDefense.text = "Defense: \(String(pokemonData?.pokemonDetail.stats[2].base_stat ?? 0))"
        pokemonSpecialAttack.text = "Special-Attack: \(String(pokemonData?.pokemonDetail.stats[3].base_stat ?? 0))"
        pokemonSpecialDefense.text = "Special-Defense: \(String(pokemonData?.pokemonDetail.stats[4].base_stat ?? 0))"
        pokemonSpeed.text = "Speed: \(String(pokemonData?.pokemonDetail.stats[5].base_stat ?? 0))"
        if let sprite = pokemonData?.pokemonSprite{
            pokemonImage.image = UIImage(data: sprite)
        }else{
            PokemonAPI.getPokemonSprites(from: pokemonData?.pokemonDetail.sprites.front_default ?? "" ,0, completion: { result in
                DispatchQueue.main.async {
                    self.pokemonImage.image = UIImage(data: result.sprite ?? Data())
                }
            })
        }
    }
}
