//
//  PokemonFactory.swift
//  PokeRadar
//
//  Created by Cristian Sedano Arenas on 11/12/18.
//  Copyright © 2018 Cristian Sedano Arenas. All rights reserved.
//

import Foundation

class PokemonFactory {
    
    static let shared : PokemonFactory = {
           let shared = PokemonFactory()
           return shared
    }()
    
    init() {
        let data = self.readDataFromCSV(filename: "pokemon", fileType: "csv")
        let csvRows = self.csv(data: data!)
        
        for row in csvRows {
            
            if  let id = Int(row[0]){
                
                if id > 151 { break }
                
                let name = row[1]
                let pokemon = Pokemon(id: id, name: name)
                self.pokemons.append(pokemon)
            }
        }
    }
    
    var pokemons : [Pokemon] = []
    
    func getPokemon(with pokemonId: Int) -> Pokemon {
        return self.pokemons[pokemonId-1]
    }
    
    func csv(data: String) -> [[String]] {
        
        var result : [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    func readDataFromCSV(filename: String, fileType: String) -> String! {
        
        guard let filePath = Bundle.main.path(forResource: filename, ofType: fileType) else { return nil }
        
        do {
            let contents = try String(contentsOfFile: filePath, encoding: .utf8)
            return contents
        }catch {
            print("ERROR \(filename)")
            return nil
        }
    }
}
