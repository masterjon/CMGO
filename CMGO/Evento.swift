//
//  Evento.swift
//  CMGO
//
//  Created by Jonathan Horta on 10/2/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import Foundation
struct Evento:Codable{
    let id_evento:String
    let nombre_evento:String
    let correo:String
    let estado:String
    let municipio:String
    let nombre_solicitante:String
    let f_inicio:String
    let f_fin:String
    let direccion:String
    let telefono:String
    let nombre_institucion:String
    let temas : [Tema]?
    
    func formatedDateStart()->String{
        let apiFormatter = apiDateFormatter()
        let defaultFormatter = monthDateFormatter()
        if let date = apiFormatter.date(from: self.f_inicio){
            return defaultFormatter.string(from: date)
        }
        return ""
    }
    func formatedDateEnd()->String{
        let apiFormatter = apiDateFormatter()
        let defaultFormatter = monthDateFormatter()
        if let date = apiFormatter.date(from: self.f_fin){
            return defaultFormatter.string(from: date)
        }
        return ""
    }
}

