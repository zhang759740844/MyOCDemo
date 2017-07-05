//
//  Target_A.swift
//  A_swift
//
//  Created by casa on 2017/1/4.
//  Copyright © 2017年 casa. All rights reserved.
//

import UIKit

@objc(Target_A)
open class Target_A: NSObject {

    open func Action_viewController(params:NSDictionary) -> UIViewController {
        let aViewController = ViewController()
        return aViewController
    }

}
