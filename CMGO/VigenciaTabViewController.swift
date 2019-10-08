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
    var loginShown = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "P3-1"),for: .default)
        self.dataSource = self
        let bar = createTopTabBar()
        addBar(bar, dataSource: self, at: .top)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if getUserToken() == nil && !loginShown{
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            present(vc,animated: true,completion:{self.loginShown=true} )
        }
        else if getUserToken() == nil && loginShown{
            let vc = navigationController?.popViewController(animated: true)
            if vc == nil{
                let home = self.storyBoard.instantiateViewController(withIdentifier: "InicioNVC")
                present(home,animated: true)
            }
        }
        else{
            
            if viewControllers.isEmpty{
                let cedulaVC = self.storyBoard.instantiateViewController(withIdentifier: "CedulaVC") as! CedulaViewController
                cedulaVC.delegate = self
                let canjearVC = self.storyBoard.instantiateViewController(withIdentifier: "CanjearVC")
                self.viewControllers.append(cedulaVC)
                self.viewControllers.append(canjearVC)
                self.reloadData()
            }
            
        }
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
        print(index)
        return TMBarItem(title: barTitles[index])
    }
    
}

protocol TabDelegate
{
    func changeTab(index:Int)
}
