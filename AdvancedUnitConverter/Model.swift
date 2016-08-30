//
//  Model.swift
//  AdvancedUnitConverter
//
//  Created by Aditya on 24/06/16.
//  Copyright © 2016 Aditya. All rights reserved.
//

import Foundation

class Model
{
    var unitsDictionary : NSMutableDictionary?
    var baseTypeDictionary : NSMutableDictionary?
    var newValuesDictionary : NSMutableDictionary? = [:]
    var unitsArray : [String]?
    var existingValueArray : [Double]?
    var existingKeyArray : [String]?
  
    let path = NSBundle.mainBundle().pathForResource("Conversions", ofType: "plist")
    
    func identifyBaseType(selectedCategory: String) -> String {
        let dict = NSMutableDictionary(contentsOfFile: path!)
        baseTypeDictionary = dict?.valueForKey("Base_Types") as? NSMutableDictionary
        return (baseTypeDictionary![selectedCategory] as? String)!
    }
    
    func convert(selectedCategory: String, inputData: Double, rowSelected: Int) -> NSMutableDictionary{
        let dict = NSMutableDictionary(contentsOfFile: path!)
        unitsDictionary = dict?.valueForKey(selectedCategory) as? NSMutableDictionary
        unitsArray = unitsDictionary?.allKeys as? [String]
        newValuesDictionary = unitsDictionary
        let baseType = identifyBaseType(selectedCategory)
        let existingUnit = unitsDictionary?.allKeys[rowSelected] as! String
        let existingValue = unitsDictionary?.allValues[rowSelected] as! Double
        //Value for seconds
        let existingValueInBaseType = inputData * existingValue
        newValuesDictionary?.setValue(round(100*existingValueInBaseType)/100, forKey: baseType)
        newValuesDictionary?.setValue(round(100*inputData)/100, forKey: existingUnit)
        
        for unit in unitsArray!{
            if unit != baseType && unit != existingUnit{
                let plistValue = unitsDictionary?.valueForKey(unit) as! Double
                newValuesDictionary?.setValue(round(100 * existingValueInBaseType/plistValue)/100, forKey : unit)
            }
        }
        return newValuesDictionary!
    }
    
    func convertTemperature(inputData: Double, rowSelected: Int) -> NSMutableDictionary{
        let dict = NSMutableDictionary(contentsOfFile: path!)
        unitsDictionary = dict?.valueForKey("Temperature") as? NSMutableDictionary
        existingValueArray = unitsDictionary?.allValues[rowSelected] as? Array
        existingKeyArray = unitsDictionary?.allKeys as? [String]
        
        let baseType = identifyBaseType("Temperature")
        let existingUnit = unitsDictionary?.allKeys[rowSelected] as! String
        //Value for Kelvin
        let existingValueInBaseType = (inputData + existingValueArray![1]) * existingValueArray![0]
        newValuesDictionary?.setValue(existingValueInBaseType, forKey: baseType)
        newValuesDictionary?.setValue(inputData, forKey: existingUnit)
        
        for unit in existingKeyArray!{
            if unit != baseType && unit != existingUnit{
                var plistValueArray = [Double]()
                plistValueArray = unitsDictionary?.valueForKey(unit) as! Array
                newValuesDictionary?.setValue(existingValueInBaseType/plistValueArray[0] - plistValueArray[1], forKey : unit)
            }
        }
        return newValuesDictionary!
    }

}