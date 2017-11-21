//
//  ARSCNView+Extensions.swift
//  ARuler
//
//  Created by Macbook on 17/11/2017.
//  Copyright © 2017 Lodge Farm Apps. All rights reserved.
//

import ARKit


extension ARSCNView {
     
     func worldVector(for position: CGPoint) -> SCNVector3? {
          
          let results = self.hitTest(position, types: [.featurePoint])
          guard let result = results.first else { return nil }
          return SCNVector3.positionFromTransform(result.worldTransform)
          
          
     }
     
     
     
     
}
