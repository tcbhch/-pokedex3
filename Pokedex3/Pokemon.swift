//
//  Pokemon.swift
//  Pokedex3
//
//  Created by Hyperactive5 on 05/04/2017.
//  Copyright © 2017 Hyperactive5. All rights reserved.
//

import Foundation

class Pokemon {
    
    fileprivate var _name:String!
    fileprivate var _pokedexId:Int!
    
    var name:String {
        return _name
    }
    
    var pokedexId:Int {
        return _pokedexId
    }
    
    init(name:String, pokedexId:Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}
