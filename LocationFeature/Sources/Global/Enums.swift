//
//  Enums.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/23/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import Foundation
import UIKit

enum LandMark: String, CustomStringConvertible, Codable {
    case eiffelTower        = "EiffelTower"
    case washingtonMonument = "WashingtonMonument"
    case stoneHenge         = "StoneHenge"
    case mountRushmore      = "MountRushmore"
    case bigBen             = "BigBen"
    case greatWall          = "GreatWall"
    case giza               = "Giza"
    case statueOfLiberty    = "StatueOfLiberty"
    case notreDame          = "NotreDame"
    case sistineChapel      = "SistineChapel"
    case generic            = "Generic"
    
    var description: String {
        switch self {
        case .eiffelTower:          return "Eiffel Tower"
        case .washingtonMonument:   return "Washington Monument"
        case .stoneHenge:           return "Stone Henge"
        case .mountRushmore:        return "Mount Rushmore"
        case .bigBen:               return "Big Ben"
        case .greatWall:            return "Great Wall of China"
        case .giza:                 return "Giza Pyramids"
        case .statueOfLiberty:      return "Statue of Liberty"
        case .notreDame:            return "Notre Dame"
        case .sistineChapel:        return "Sistine Chapel"
        default:                    return ""
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .eiffelTower:          return UIColor.darkBlue
        case .washingtonMonument:   return UIColor.darkerGray
        case .stoneHenge:           return UIColor.darkerGray
        case .mountRushmore:        return UIColor.darkerGray
        case .bigBen:               return UIColor.lightBrown
        case .greatWall:            return UIColor.darkerGray
        case .giza:                 return UIColor.gold
        case .statueOfLiberty:      return UIColor.teal
        case .notreDame:            return UIColor.lightBrown
        case .sistineChapel:        return UIColor.gold
        case .generic:              return UIColor.darkBlue
        }
    }
}
