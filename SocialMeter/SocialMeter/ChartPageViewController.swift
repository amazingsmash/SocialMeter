//
//  ChartPageViewController.swift
//  SocialMeter
//
//  Created by Jose Miguel S N on 10/01/2019.
//  Copyright © 2019 Jose Miguel S N. All rights reserved.
//

import UIKit

class ChartPageViewController: UIPageViewController, UIPageViewControllerDataSource, ChatStatsObserver {
    func onChatStatsChanged(chatStats: ChatStats) {
        createControllers()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = (controllers.index{$0 == viewController}) else{ return nil }
        return (index < controllers.count-1) ? controllers[index+1] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = (controllers.index{$0 == viewController}) else{ return nil }
        return (index > 0) ? controllers[index-1] : nil
    }
    
    var controllers = [UIViewController]()
    
    private func createControllers() {
        
        controllers = []
        
        let chartVCID = "graphContainerVC"
        if let chat = ChatStats.main{
            controllers.append(UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: chartVCID))
            (controllers.last as? ViewController)?.graphProvider = NMessagesPieChartProvider(chat: chat)
            
            for (_, member) in chat.members{
                controllers.append(UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: chartVCID))
                (controllers.last as? ViewController)?.graphProvider = EmojiOccurencesBarChartProvider(member: member)
                
                controllers.append(UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: chartVCID))
                (controllers.last as? ViewController)?.graphProvider = MessagesTimeLineChartProvider(member: member)
            }
            
            setViewControllers([controllers.first!], direction: .forward, animated: false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createControllers()
        
        self.dataSource = self
        ChatStats.observers.append(self)
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
