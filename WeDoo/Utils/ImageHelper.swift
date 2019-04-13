//
//  ImageHelper.swift
//  WeDoo
//
//  Created by Mateus Augusto Stedler on 13/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import Foundation
import UIKit
class ImageHelper {
    static func scaled(named : String, width : Int, height: Int) -> UIImage {
        return (UIImage(named: named)?.af_imageScaled(to: CGSize(width: width, height: height)))!
    }
}
