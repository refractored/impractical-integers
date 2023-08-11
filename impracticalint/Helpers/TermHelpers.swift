//
//  TermHelpers.swift
//  impracticalint
//
//  Created by David G on 8/11/23.
//

import Foundation

struct equationInfo{
    var terms: [Int]
    var answer: Int
    var displayText: String
}

func equationShuffle(termCount: Int) -> equationInfo{
    var temp = equationInfo(terms: [Int](), answer: 0, displayText: "")
    
    // Generate terms with given number from paramaters (termCount).
    while temp.terms.count < termCount{
        temp.terms.append(Int.random(in: -20 ... 20))
    }
    
    for i in 0..<termCount {
        let isAddition = Bool.random()
        let term = temp.terms[i]
        
        // Looks less confusing with bigger equations.
        let displayterm = term < 0 ? "(\(term))" : "\(term)"
        
        // Run operations required to get the new answer if text is not empty.
        if !temp.displayText.isEmpty{
            if isAddition{
                temp.answer += term
                temp.displayText += " + \(displayterm)"
            }else{
                temp.answer -= term
                temp.displayText += " - \(displayterm)"
            }
        }
            
        // Check if this is the first term, if so, make it equal to answer
        // Without this check in place, Subtracting a negative number from the default value 0, will make it positive. Ex: f(-3) = 0 - (-3) = 3
        
        if temp.displayText.isEmpty{
            temp.answer = term
            temp.displayText += "\(displayterm  )"
        }
        
        

    }
        print("\(temp.answer)")
        return temp
}
