//
//  Notifications.swift
//  CMGO
//
//  Created by Jonathan Horta on 10/9/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import Foundation
import UserNotifications

enum NotificationType{
    case event,test
}

func setupNotification(item:Any, type:NotificationType){
    
    let content = UNMutableNotificationContent()
    var identifier = ""
    var dateTimeTemp : Date? = nil
    var titleEl = ""
    switch type {
    case .event:
        titleEl = "Evento"
        if let event = item as? Evento{
            content.body = event.nombre_evento
            identifier = "event-\(event.id_evento)"
            dateTimeTemp = getNotificationDateTime(fecha:event.f_inicio,hora:Settings.defaultNotiftime)
        }
        
        //dateTimeTemp = appointment.getNotificationDateTime2()
    case .test:
        titleEl = "Examen"
        if let test = item as? Test{
            content.body = test.sede
            identifier = "examen-\(test.id_sede)"
            dateTimeTemp = getNotificationDateTime(fecha:test.fecha,hora:test.hora_inicio)

        }
        
        //dateTimeTemp = appointment.getNotificationDateTime2()
    }
    content.title = "Recuerda tu próximo \(titleEl) en 3 días"
    guard let dateTime = dateTimeTemp else{return}
    let center = UNUserNotificationCenter.current()
    content.sound = .default
//    content.userInfo = [
//       "test":1
//    ]
    
    let comp = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: dateTime)
    print(dateTime)
    let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
    
    let request = UNNotificationRequest(identifier: identifier,
                                        content: content, trigger: trigger)
    center.add(request, withCompletionHandler: { (error) in
        if let error = error {
            print(error)
        }
        else{
            print("added \(identifier) notification")
        }
    })
}
func deletePendingNotif(identifier:String){
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [identifier])
}
func getPendingNotif(){
    let center = UNUserNotificationCenter.current()
    center.getPendingNotificationRequests(completionHandler: { requests in
        print("pending notifs")
        for request in requests {
            print(request.identifier)
        }
    })
}
