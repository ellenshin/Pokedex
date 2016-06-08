//
//  PokemonDetailsVC.swift
//  pokedex
//
//  Created by Ellen Shin on 6/6/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailsVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var IdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attLbl: UILabel!
    @IBOutlet weak var evolLbl: UILabel!
    @IBOutlet weak var currentEvolImg: UIImageView!
    @IBOutlet weak var nextEvolImg: UIImageView!
    
    override func viewDidLoad() {
        
        nameLbl.text = pokemon.name.capitalizedString
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvolImg.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
            super.viewDidLoad()
        }
    }
    func updateUI() {
        
        descLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        attLbl.text = pokemon.attack
        IdLbl.text = "\(pokemon.pokedexId)"
        if pokemon.nextEvolutionId != "" {
            nextEvolImg.hidden = false
            nextEvolImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL\(pokemon.nextEvolutionLvl)"
            }
            evolLbl.text = str
        } else {
            nextEvolImg.hidden = true
            evolLbl.text = "NO EVOLUTION"
        }
    }

    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
