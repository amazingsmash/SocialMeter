//
//  ChartPageViewController.swift
//  SocialMeter
//
//  Created by Jose Miguel S N on 10/01/2019.
//  Copyright © 2019 Jose Miguel S N. All rights reserved.
//

import UIKit

class ChartPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = (controllers.index{$0 == viewController}) else{ return nil }
        return (index < controllers.count-1) ? controllers[index+1] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = (controllers.index{$0 == viewController}) else{ return nil }
        return (index > 0) ? controllers[index-1] : nil
    }
    

    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controllers = [
            UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "pieChartVC")
        ]
        
        self.dataSource = self
        
        setViewControllers([controllers.first!], direction: .forward, animated: false, completion: nil)

        // Do any additional setup after loading the view.
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
