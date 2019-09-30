//
//  NoticiasViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 9/29/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class NoticiasViewController: TabmanViewController {
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var viewControllers = [UIViewController]()
    let barTitles = ["Blog", "Redes Sociales"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        let bar = createTopTabBar()
        addBar(bar, dataSource: self, at: .top)
        
        let blogVC = self.storyBoard.instantiateViewController(withIdentifier: "BlogVC")
        let redesVC = self.storyBoard.instantiateViewController(withIdentifier: "RedesVC")
        self.viewControllers.append(blogVC)
        self.viewControllers.append(redesVC)
        self.reloadData()
        // Do any additional setup after loading the view.
    }
    
}
extension NoticiasViewController: PageboyViewControllerDataSource, TMBarDataSource{
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
