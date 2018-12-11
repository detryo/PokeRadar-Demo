//
//  Pokemon.swift
//  PokeRadar
//
//  Created by Cristian Sedano Arenas on 11/12/18.
//  Copyright © 2018 Cristian Sedano Arenas. All rights reserved.
//

import Foundation
import UIKit

class Pokemon: NSObject {
    
    var id : Int
    var name : String
    var image: UIImage
    
    init(id: Int, name: String){
        
        self.id = id
        self.image = UIImage(named: "\(id).png")!
        self.name = name
    }
}
