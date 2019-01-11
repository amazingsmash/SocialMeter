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
}

struct NMessagesPieChartProvider: GraphProvider{
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


