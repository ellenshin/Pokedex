//
//  PokeCell.swift
//  pokedex
//
//  Created by Ellen Shin on 6/6/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        nameLbl.text = self.pokemon.name.capitalizedString
    }
    
}
