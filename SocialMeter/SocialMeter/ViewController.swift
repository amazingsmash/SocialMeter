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

    @IBOutlet weak var container: UIView!
    var chartView : PieChartView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ChatStats.observers.append(self)

        if let chat = ChatStats.main{
            pieChartFromChatStats(chat)
        }
    }
    
    func pieChartFromChatStats(_ chatStats: ChatStats){
        var entries: [PieChartDataEntry] = Array()
        for entry in chatStats.messages{
            entries.append(PieChartDataEntry(value: Double(entry.value), label: entry.key))
        }
        createPieChartWithValues(values: entries)
    }
    
    public func createPieChartWithValues(values: Array<PieChartDataEntry>){
        
        if let oldChart = chartView{
            oldChart.removeFromSuperview()
        }
        
        let dataSet = PieChartDataSet(values: values, label: "Number of Messages")
        dataSet.drawIconsEnabled = false
        dataSet.iconsOffset = CGPoint(x: 0, y: 20.0)
        
        dataSet.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        chartView = PieChartView(frame: self.container.frame)//CGRect(x: 0, y: 0, width: 480, height: 350))
        if let chart = chartView{
            chart.backgroundColor = NSUIColor.clear
            chart.centerText = "Number of Messages"
            chart.drawEntryLabelsEnabled = false
            chart.entryLabelFont = NSUIFont(name: "San Francisco", size: 20.0)
            chart.data = PieChartData(dataSet: dataSet)
            self.container.addSubview(chart)
        }
        
    }
    
    
//    /// Observer
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//
//        ChatStats.observers.append(self)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    deinit {
        ChatStats.observers = ChatStats.observers.filter{ ($0 as? ViewController) == self}
    }
    
    func onChatStatsChanged(chatStats: ChatStats) {
        pieChartFromChatStats(chatStats)
    }
}

