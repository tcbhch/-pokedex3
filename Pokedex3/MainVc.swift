//
//  MainVC.swift
//  Pokedex3
//
//  Created by Hyperactive5 on 05/04/2017.
//  Copyright © 2017 Hyperactive5. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {

    //MARK: variables and outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pokemons = [Pokemon]()
    
    var filteredPokemons = [Pokemon]()
    var inSearchMode = false
    
    var musicPlayer:AVAudioPlayer!
    
    //MARK: Lificycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        
        searchBar.returnKeyType = .done
        
        parsePokemonCSV()
        initAudio()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC" {
            if let dest = segue.destination as? DetailVC {
                if let poke = sender as? Pokemon {
                    dest.pokemon = poke 
                }
            }
        }
        
    }
    
    //MARK: Custom functions
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string:path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                pokemons.append(Pokemon(name:name,pokedexId:pokeId))
            }
        } catch let err as NSError {
           print(err.debugDescription)
        }
    }
    
    //MARK: Collection view delegate functions
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath) as? PokeCell {
            var pokemon:Pokemon!
            if inSearchMode {
                pokemon = filteredPokemons[indexPath.row]
            } else {
                pokemon = pokemons[indexPath.row]
            }
            cell.configureCell(pokemon)
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var pokemon:Pokemon!
        if inSearchMode {
            pokemon = filteredPokemons[indexPath.row]
        } else {
            pokemon = pokemons[indexPath.row]
        }
        performSegue(withIdentifier: "detailVC", sender: pokemon)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemons.count
        } else {
            return pokemons.count
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }

    //MARK: Action Outlets
    @IBAction func musicBtnPressed(_ sender: UIButton)
    {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    //MARK: Search bar delegate functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            let lower = searchBar.text?.lowercased()
            filteredPokemons = pokemons.filter({($0.name.range(of: lower!) != nil)})
            collectionView.reloadData()
        }
    }
}

