//
//  CustomButton.swift
//  On The Map
//
//  Created by Erick Manrique on 4/30/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setButton()
    }
    func setButton(){
        layer.cornerRadius = 4.0
    }
    
    override func contentRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
}
