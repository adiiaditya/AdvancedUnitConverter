
//
//  DetailViewController.swift
//  AdvancedUnitConverter
//
//  Created by Aditya on 11/06/16.
//  Copyright © 2016 Aditya. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var unitTableView: UITableView!
    
    var model = Model()
    var selectedCategory: String?
    var newValuesDictionary : NSDictionary?
    
    var keys = [String]()
    var values = [Double]()
    
    var dictionaryPretty:NSDictionary?
    var dictionaryPlural:NSDictionary?
    var prettyStrings = [String]()
    var standardStrings = [String]()
    var prettyKeys:NSDictionary?

    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = detailItem?.description
        selectedCategory = (detailItem?.description)!
        let path = NSBundle.mainBundle().pathForResource("Conversions", ofType: "plist")
        let dict = NSMutableDictionary(contentsOfFile: path!)
        newValuesDictionary = dict!.objectForKey(selectedCategory!) as? NSDictionary
        //values = newValuesDictionary?.allValues as! [Double]
        values = Array(count: (newValuesDictionary?.count)!, repeatedValue: 0.0)
        keys = newValuesDictionary?.allKeys as! [String]
        dictionaryPretty = dict!.objectForKey("PrettyBindings") as? NSDictionary
        dictionaryPlural = dictionaryPretty?.valueForKey(selectedCategory!) as? NSDictionary
        prettyStrings = dictionaryPlural?.allValues as! [String]
        standardStrings = dictionaryPlural?.allKeys as! [String]
    }
    
    func prettyLoad(sender: Int){
        for i in 0..<(newValuesDictionary?.count)!{
            let value = newValuesDictionary?.allValues[i] as! Double
            if value > 1.0
            {
                if keys[i] == prettyStrings[i]
                {
                    keys[i] = keys[i]
                }
                else {
                    keys[i] = prettyStrings[i]
                }
            }
            else{
                keys[i] = standardStrings[i]
            
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unitTextFieldEditingChanged(sender: AnyObject) {
        
        if(sender.text != "")
        {
            switch selectedCategory! {
            case "Time", "Length", "Area", "Volume":
                newValuesDictionary = model.convert(selectedCategory!, inputData: Double(sender.text!)!, rowSelected: sender.tag)
                values = newValuesDictionary?.allValues as! [Double]
                prettyLoad(sender.tag)
            case "Temperature":
                newValuesDictionary = model.convertTemperature(Double(sender.text!)!, rowSelected: sender.tag)
                values = newValuesDictionary?.allValues as! [Double]
                prettyLoad(sender.tag)
            default:
                break;
            }
        }
        
        let indexPath = unitTableView.indexPathForCell(sender.superview!!.superview as! UITableViewCell)
        var cells = unitTableView.indexPathsForVisibleRows!
        cells.removeAtIndex(indexPath!.row)
        unitTableView.reloadRowsAtIndexPaths(cells, withRowAnimation: .Automatic)
    }
    
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (newValuesDictionary?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UnitTableViewCell = self.unitTableView.dequeueReusableCellWithIdentifier("cell") as! UnitTableViewCell
        cell.unitLabel?.text = keys[indexPath.row]
        cell.unitTextField?.text = String(values[indexPath.row])
        cell.unitTextField?.tag = indexPath.row
        return cell
    }
    
    //This function is used to dismiss the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class UnitTableViewCell : UITableViewCell {
    @IBOutlet var unitLabel: UILabel!
    //This code snippet is used to set the keyboard type to decimal pad
    @IBOutlet var unitTextField: UITextField!{
        didSet{
            unitTextField.keyboardType = UIKeyboardType.DecimalPad
        }
    }
}