//
//  Pokemon.swift
//  pokedex
//
//  Created by Ellen Shin on 6/6/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    var _name: String!
    var _pokedexId: Int!
    var _type: String!
    var _defense: String!
    var _height: String!
    var _weight: String!
    var _attack: String!
    var _description: String!
    var _nextEvolutionTxt: String!
    var _nextEvolutionLvl: String!
    var _nextEvolutionId: String!
    var _pokemonURL: String!
    
    var name: String {
        return self._name
    }
    
    var pokedexId: Int {
        return self._pokedexId
    }
    
    var description: String {
        if _description == nil {
            self._description = ""
        }
        return self._description
    }
    
    var type: String {
        if _type == nil {
            self._type = ""
        }
        return self._type
    }
    
    var defense: String {
        if _defense == nil {
            self._defense = ""
        }
        return self._defense
    }
    
    var height: String {
        if _height == nil {
            self._height = ""
        }
        return self._height
    }
    
    var weight: String {
        if _weight == nil {
            self._weight = ""
        }
        return self._weight
    }
    
    var attack: String {
        if _attack == nil {
            self._weight = ""
        }
        return self._attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            self._nextEvolutionTxt = ""
        }
        return self._nextEvolutionTxt
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            self._nextEvolutionLvl = ""
        }
        return self._nextEvolutionLvl
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            self._nextEvolutionId = ""
        }
        return self._nextEvolutionId
    }
    
    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails (completed: downloadComplete) {
        
        let url = NSURL(string: self._pokemonURL)!
        print(url)
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        
                        for x in 1 ..< types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                        
                    }
                }
                
                if let dictArr = dict["descriptions"] as? [Dictionary<String, String>] where dictArr.count > 0 {
                    
                    if let url = dictArr[0]["resource_uri"] {
                        
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON{response in
                            let result = response.result
                            if let descDict = result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            completed()
                            
                        }

                    }
                }
                
                if let evolution = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolution.count > 1 {
                    if let to = evolution[0]["to"] as? String {
                        
                        if to.rangeOfString("mega") == nil {
                            if let url = evolution[0]["resource_uri"] {
                                let str = url.stringByReplacingOccurrencesOfString("api/v1/pokemon/", withString: "")
                                let num = str.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolution[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                            }
                            
                        }
                    }
                
        }
    }
        
        
        
        
        
        
        
        
        
    }
    
}
}