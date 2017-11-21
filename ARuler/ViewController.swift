//
//  ViewController.swift
//  ARuler
//
//  Created by Macbook on 17/11/2017.
//  Copyright © 2017 Lodge Farm Apps. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

     @IBOutlet var sceneView: ARSCNView!
     @IBOutlet weak var infoLabel: UILabel!
     @IBOutlet weak var targetimageView: UIImageView!
     
     var session = ARSession()
     var configuration = ARWorldTrackingConfiguration()
     var isMeasuring = false
     var vectorZero = SCNVector3()
     var startVector = SCNVector3()
     var endVector = SCNVector3()
     var lines = [Line]()
     var currentLine: Line?
     var unit = LengthUnit.centimeter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        // Run the view's session
     session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    
     }
    
     override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        session.pause()
    }
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          if !isMeasuring {
               reset()
               isMeasuring = true
               targetimageView.image = UIImage(named: "GreenTarget")
          } else {
               isMeasuring = false
               targetimageView.image = UIImage(named: "WhiteTarget")
               
               if let line = currentLine {
                    lines.append(line)
                    currentLine = nil
               }
          }
     }
     
     func reset() {
          
          isMeasuring = false
          startVector = SCNVector3()
          endVector = SCNVector3()
     }
     
     func setup() {
          sceneView.delegate = self
          sceneView.session = session
          infoLabel.text = "Initailising the world..."
          targetimageView.image = UIImage(named: "WhiteTarget")
          
     }
     
     func scanWorld() {
          guard let worldPosition = sceneView.worldVector(for: view.center) else { return }
          if lines.isEmpty {
               infoLabel.text = "Tap to measure"
          }
          if isMeasuring {
               if startVector == vectorZero {
                    startVector = worldPosition
                    currentLine = Line(sceneView: sceneView, startVector: startVector, unit: unit)
               }
               endVector = worldPosition
               currentLine?.update(to: endVector)
               infoLabel.text = currentLine?.distance(to: endVector) ?? "..."
               
          }
     }
     
     func showActionSheet() {
          let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          let meterAction = UIAlertAction(title: "Meter", style: .default)
          { (action) in
               self.unit = .meter
          }
          
          let centimeterAction = UIAlertAction(title: "Centimeter", style: .default)
          { (action) in
               self.unit = .centimeter
          }
          
          let inchAction = UIAlertAction(title: "Inch", style: .default)
          { (action) in
               self.unit = .inch
          }
          
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          
               self.unit = .inch
          actionSheet.addAction(meterAction)
          actionSheet.addAction(centimeterAction)
          actionSheet.addAction(inchAction)
          actionSheet.addAction(cancelAction)
          present(actionSheet, animated: true, completion: nil)
          
     }
     
     @IBAction func resetButtonHandler(_ sender: UIButton) {
          for line in lines {
               line.remove()
          }
         lines.removeAll()
     }
     
     @IBAction func unitButtonHandler(_ sender: UIButton) {
          showActionSheet()
          
     }
  
     
}

extension ViewController: ARSCNViewDelegate {
     
     
     // Override to create and configure nodes for anchors added to the view's session.

     func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
          DispatchQueue.main.async {
               self.scanWorld()
          }
     }
     
     
     func session(_ session: ARSession, didFailWithError error: Error) {
          // Present an error message to the user
          infoLabel.text = "An error occurred"
          
     }
     
     func sessionWasInterrupted(_ session: ARSession) {
          // Inform the user that the session has been interrupted, for example, by presenting an overlay
          infoLabel.text = "Session was interrupted"
          
     }
     
     func sessionInterruptionEnded(_ session: ARSession) {
          // Reset tracking and/or remove existing anchors if consistent tracking is required
         infoLabel.text = "Session interruption ended"
     }

}
