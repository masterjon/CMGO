//
//  TemaParent.swift
//  CMGO
//
//  Created by Jonathan Horta on 10/2/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import Foundation

struct TemaGrandParent{
    let title:String
    var temaParents:[TemaParent]
}
struct TemaParent{
    let title:String
    var events:[Evento]
}
