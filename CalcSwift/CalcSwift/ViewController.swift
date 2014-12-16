//
//  ViewController.swift
//  CalcSwift
//
//  Created by System Administrator on 12/16/14.
//  Copyright (c) 2014 YeAPP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var LabelCalc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func cliccato(sender: AnyObject) {
        var name = sender.title as String!;
        switch (name){
        case "=":
            LabelCalc.text = name;
        case "+" :
            LabelCalc.text = name;
        case "-":
            LabelCalc.text = name;
        case "x":
            LabelCalc.text = name;
        case "/":
            LabelCalc.text = name;
        default:
            LabelCalc.text = LabelCalc.text! + 	name;
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

