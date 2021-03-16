//
//  ViewController.swift
//  Kitap
//
//  Created by 10302731 on 03/16/2021.
//  Copyright (c) 2021 10302731. All rights reserved.
//

import UIKit
import Kitap

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let log = Logger()
        log.printLog()
        ARTLabs.setApiKey("M3QGD6HHBNLRDZQMBP")
    }
    
    @IBAction func startAR(_ sender: UIButton){
        sender.isEnabled = false
        ARTLabs.artlabs().startARSession(productSKU: "")
    }
    
    @IBAction func showAR(){
//        ARTLabs.artlabs().getModelURL(productSKU: "puma", completion: {(modelUrl) in
//            print("modelUrl: \(modelUrl)")
//        })
        ARTLabs.artlabs().presentAR()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

