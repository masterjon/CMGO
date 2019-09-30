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

final class Settings{
    static let locale = "es_MX"
    
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
        "CMGO_API_KEY": "ZCn76kBSJ2LE7wJ3S4O8WwiLWLywJLW8LZpWe3HA",
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
    if let token = keychain["token"]{
        return token
    }
    return nil
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

func defaultTimeFormatter()-> DateFormatter{
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "H:mm"
    dateFormater.locale = Locale(identifier: Settings.locale)
    return dateFormater
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
        button.font = .systemFont(ofSize: 17)
        button.selectedTintColor = .white
        button.selectedFont = .boldSystemFont(ofSize: 17)
        
    }
    return bar
}
