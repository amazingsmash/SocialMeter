//
//  ViewController.swift
//  SocialMeter
//
//  Created by Jose Miguel S N on 07/01/2019.
//  Copyright © 2019 Jose Miguel S N. All rights reserved.
//

import UIKit

import Charts

class ViewController: UIViewController {
    @IBOutlet weak var chartContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let chat = AppDelegate.chatStats{
            
            
            var entries: [PieChartDataEntry] = Array()
            for entry in chat.messages{
                entries.append(PieChartDataEntry(value: Double(entry.value), label: entry.key))
            }
            
            // Sample data
//            let values: [Double] = [11, 33, 81, 52, 97, 101, 75]
            createPieChartWithValues(values: entries)
        }
    }
    
    public func createPieChartWithValues(values: Array<PieChartDataEntry>){
        
        let dataSet = PieChartDataSet(values: values, label: "Number of Messages")
        dataSet.drawIconsEnabled = false
        dataSet.iconsOffset = CGPoint(x: 0, y: 20.0)
        
        dataSet.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let chart = PieChartView(frame: self.chartContainer.frame)//CGRect(x: 0, y: 0, width: 480, height: 350))
        chart.backgroundColor = NSUIColor.clear
        chart.centerText = "Number of Messages"
        chart.drawEntryLabelsEnabled = false
        chart.entryLabelFont = NSUIFont(name: "San Francisco", size: 20.0)
        chart.data = PieChartData(dataSet: dataSet)
        
        self.chartContainer.addSubview(chart)
        
    }


}

