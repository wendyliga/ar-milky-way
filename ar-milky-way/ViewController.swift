//
//  ViewController.swift
//  ar-milky-way
//
//  Created by Wendy Liga on 14/07/19.
//  Copyright © 2019 Wendy Liga. All rights reserved.
//

import ARKit
import SceneKit
import UIKit

class ViewController: UIViewController, ARSCNViewDelegate {
    // MARK: - Outlet

    @IBOutlet var sceneView: ARSCNView!

    // MARK: - Node

    private var sun: SCNNode?
    private var mercury: SCNNode?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        sceneView.autoenablesDefaultLighting = true

        sceneView.debugOptions = [SCNDebugOptions.showCameras,
                                  SCNDebugOptions.showWorldOrigin,
                                  SCNDebugOptions.showFeaturePoints]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)

        drawSun()
        
        drawMercury()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    private func drawSun() {
        sun = SCNNode(geometry: SCNSphere(radius: 0.05))

        guard let sun = sun else { return }
        sun.position = SCNVector3(0, 0, 0)
        sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sun")

        sceneView.scene.rootNode.addChildNode(sun)
    }

    private func drawMercury() {
        mercury = SCNNode(geometry: SCNSphere(radius: 0.02))
        
        guard let mercury = mercury else {return}
        mercury.position = SCNVector3(0, 0.3, 0)
        mercury.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "mercury")
        
        sceneView.scene.rootNode.addChildNode(mercury)
    }

    // MARK: - ARSCNViewDelegate

    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
         let node = SCNNode()

         return node
     }
     */

    func session(_: ARSession, didFailWithError _: Error) {
        // Present an error message to the user
    }

    func sessionWasInterrupted(_: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }

    func sessionInterruptionEnded(_: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}
