//
//  LoadingViewController.swift
//  Kitap
//
//  Created by Irmak Ozonay on 16.03.2021.
//

import UIKit

class LoadingViewController: UIViewController { //todo adi cok common

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    init() {
        super.init(nibName: "LoadingViewController", bundle: Bundle(for: LoadingViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func disable(){
        activityIndicator.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
