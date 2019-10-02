//
//  ExamenTabViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 10/1/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class ExamenTabViewController: TabmanViewController, TabDelegate {
    
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var viewControllers = [UIViewController]()
    let barTitles = ["Clendario", "Examen de Certificación"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "P3-1"),for: .default)
        
        self.dataSource = self
        let bar = createTopTabBar()
        addBar(bar, dataSource: self, at: .top)
        
        let examenVC = self.storyBoard.instantiateViewController(withIdentifier: "ExamenVC")
        let examenCertVC = self.storyBoard.instantiateViewController(withIdentifier: "ExamenCertVC") as! ExamenCertViewController
        examenCertVC.delegate = self
        self.viewControllers.append(examenVC)
        self.viewControllers.append(examenCertVC)
        self.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: TabmanViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        if index == 1 && getUserToken() == nil{
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            vc.delegate = self
            present(vc,animated: true,completion:nil)
        }
    }
    
    
    func changeTab(index: Int) {
        self.scrollToPage(.at(index: index), animated: true)
    }
    

}

extension ExamenTabViewController: PageboyViewControllerDataSource, TMBarDataSource{
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

