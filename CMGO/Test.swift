//
//  Test.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/3/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import Foundation
struct Test:Codable{
    let id_sede:String
    let latitud:String?
    let longitud:String?
    let sede:String
    let estado:String?
    let municipio:String?
    let direccion:String?
    let cupo:String?
    let fecha:String
    let hora_inicio:String
    let hora_fin:String
    
    func isUpcommingEvent()->Bool{
        let apiFormatter = apiDateFormatter()
        if let fecha = apiFormatter.date(from: self.fecha){
            if fecha > Date(){
                return true
            }
        }
        return false
        
    }
    func formatedDate()->String{
        let apiFormatter = apiDateFormatter()
        let defaultFormatter = defaultDateFormatter()
        if let fecha = apiFormatter.date(from: self.fecha){
            return defaultFormatter.string(from: fecha)
        }
        return ""
    }
    func formatedTimeRange()->String{
        let apiTimeF = apiTimeFormatter()
        let defaultTimeF = defaultTimeFormatter()
        if let start = apiTimeF.date(from: self.hora_inicio), let end = apiTimeF.date(from: self.hora_fin){
            return "\(defaultTimeF.string(from: start)) - \(defaultTimeF.string(from: end)) hrs."
        }
        return ""
    }
    
}
