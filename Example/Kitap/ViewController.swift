//
//  ViewController.swift
//  Kitap
//
//  Created by 10302731 on 03/16/2021.
//  Copyright (c) 2021 10302731. All rights reserved.
//

import UIKit
import Kitap

class ViewController: UIViewController, ARTLabsDelegate {

    @IBOutlet weak var startARButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let log = Logger()
        log.printLog()
        ARTLabs.setApiKey("M3QGD6HHBNLRDZQMBP")
        ARTLabs.artlabs().delegate = self
//        ARTLabs.artlabs().setActiveView(self.view)
    }
    
    @IBAction func startAR(_ sender: UIButton){
//        sender.isEnabled = false
        ARTLabs.artlabs().startARSession(productSKU: "puma")
    }
    
    @IBAction func showAR(){
        ARTLabs.artlabs().getModelURL(productSKU: "puma", completion: {(modelUrl) in
            print("modelUrl: \(modelUrl)")
        })
//        ARTLabs.artlabs().presentAR()
    }
    
    func modelLoadStarted() {
        print("load started")
        startARButton.isEnabled = false
        activityIndicator.startAnimating()
    }
    
    func modelLoadFinished() {
        print("load finished")
        startARButton.isEnabled = true
        activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

