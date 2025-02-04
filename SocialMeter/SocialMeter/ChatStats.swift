//
//  ChatStats.swift
//  SocialMeter
//
//  Created by Jose Miguel S N on 08/01/2019.
//  Copyright © 2019 Jose Miguel S N. All rights reserved.
//

import Foundation
import UIKit

extension String{
    
    func slice(range: NSRange) -> Substring{
        let start = range.location
        var end = start + range.length
        if end > self.count{
            end = self.count
        }
        
        let indexStartOfText = self.index(self.startIndex, offsetBy: start)
        let indexEndOfText = self.index(self.startIndex, offsetBy: end)
        return self[indexStartOfText..<indexEndOfText]
    }
    
    var maxRange: NSRange{
        get{
            return NSRange.init(location: 0, length: self.count)
        }
    }
    
    func getEmojis() -> String?{
        var res = ""
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1F1E6...0x1F1FF: // Flags
                res.append(Character.init(scalar))
            default:
                continue
            }
        }
        return (res.count > 0) ? res : nil
    }
    
    func image(size: CGSize, fontSize: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.init(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.0).set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: fontSize)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

protocol ChatStatsObserver {
    func onChatStatsChanged(chatStats: ChatStats)
}

struct Member{
    let name : String;
    var nMsg : Int {
        get{ return messageTime.count}
    }
    var emojiCount : [UnicodeScalar : Int] = [:]
    var messageTime = [Date]()
    
    init(memberName name: String){
        self.name = name
    }
    
    mutating func addEmojis(newEmojis: String){
        for e in newEmojis.unicodeScalars{
            let val : Int = (emojiCount[e] ?? 0)!
            emojiCount[e] = val + 1
        }
    }
    
    mutating func addMsgTime(_ date : Date){
        messageTime.append(date)
    }
}

class ChatStats{
    
    static var main : ChatStats? = nil{
        didSet{
            if let chat = main{
                for o in ChatStats.observers{
                    o.onChatStatsChanged(chatStats: chat)
                }
            }
        }
    }
    public static var observers = [ChatStatsObserver]()
    
    public var members = [String : Member]()
    
    let text: String
    
    let flaggedMessages = ["imagen omitida",
                           "Los mensajes en este grupo ahora están protegidos con cifrado de extremo a extremo."]
    
    init(txtFile: URL){
        text = try! String(contentsOf: txtFile)
        analyze()
    }
    
    private func analyze(){
        
        let regex = try! NSRegularExpression(pattern: "\\[(.+/.+/.+ .+:.+:.+)\\] ([^:]*): (.*)", options: .caseInsensitive)
        
        func stringToDate(_ string: String) -> Date?{
            //            let isoDate = "2016-04-14T10:44:00+0000"
            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.dateFormat = "dd/MM/yy' 'HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            
            guard let date = dateFormatter.date(from:string) else{ return nil}
            return date
        }
        
        for l in text.components(separatedBy: CharacterSet.newlines){
            let line = String(l)
            let m = regex.firstMatch(in: line, range: line.maxRange)
            if let m = m{
                let dateString = line.slice(range: m.range(at: 1))
                //                print(dateString)
                guard let date = stringToDate(String(dateString)) else{ continue }
//                print(date)
                
                let name = line.slice(range: m.range(at: 2)).trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
                let msgRange = m.range(at: 3)
                let msg = String(line.slice(range: msgRange))
                if !flaggedMessages.contains(msg){
                    
                    if !members.contains(where: {$0.key == name}){
                        members[name] = Member(memberName: name)
                    }
                    
                    members[name]!.addMsgTime(date)
                    
                    if let emojis = msg.getEmojis(){
                        members[name]!.addEmojis(newEmojis: emojis)
                    }
                }
                
                
            }
        }
        
        //        print(messages)
    }
    
}
