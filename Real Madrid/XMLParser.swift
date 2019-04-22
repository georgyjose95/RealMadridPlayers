//
//  XMLParser.swift
//  Real Madrid
//
//  Created by Georgy Jose on 06/04/2019.
//  Copyright © 2019 Georgy Jose. All rights reserved.
//

import Foundation

struct Player{
    var name :String = ""
    var jersey :String = ""
    var position :String = ""
    var image :String = ""
    var text :String = ""
    var url :String = ""
    var dob :String = ""
    var nationality :String = ""
    var height :String = ""
    var weight :String = ""
    var picture : String = " "
    
    
}

class XMLParser : XMLParserDelegate{
    
    var playerInfo = [Player]()
    
    vat tagName = ""
    var playerName = ""
    var playerJersey = ""
    var playerPosition = ""
    var playerImage = ""
    var playerText = ""
    var playerUrl = ""
    var playerDob = ""
    var playerNationality = ""
    var playerHeight = ""
    var playerWeight = ""
    var playerPicture = ""
    
}
