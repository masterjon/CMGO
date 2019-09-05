//
//  TestDate.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/3/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import Foundation
struct TestDate{
    let date:String
    let timeStart:String
    let timeEnd:String
    
    func isUpcommingEvent()->Bool{
        let apiFormatter = apiDateFormatter()
        if let date = apiFormatter.date(from: self.date){
            if date > Date(){
                return true
            }
        }
        return false
        
    }
    func formatedDate()->String{
        let apiFormatter = apiDateFormatter()
        let defaultFormatter = defaultDateFormatter()
        if let date = apiFormatter.date(from: self.date){
            return defaultFormatter.string(from: date)
        }
        return ""
    }
    func formatedTimeRange()->String{
        let apiTimeF = apiTimeFormatter()
        let defaultTimeF = defaultTimeFormatter()
        if let start = apiTimeF.date(from: self.timeStart), let end = apiTimeF.date(from: self.timeEnd){
            return "\(defaultTimeF.string(from: start)) - \(defaultTimeF.string(from: end)) hrs."
        }
        return ""
    }
}
