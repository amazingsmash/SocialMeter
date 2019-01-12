//
//  ChatGraphProvider.swift
//  SocialMeter
//
//  Created by Jose Miguel S N on 11/01/2019.
//  Copyright © 2019 Jose Miguel S N. All rights reserved.
//

import Foundation

import Charts

protocol GraphProvider{
    func createChart(frame: CGRect) -> UIView?
    var errorMessage : String { get }
}

struct NMessagesPieChartProvider: GraphProvider{
    var errorMessage: String{
        get{
            return "Error on Number of Messages Pie Chart"
        }
    }
    
    let chat: ChatStats
    
    init(chat: ChatStats){
        self.chat = chat
    }
    
    func createChart(frame: CGRect) -> UIView?{
        var values: [PieChartDataEntry] = Array()
        for entry in chat.members{
            values.append(PieChartDataEntry(value: Double(entry.value.nMsg), label: entry.key))
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
        
        let chart = PieChartView(frame: frame)
        chart.backgroundColor = NSUIColor.clear
        chart.centerText = "Number of Messages"
        chart.drawEntryLabelsEnabled = false
        chart.entryLabelFont = NSUIFont(name: "San Francisco", size: 20.0)
        chart.data = PieChartData(dataSet: dataSet)
        return chart
    }
}

struct EmojiOccurencesBarChartProvider: GraphProvider{
    let member: Member
    
    var errorMessage: String{
        get{
            return "\(member.name) has not used any emoji."
        }
    }
    
    init(member: Member){
        self.member = member
    }
    
    func createChart(frame: CGRect) -> UIView?{
        print("Creating Chart for Emojis of \(member.name)")
        
        var entries: [ChartDataEntry] = Array()
        guard !member.emojiCount.isEmpty else{ return nil }
        
        var emojis = member.emojiCount.map { (arg0) -> (unicode: UnicodeScalar, count: Int) in
            let (key, value) = arg0
            return (key, value)
        }
        emojis = emojis.sorted(by: { (a: (unicode: UnicodeScalar, count: Int), b: (unicode: UnicodeScalar, count: Int)) -> Bool in
            return a.count > b.count
        })
        
        let emojiLimit = 7
        let maxEmoji = (emojiLimit < emojis.count) ? emojiLimit : emojis.count
        let importantEmojis = emojis[..<maxEmoji]
        
        for (i, value) in importantEmojis.enumerated()
        {
            let image = String(Character.init(value.unicode)).image(size: CGSize(width: 40, height: 40), fontSize: 35.0)
            entries.append(BarChartDataEntry(x: Double(i), y: Double(value.count), icon:  image))
        }
        
        let dataSet = BarChartDataSet(values: entries, label: "\(member.name) most used emojis")
        dataSet.drawIconsEnabled = true
        dataSet.iconsOffset = CGPoint(x: 0, y: -15.0)
        
        let data = BarChartData(dataSets: [dataSet])
        data.barWidth = 0.85
        
        let chart = BarChartView(frame: frame)
        chart.backgroundColor = NSUIColor.clear
        chart.data = data
        return chart
    }
}



struct MessagesTimeLineChartProvider: GraphProvider{
    let member: Member
    
    var errorMessage: String{
        get{
            return "\(member.name) has not send messages."
        }
    }
    
    init(member: Member){
        self.member = member
    }
    
    func createChart(frame: CGRect) -> UIView?{
        
        let msgAcc = member.messageTime.map { (date: Date) -> Int in
            let cal = Calendar.current
            return cal.component(.month, from: date) + 12 * cal.component(.year, from: date)
            
//            return Int(date.timeIntervalSince1970 / Double( 30 * 24 * 60 * 60 ))
        }
        
        var values = [Int : Int]()
        for a in msgAcc{
            if let v = values[a]{
                values[a] = v + 1;
            } else{
                values[a] = 1;
            }
        }
        
        
//        let values: [Double] = [8, 104, 81, 93, 52, 44, 97, 101, 75, 28,
//                                76, 25, 20, 13, 52, 44, 57, 23, 45, 91,
//                                99, 14, 84, 48, 40, 71, 106, 41, 45, 61]
        
        var entries: [ChartDataEntry] = Array()
        let vs = values.sorted { (a: (key: Int, value: Int), b: (key: Int, value: Int)) -> Bool in return a.key < b.key}
        for (i, value) in vs
        {
            entries.append(ChartDataEntry(x: Double(i), y: Double(value), icon: nil))
        }
        
        let dataSet = LineChartDataSet(values: entries, label: "\(member.name) monthly messages.")
        dataSet.drawIconsEnabled = false
        dataSet.iconsOffset = CGPoint(x: 0, y: 20.0)
        
        let chart = LineChartView(frame: CGRect(x: 0, y: 0, width: 480, height: 350))
        chart.backgroundColor = NSUIColor.clear
        chart.leftAxis.axisMinimum = 0.0
        chart.rightAxis.axisMinimum = 0.0
        chart.data = LineChartData(dataSet: dataSet)
        return chart
    }
}


