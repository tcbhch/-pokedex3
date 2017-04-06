//
//  Pokemon.swift
//  Pokedex3
//
//  Created by Hyperactive5 on 05/04/2017.
//  Copyright © 2017 Hyperactive5. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    fileprivate var _name:String!
    fileprivate var _pokedexId:Int!
    
    private var _description:String!
    private var _type:String!
    private var _defence:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvolotionTxt:String!
    private var _nextEvolutionName:String!
    private var _nextEvolutionId:String!
    private var _nextEvolutionLevel:String!
    private var _pokemonUrl:String!
    
    
    
    var nextEvolutionLevel:String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionId:String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionName:String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolotionTxt:String {
        if _nextEvolotionTxt == nil {
            _nextEvolotionTxt = ""
        }
        return _nextEvolotionTxt
    }
    
    var attack:String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var weight:String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var height:String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var defence:String {
        if _defence == nil {
            _defence = ""
        }
        return _defence
    }
    
    var type:String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var description:String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var name:String {
        return _name
    }
    
    var pokedexId:Int {
        return _pokedexId
    }
    
    init(name:String, pokedexId:Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed:@escaping DownloadComplete)
    {
        Alamofire.request(self._pokemonUrl).responseJSON { (response) in
            if let dict = response.result.value as? [String:Any] {
                if  let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defence = dict["defense"] as? Int {
                    self._defence = "\(defence)"
                }
                if let types = dict["types"] as? [[String:Any]] , types.count > 0 {
                    if let name = types[0]["name"] as? String {
                        self._type = name
                    }
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] as? String {
                                self._type! += " / \(name)"
                            }
                        }
                    }
                }
                if let descriptionArr = dict["descriptions"] as? [[String:Any]] , descriptionArr.count > 0{
                    if let url = descriptionArr[0]["resource_uri"] as? String{
                        let descUrl = "\(URL_BASE)\(url)"
                        Alamofire.request(descUrl).responseJSON(completionHandler: { (response) in
                            if let descriptionDict = response.result.value as? [String:Any] {
                                if let description = descriptionDict["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                }
                            }
                            completed()
                        })
                    }
                }
                if let evolutions = dict["evolutions"] as? [[String:Any]] , evolutions.count > 0 {
                    if let nextEvo = evolutions[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvo
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = nextEvoId
                            }
                            if let levelExsists = evolutions[0]["level"] {
                                if let level = levelExsists as? Int {
                                    self._nextEvolutionLevel = "\(level)"
                                }
                            }
                        }
                    }
                }
            }
            completed()
        }
    }
}
