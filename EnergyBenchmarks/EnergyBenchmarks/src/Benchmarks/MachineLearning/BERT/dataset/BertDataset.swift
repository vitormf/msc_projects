//
//  BertDataset.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 15/11/2023.
//

import Foundation

struct BertDatasetQuestion {
    var question:String
    var answers = [String]()
}

struct BertDatasetText {
    var context:String
    var questions = [BertDatasetQuestion]()
}

class BertDataset {
    
    var texts = [BertDatasetText]()
    var parsed = false
    
    public func parse() {
        if !parsed {
            parsed = true
            if let path = Bundle.main.path(forResource: "bert-train-v2.0", ofType: "json")
            {
                if let jsonData = try? Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
                {
                    
                    if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? NSDictionary,
                    let data = json["data"] as? NSArray {
                        
                        for (i,_) in data.enumerated() {
                            let d = data[i] as! NSDictionary
                            let paragraphs = d["paragraphs"] as! NSArray
                            for (j,_) in paragraphs.enumerated() {
                                let p = paragraphs[j] as! NSDictionary
                                
                                let context = p["context"] as! String
                                var bertText = BertDatasetText(context: context)
                                
                                let qas = p["qas"] as! NSArray
                                for (k,_) in qas.enumerated() {
                                    let q = qas[k] as! NSDictionary
                                    let question = q["question"] as! String
                                    var bertQuestion = BertDatasetQuestion(question: question)
                                    
                                    let answers = q["answers"] as! NSArray
                                    for (l,_) in answers.enumerated() {
                                        let a = answers[l] as! NSDictionary
                                        let answer = a["text"] as! String
                                        bertQuestion.answers.append(answer)
                                    }
                                    bertText.questions.append(bertQuestion)
                                }
                                
                                texts.append(bertText)
                            }
                        }
                        
                        
                    }
                        
                }
                
             }
        }
        
    }
}
