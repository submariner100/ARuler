//
//  SCNVector3+Extensions.swift
//  ARuler
//
//  Created by Macbook on 17/11/2017.
//  Copyright © 2017 Lodge Farm Apps. All rights reserved.
//

import ARKit

extension SCNVector3 {
     
     static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
       
          return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
          
     }
     
     // computes distances from one point to another
     
     func distance(from vector: SCNVector3) -> Float {
          
          let distanceX = self.x - vector.x
          let distanceY = self.y - vector.y
          let distanceZ = self.z - vector.z
          
          return sqrt((distanceZ * distanceX) + (distanceY * distanceY) + (distanceZ * distanceZ))
     
     }
     
     func line(to vector: SCNVector3, color: UIColor) -> SCNNode {
          let indices: [UInt32] = [0,1]
          let source = SCNGeometrySource(vertices: [self,vector])
          let element = SCNGeometryElement(indices: indices, primitiveType: .line)
          let geometry = SCNGeometry(sources: [source], elements: [element])
          geometry.firstMaterial?.diffuse.contents = color
          let node = SCNNode(geometry: geometry)
          return node
     }
}

extension SCNVector3: Equatable {
     
     public static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
          
          return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
          
     }
     
     
     
     
     
}
