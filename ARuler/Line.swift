//
//  Line.swift
//  ARuler
//
//  Created by Macbook on 17/11/2017.
//  Copyright © 2017 Lodge Farm Apps. All rights reserved.
//

import ARKit

enum LengthUnit {
     
     case meter, centimeter, inch
     
     var factor: Float {
          switch self {
          case .meter:
               return 1.0
          case .centimeter:
               return 100.0
          case .inch:
               return 39.3700787
          }
     }
     
     var name: String {
          switch self {
          case .meter:
               return "m"
          case .centimeter:
               return "cm"
          case .inch:
               return "inch"
          }
     }
}

class Line {
     
     var color = UIColor.orange
     
     var startNode: SCNNode
     var endNode: SCNNode
     var text: SCNText
     var textNode: SCNNode
     var lineNode: SCNNode?
     
     let sceneView: ARSCNView
     let startVector: SCNVector3
     let unit: LengthUnit
     
     init(sceneView: ARSCNView, startVector: SCNVector3, unit: LengthUnit) {
          self.sceneView = sceneView
          self.startVector = startVector
          self.unit = unit
          
          let dot = SCNSphere(radius: 0.5)
          dot.firstMaterial?.diffuse.contents = color
          dot.firstMaterial?.lightingModel = .constant
          dot.firstMaterial?.isDoubleSided = true
          
          startNode = SCNNode(geometry: dot)
          startNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
          startNode.position = startVector
          sceneView.scene.rootNode.addChildNode(startNode)
          
          endNode = SCNNode(geometry: dot)
          endNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
          
          text = SCNText(string: "", extrusionDepth: 0.1)
          text.font = .systemFont(ofSize: 5)
          text.firstMaterial?.diffuse.contents = color
          text.firstMaterial?.isDoubleSided = true
          text.alignmentMode = kCAAlignmentCenter
          text.truncationMode = kCATruncationMiddle
          
          let textWrapperNode = SCNNode(geometry: text)
          textWrapperNode.eulerAngles = SCNVector3Make(0, .pi, 0)
          textWrapperNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
          
          textNode = SCNNode()
          textNode.addChildNode(textWrapperNode)
          let constraint = SCNLookAtConstraint(target: sceneView.pointOfView)
          constraint.isGimbalLockEnabled = true
          textNode.constraints = [constraint]
          sceneView.scene.rootNode.addChildNode(textNode)
          
     }
     
     func update(to vector: SCNVector3) {
          lineNode?.removeFromParentNode()
          
          lineNode = startVector.line(to: vector, color: color)
          sceneView.scene.rootNode.addChildNode(lineNode!)
          
          text.string = distance(to: vector)
          textNode.position = SCNVector3((startVector.x + vector.x)/2.0, (startVector.y + vector.y)/2.0, (startVector.z + vector.z)/2.0)
          endNode.position = vector
          if endNode.parent == nil {
               sceneView.scene.rootNode.addChildNode(endNode)
          }
          
          
     }
     
     func distance(to vector: SCNVector3) -> String {
          return String(format: "%.2f%@", startVector.distance(from: vector)*unit.factor, unit.name)
          
     }
     
     func remove() {
          startNode.removeFromParentNode()
          endNode.removeFromParentNode()
          textNode.removeFromParentNode()
          lineNode?.removeFromParentNode()
          
          
     }
     
   
}
