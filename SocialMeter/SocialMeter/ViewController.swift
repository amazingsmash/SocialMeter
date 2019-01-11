//
//  ViewController.swift
//  SocialMeter
//
//  Created by Jose Miguel S N on 07/01/2019.
//  Copyright © 2019 Jose Miguel S N. All rights reserved.
//

import UIKit

import Charts

class ViewController: UIViewController, ChatStatsObserver {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var container: UIView!
    var chartView : UIView? = nil
    
    public var memberName = ""
    public var graphProvider : GraphProvider? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ChatStats.observers.append(self)

        if let chat = ChatStats.main{
            addGraph(chat)
        }
    }
    
    func addGraph(_ chatStats: ChatStats){
        
        if let oldChart = chartView{
            oldChart.removeFromSuperview()
        }
        
        if let gp = graphProvider{
            chartView = gp.createChart(frame: self.container.frame)
            if let chart = chartView{
                self.container.addSubview(chart)
                message.isHidden = true;
            } else{
                message.text = gp.errorMessage
            }
        }
        else{
            print("No GP")
        }
    }
    
    deinit {
        ChatStats.observers = ChatStats.observers.filter{ ($0 as? ViewController) == self}
    }
    
    func onChatStatsChanged(chatStats: ChatStats) {
        addGraph(chatStats)
    }
}

