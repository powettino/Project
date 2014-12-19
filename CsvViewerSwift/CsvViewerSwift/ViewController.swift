//
//  ViewController.swift
//  CsvViewerSwift
//
//  Created by Iacopo Peri on 19/12/14.
//  Copyright (c) 2014 Iacopo Peri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var elementi: UILabel!
    @IBOutlet weak var colonne: UILabel!
    @IBOutlet weak var numEl: UILabel!
    @IBOutlet weak var numCol: UILabel!
    @IBOutlet weak var filename: UILabel!
    
    @IBOutlet weak var graph: UIView!
    let x = [1,2,3,4,5,6];
    let y = [1,2,3,4,5,6];
    
    var filePath:String? = "/Users/iacopo.peri/workspace/Project/CsvViewerSwift/CsvViewerSwift/punti.csv";
    
    @IBOutlet weak var tempor: UILabel!
    var coveringView:UIView!;
    
    var premuto:Bool = false;
    
    @IBAction func premuto(sender: AnyObject) {
        if(!premuto){
            
            filename.text=filePath!;
            
            if let data = splitData(splitLines(loadDati())) {
                var somma = 0;
                for (val1, val2) in data {
                    tempor.text = tempor.text! + "\n" + val1 + " - " + val2;
                    somma += val2.toInt()!;
                }
                
                colonne.text = String(data.count);
                elementi.text = String(somma);
            }
            
            UIView.animateWithDuration(0.8, animations: {self.coveringView.alpha=0.0;  self.roundElement(self.graph); });
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        roundElement(elementi);
        roundElement(colonne);
        roundElement(numEl);
        roundElement(numCol);
        roundElement(filename);
        
        coveringView = UIView(frame: CGRectMake(0, 0, self.graph.frame.size.width, self.graph.frame.size.height));
        coveringView.backgroundColor = UIColor.blackColor();
        coveringView.alpha=0.0;
        
        self.graph.addSubview(coveringView);
        
        UIView.animateWithDuration(0.8, animations: {self.coveringView.alpha=0.5;});
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func splitData(lines:[String]?)->[(String,String)]?{
        if let values = lines {
            var array:[(String, String)]=[(String, String)]();
            for line in values {
                array.append(line.componentsSeparatedByString(",")[0], line.componentsSeparatedByString(",")[1]);
            }
            return array;
        }
        return nil;
    }
    
    func splitLines(loading:String?)->[String]?{
        if let lines = loading {
            return lines.componentsSeparatedByString("\n");
        }
        return nil;
    }
    
    func roundElement(label:UIView){
        label.backgroundColor=UIColor.clearColor();
        label.layer.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3).CGColor;
        label.layer.cornerRadius = 5;
        label.layer.borderWidth=1.0;
        label.layer.borderColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5).CGColor;
    }
    
    func loadDati()->String?->[String]?{
        if let fp = self.filePath {
            var lines = NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: nil);
            return splitLines();
        }
        return nil;
    }
    
    
}

