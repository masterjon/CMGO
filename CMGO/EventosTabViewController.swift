//
//  EventosTabViewController.swift
//  CMGO
//
//  Created by Jonathan Horta on 10/1/19.
//  Copyright © 2019 iddeas. All rights reserved.
//

import UIKit

import UIKit
import Tabman
import Pageboy

class EventosTabViewController: TabmanViewController {
    
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var viewControllers = [UIViewController]()
    let barTitles = ["Por fecha", "Por Estado", "Por tema"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "P3-1"),for: .default)
        
        self.dataSource = self
        let bar = createTopTabBar()
        addBar(bar, dataSource: self, at: .top)
        
        let eventosVC1 = self.storyBoard.instantiateViewController(withIdentifier: "EventosVC")
        let eventosVC2 = self.storyBoard.instantiateViewController(withIdentifier: "EventosVC")
        
        let eventosVC3 = self.storyBoard.instantiateViewController(withIdentifier: "EventosVC")
        
        self.viewControllers.append(eventosVC1)
        self.viewControllers.append(eventosVC2)
        self.viewControllers.append(eventosVC3)
        self.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    
    
}

extension EventosTabViewController: PageboyViewControllerDataSource, TMBarDataSource{
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
