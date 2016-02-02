//
//  FilterHelper.swift
//  CustomSearchbar
//
//  Created by Howard on 1/24/16.
//  Copyright © 2016 Howard. All rights reserved.
//

import UIKit

class FilterHelper {
    
    var allWords = [String]()
    var filterWordsArray = [String]()
    
    init() {
        loadAllEnglishWordsFromTxtFile()
    }
    
    func loadAllEnglishWordsFromTxtFile() {
     
        let mainBundle = NSBundle.mainBundle()
        let arrList = mainBundle.pathsForResourcesOfType("txt", inDirectory: nil) as [String]
        
        if arrList.count > 0, let filterPath = arrList.first {
            
            do {
                let txtString: NSString = try NSString(contentsOfFile: filterPath, encoding: NSUTF8StringEncoding) as NSString
                allWords = txtString.componentsSeparatedByString("\n")
            } catch _ {
                print("Fail read englishwords from txt file.")
            }
        }
    }
    
    func filterContontFromTextField(text: String, scope: String = "All") {
        filterWordsArray = allWords.filter {
            word in
            
            return word.lowercaseString.hasPrefix(text.lowercaseString)

        }
    }
}
