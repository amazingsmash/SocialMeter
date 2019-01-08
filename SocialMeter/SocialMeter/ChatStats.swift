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
    
}


class ChatStats{
    
    let text: String
    var messages : [String : Int] = [:]
    
    let flaggedMessages = ["imagen omitida",
                           "Los mensajes en este grupo ahora están protegidos con cifrado de extremo a extremo."]
    
    init(txtFile: URL){
        text = try! String(contentsOf: txtFile)
    }
    
    func analyze(){
        
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
                
            }
        }
        
        print(messages)
        
    }
    
}
