//
//  ViewController.swift
//  OCWithSwift
//
//  Created by zhang759740844 on 07/05/2017.
//  Copyright (c) 2017 zhang759740844. All rights reserved.
//

import UIKit
import OCWithSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = OCFile().helloWorld();
        _ = SwiftFile().helloWorld();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

