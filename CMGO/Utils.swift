//
//  Utils.swift
//  CMGO
//
//  Created by Jonathan Horta on 8/27/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import Foundation
import UIKit
import Tabman
import KeychainAccess


enum KEY{
    enum UserDefaults{
        static let myTests = "myTests"
        static let myEvents = "myEvents"
    }
    enum Keychain{
        static let userToken = "token"
    }
    enum Notifications{
        static let authChanged = ""
    }
}
final class Settings{
    static let locale = "es_MX"
    static let apiKey = "N9AXhMHMz4xbcS3SkI0FBX2axmKtInMVPt7eSJdD"
    static let defaultNotiftime = "08:00:00"
    
}

func openUrl(_ url:String){
    guard let url = URL(string: url) else { return }
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
        UIApplication.shared.openURL(url)
    }
}
func getHttpHeaders ()-> [String:String]{
    let headers = [
        "CMGO_API_KEY": Settings.apiKey,
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    return headers
}

func alertDefault(title:String, message:String? = nil)->UIAlertController {
    let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    return alert
}

func getUserToken()->String?{
    let keychain = Keychain()
    if let token = keychain[KEY.Keychain.userToken]{
        return token
    }
    return nil
}

func deleteUserToken(){
    let keychain = Keychain()
    keychain[KEY.Keychain.userToken] = nil
}

func getMyTests()->[Test]?{
    guard let data = UserDefaults.standard.data(forKey: KEY.UserDefaults.myTests) else {
        return nil
    }
    return try? JSONDecoder().decode([Test].self, from: data)
}
func getMyEvents()->[Evento]?{
    guard let data = UserDefaults.standard.data(forKey: KEY.UserDefaults.myEvents) else {
        return nil
    }
    return try? JSONDecoder().decode([Evento].self, from: data)
}
func addMyTests(item:Test)->(Bool,String){
    var tests = [Test]()
    if let t = getMyTests() {
        let exist = t.filter({ (test) -> Bool in
            return test.id_sede == item.id_sede
        })
        if !exist.isEmpty{
            return (false,"Este examen ya está agregado a su agenda")
        }
        tests.append(contentsOf: t)
    }
    tests.append(item)
    guard let data = try? JSONEncoder().encode(tests) else { return (false,"Hubo un error, intenta de nuevo mas tarde") }
    UserDefaults.standard.set(data, forKey: KEY.UserDefaults.myTests)
    setupNotification(item:item, type:.test)
    return (true,"Este examen ha sido exitosamente agregado a su agenda")
}

func addMyEvent(item:Evento)->(Bool,String){
    var eventos = [Evento]()
    if let t = getMyEvents() {
        let exist = t.filter({ (event) -> Bool in
            return event.id_evento == item.id_evento
        })
        if !exist.isEmpty{
            return (false,"Este evento ya está agregado a su agenda")
        }
        eventos.append(contentsOf: t)
    }
    eventos.append(item)
    guard let data = try? JSONEncoder().encode(eventos) else { return (false,"Hubo un error, intenta de nuevo mas tarde") }
    UserDefaults.standard.set(data, forKey: KEY.UserDefaults.myEvents)
    setupNotification(item:item, type:.event)
    return (true,"Este evento ha sido exitosamente agregado a su agenda")
}

func deleteMyEvent(item:Evento){
    var eventos = [Evento]()
    if let t = getMyEvents() {
        let index = t.firstIndex(where: { (event) -> Bool in
            event.id_evento == item.id_evento
        })
        eventos.append(contentsOf: t)
        if let idx = index{
            eventos.remove(at: idx)
        }
        guard let data = try? JSONEncoder().encode(eventos) else { return }
        UserDefaults.standard.set(data, forKey: KEY.UserDefaults.myEvents)
    }
    
}

func deleteMyTest(item:Test){
    var tests = [Test]()
    if let t = getMyTests() {
        let index = t.firstIndex(where: { (test) -> Bool in
            test.id_sede == item.id_sede
        })
        tests.append(contentsOf: t)
        if let idx = index{
            tests.remove(at: idx)
        }
        guard let data = try? JSONEncoder().encode(tests) else { return }
        UserDefaults.standard.set(data, forKey: KEY.UserDefaults.myTests)
    }
}

func apiDateFormatter()-> DateFormatter{
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "yyyy-MM-dd"
    dateFormater.locale = Locale(identifier: Settings.locale)
    return dateFormater
}

func defaultDateFormatter()-> DateFormatter{
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "d MMM yyyy"
    dateFormater.locale = Locale(identifier: Settings.locale)
    return dateFormater
}

func apiTimeFormatter()-> DateFormatter{
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "HH:mm:ss"
    dateFormater.locale = Locale(identifier: Settings.locale)
    return dateFormater
}

func apiDateTimeFormatter()-> DateFormatter{
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormater.locale = Locale(identifier: Settings.locale)
    return dateFormater
}

func defaultTimeFormatter()-> DateFormatter{
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "HH:mm"
    dateFormater.locale = Locale(identifier: Settings.locale)
    return dateFormater
}

func monthDateFormatter()-> DateFormatter{
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "d MMM"
    dateFormater.locale = Locale(identifier: Settings.locale)
    return dateFormater
}

func yearDateFormatter()-> DateFormatter{
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "yyyy"
    dateFormater.locale = Locale(identifier: Settings.locale)
    return dateFormater
}

func getDateTime(fecha:String,hora:String)->Date?{
    let dateTime = "\(fecha) \(hora)"
    print("getDate: \(dateTime)")
    let dt = apiDateTimeFormatter().date(from: dateTime)
    print("getDate: \(dt)")
    return dt
}

func getNotificationDateTime(fecha:String,hora:String)->Date?{
    guard let dateTime = getDateTime(fecha: fecha,hora: hora) else { return nil}
    print("getDateNotif: \(dateTime)")
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: -3, to: dateTime)
    return date
}

class RoundedCornersView: UIView{
    
    override func awakeFromNib() {
        self.clipsToBounds = true
        let radius = self.frame.height / 2
        layer.cornerRadius = radius
        
    }
    
}

func createTopTabBar()->TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator> {
    let bar = TMBar.ButtonBar()
    bar.layout.transitionStyle = .progressive
    
    bar.backgroundView.style = .flat(color: ColorPalette.DarkGreen)
    bar.indicator.tintColor = ColorPalette.LightGreen
    bar.indicator.weight = .heavy
    bar.layout.contentMode = .fit
    bar.buttons.customize { (button) in
        button.tintColor = ColorPalette.SystemGray2
        button.font = .systemFont(ofSize: 15)
        button.selectedTintColor = .white
        button.selectedFont = .boldSystemFont(ofSize: 15)
        
    }
    return bar
}



