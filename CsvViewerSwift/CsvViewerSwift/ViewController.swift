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

    var coveringView:UIView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        roundLabel(elementi);
        roundLabel(colonne);
        roundLabel(numEl);
        roundLabel(numCol);
        roundLabel(filename);

        coveringView = UIView(frame: CGRectMake(self.graph.frame.origin.x, self.graph.frame.origin.y, self.graph.frame.size.width, self.graph.frame.size.height));
        coveringView.backgroundColor = UIColor.blackColor();
        coveringView.alpha=0.0;
        
        self.view.addSubview(coveringView);
        
        
//        coveringView = UIView  initWithFrame:CGRectMake(self.graphView.frame.origin.x
//            ,self.graphView.frame.origin.y
//            ,self.graphView.frame.size.width,self.graphView.frame.size.height)];
//        [coveringDrawView setBackgroundColor:[UIColor blackColor]];
//        [coveringDrawView setAlpha:0.0];
//        
//        [self.view addSubview:coveringDrawView];
//        
//        [UIView animateWithDuration:1 animations:^{
//            [coveringDrawView setAlpha:0.5];
//            }];

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func roundLabel(label:UILabel){
        label.backgroundColor=UIColor.clearColor();
        label.layer.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3).CGColor;
        label.layer.cornerRadius = 5;
        label.layer.borderWidth=1.0;
        label.layer.borderColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5).CGColor;
    }
    
    
}

