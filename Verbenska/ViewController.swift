//
//  ViewController.swift
//  noderavverb
//
//  Created by Sidney P'Silva on 07/09/18.
//  Copyright © 2018 Vlad Lopes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bttSpelaOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bttSpelaOut.layer.cornerRadius = 7
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func bttSpela(_ sender: Any) {
        performSegue(withIdentifier: "segueGrupp", sender: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

