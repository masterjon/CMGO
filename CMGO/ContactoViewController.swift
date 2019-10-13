//
//  ContactoViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 8/30/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import GoogleMaps


class ContactoViewController: UIViewController {
    @IBOutlet weak var mapContainer: UIView!
    let lat = 19.393778
    let lang = -99.174646
    let zoom = Float(17.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "P3-1"),for: .default)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lang, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: mapContainer.bounds, camera: camera)
        mapContainer.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lang)
        marker.title = "Consejo Mexicano de Ginecología y Obstetricia"
        marker.map = mapView
    }
    
    @IBAction func openFb(_ sender: UIButton) {
        openUrl("https://www.facebook.com/ConsejoGinecologia/")
    }
    @IBAction func openTw(_ sender: Any) {
        openUrl("https://twitter.com/ConsejoGineco/")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
