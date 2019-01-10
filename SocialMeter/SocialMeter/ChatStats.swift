//
//  ChatStats.swift
//  SocialMeter
//
//  Created by Jose Miguel S N on 08/01/2019.
//  Copyright © 2019 Jose Miguel S N. All rights reserved.
//

import Foundation

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
    
}

protocol ChatStatsObserver {
    func onChatStatsChanged(chatStats: ChatStats)
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

    let text: String
    var messages : [String : Int] = [:]
    var emojiCount : [UnicodeScalar : Int] = [:]
    
    let flaggedMessages = ["imagen omitida",
                           "Los mensajes en este grupo ahora están protegidos con cifrado de extremo a extremo."]
    
    init(txtFile: URL){
        text = try! String(contentsOf: txtFile)
        analyze()
    }
    
    private func analyze(){
        
        let regex = try! NSRegularExpression(pattern: "\\[.+/.+/.+ .+\\] ([^:]*): (.*)", options: .caseInsensitive)
        
        for l in text.components(separatedBy: CharacterSet.newlines){
            let line = String(l)
            let m = regex.firstMatch(in: line, range: line.maxRange)
            if let m = m{
//                print(m.range)
                let nameRange = m.range(at: 1)
                let name = line.slice(range: nameRange).trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
                
                let msgRange = m.range(at: 2)
                let msg = String(line.slice(range: msgRange))
                if !flaggedMessages.contains(msg){
                    if let x = messages[name]{
                        messages[name] = x + 1
                    }else{
                        messages[name] = 1
                    }
                }
                
                if let emojis = msg.getEmojis(){
                    
                    for e in emojis.unicodeScalars{
                        let val : Int = (emojiCount[e] ?? 0)!
                        emojiCount[e] = val + 1
                    }
//                    print(emojis)
                }
                
            }
        }
        
        print(messages)
        
        for e in emojiCount.sorted(by: {$0.value < $1.value}){
            print("\(Character(e.key)) : \(e.value) ")
        }
        
    }
    
}
