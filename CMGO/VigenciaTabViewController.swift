//
//  VigenciaTabViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/28/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class VigenciaTabViewController: TabmanViewController,TabDelegate {

    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var viewControllers = [UIViewController]()
    let barTitles = ["Mi cédula de vigencia", "Ingresa QR"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        let bar = createTopTabBar()
        addBar(bar, dataSource: self, at: .top)
        
        let cedulaVC = self.storyBoard.instantiateViewController(withIdentifier: "CedulaVC") as! CedulaViewController
        cedulaVC.delegate = self
        let canjearVC = self.storyBoard.instantiateViewController(withIdentifier: "CanjearVC")
        self.viewControllers.append(cedulaVC)
        self.viewControllers.append(canjearVC)
        self.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func changeTab(index:Int){
        print("tab chang")
        self.scrollToPage(.at(index: index), animated: true)
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

extension VigenciaTabViewController: PageboyViewControllerDataSource, TMBarDataSource{
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: barTitles[index])
    }
    
}

protocol TabDelegate
{
    func changeTab(index:Int)
}
