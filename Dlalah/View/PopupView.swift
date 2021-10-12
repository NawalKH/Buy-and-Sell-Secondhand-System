//
//  PopupView.swift
//  Dlalah
//
//  Created by Nawal Kh on 2/29/1439 AH.
//  Copyright © 1439 Lama Alashed. All rights reserved.
//

import UIKit

@IBDesignable class PopupView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }

}
