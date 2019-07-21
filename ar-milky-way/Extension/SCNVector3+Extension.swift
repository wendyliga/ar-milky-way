//
//  SCNVector3+Extension.swift
//  ar-milky-way
//
//  Created by Wendy Liga on 20/07/19.
//  Copyright © 2019 Wendy Liga. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    // Extend the "+" operator so that it can add two SCNVector3s together.
    func append(_ vector: SCNVector3) -> SCNVector3 {
        return SCNVector3(x + vector.x,
                          y + vector.y,
                          z + vector.z)
    }
}
