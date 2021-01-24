//
//  VerbType.swift
//  noderavverb
//
//  Created by Sidney P'Silva on 12/09/18.
//  Copyright © 2018 Vlad Lopes. All rights reserved.
//

import Foundation

struct VerbGroup: Codable {    
    let grupp: String
    let verbs: [VerbType]
}

struct VerbType: Codable {
    let name: String
    let tenses: [String]
    
}

