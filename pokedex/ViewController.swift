//
//  ViewController.swift
//  pokedex
//
//  Created by Ellen Shin on 6/6/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    
    var inSearchMode = false
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.Done
        initPlayer()
        parseInPokemon()
        
    }
    
    
    func initPlayer() {
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
        
        
    }
    @IBAction func musicBtnPressed(sender: UIButton!) {
        if(musicPlayer.playing) {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func parseInPokemon() {
        
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
        
            for row in rows {
            
                let pokemon = Pokemon(name: row["identifier"]!, pokedexId: Int(row["id"]!)!)
                pokemons.append(pokemon)
            }
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
        
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            view.endEditing(true)
            collectionView.reloadData()
        } else {
            
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredPokemons = pokemons.filter({$0.name.rangeOfString(lower) != nil})
            collectionView.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            var poke: Pokemon!
            if inSearchMode {
                poke = filteredPokemons[indexPath.row]
            } else {
                poke = pokemons[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PokemonDetailsVC" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailsVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemons[indexPath.row]
        } else {
            poke = pokemons[indexPath.row]
        }
        performSegueWithIdentifier("PokemonDetailsVC", sender: poke)
        

    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemons.count
        }
        return pokemons.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    

}

