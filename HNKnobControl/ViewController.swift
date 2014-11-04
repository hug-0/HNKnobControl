//
//  ViewController.swift
//  HNKnobControl
//
//  Created by Hugo Nordell on 10/25/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HNImageViewDelegate {

    // Knob image
    var knobImage: HNImageView!
    var knobImage2: HNImageView!
    
    // Label
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        knobImage = HNImageView(image: UIImage(named: "Button"), minAngle: -45.0, maxAngle: 90.0)
        knobImage.frame = CGRectMake(view.bounds.size.width/2, view.bounds.size.height/2, 75, 75)
        knobImage.delegate = self
        view.addSubview(knobImage)
        
        knobImage2 = HNImageView(image: UIImage(named: "Button"))
        knobImage2.frame = CGRectMake(25, view.bounds.size.height/2, 75, 75)
        knobImage2.delegate = self
        view.addSubview(knobImage2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Protocol
    func didChangeAngle(sender: HNImageView) {
        switch sender {
        case knobImage:
            self.label.text = "\(self.knobImage.imageAngle)"
        case knobImage2:
            self.label2.text = "\(self.knobImage2.imageAngle)"
        default:
            break
        }
    }
}

