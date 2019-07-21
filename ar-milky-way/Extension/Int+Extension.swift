//
//  Int+Extension.swift
//  ar-milky-way
//
//  Created by Wendy Liga on 21/07/19.
//  Copyright © 2019 Wendy Liga. All rights reserved.
//

import struct UIKit.CGFloat

extension Int {
    func degreesToRadians() -> CGFloat {
        return CGFloat(self) * CGFloat.pi / 180
    }
}
