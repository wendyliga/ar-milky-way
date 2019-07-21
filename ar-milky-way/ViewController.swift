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

struct Planet {
    let name: String
    let diameter: CGFloat
    let distance: SCNVector3
    let skin: UIImage?
    let angle: SCNVector3
    let rotationSpeed: Double
    let planetAccessory: [Accessory]

    struct Accessory {
        let name: String
        let node: SCNNode
        let distance: SCNVector3
        let skin: UIImage?
        let angle: SCNVector3
    }
}

class ViewController: UIViewController, ARSCNViewDelegate {
    // MARK: - Values

    /// default sun position
    private let sunPosition = SCNVector3(0, 0, 0)

    /// our planet data
    private var planets: [Planet] {
        let mercury = Planet(name: "Mercury",
                             diameter: 0.01,
                             distance: SCNVector3(0.3, 0, 0),
                             skin: UIImage(named: "mercury"),
                             angle: SCNVector3(0, 0, 0),
                             rotationSpeed: 2.932,
                             planetAccessory: [])

        let venus = Planet(name: "Venus",
                           diameter: 0.019,
                           distance: SCNVector3(0.4, 0, 0),
                           skin: UIImage(named: "venus"),
                           angle: SCNVector3(0, 0, 0),
                           rotationSpeed: 7.49,
                           planetAccessory: [])

        let earth = Planet(name: "Earth",
                           diameter: 0.019,
                           distance: SCNVector3(0.5, 0, 0),
                           skin: UIImage(named: "earth"),
                           angle: SCNVector3(0, 23.degreesToRadians(), 0),
                           rotationSpeed: 12.16666,
                           planetAccessory: [])

        let mars = Planet(name: "Mars",
                          diameter: 0.015,
                          distance: SCNVector3(0.66, 0, 0),
                          skin: UIImage(named: "mars"),
                          angle: SCNVector3(0, 0, 0),
                          rotationSpeed: 22.297,
                          planetAccessory: [])

        let jupiter = Planet(name: "Jupiter",
                             diameter: 0.075,
                             distance: SCNVector3(0.84, 0, 0),
                             skin: UIImage(named: "jupiter"),
                             angle: SCNVector3(0, 0, 0),
                             rotationSpeed: 144.333,
                             planetAccessory: [])

        let saturnRing = Planet.Accessory(name: "Rings of Saturn",
                                          node: SCNNode(geometry: SCNTorus(ringRadius: 0.1, pipeRadius: 0.01)),
                                          distance: SCNVector3(0.1, 0, 0),
                                          skin: UIImage(named: "saturn_ring"),
                                          angle: SCNVector3(65.degreesToRadians(), 0, 0))

        let saturn = Planet(name: "Saturn",
                            diameter: 0.069,
                            distance: SCNVector3(1.2, 0, 0),
                            skin: UIImage(named: "saturn"),
                            angle: SCNVector3(0, 0, 0),
                            rotationSpeed: 358.5,
                            planetAccessory: [saturnRing])

        let uranus = Planet(name: "Uranus",
                            diameter: 0.055,
                            distance: SCNVector3(1.5, 0, 0),
                            skin: UIImage(named: "uranus"),
                            angle: SCNVector3(0, 0, 0),
                            rotationSpeed: 1022.9,
                            planetAccessory: [])

        let neptune = Planet(name: "Neptune",
                             diameter: 0.053,
                             distance: SCNVector3(1.8, 0, 0),
                             skin: UIImage(named: "neptune"),
                             angle: SCNVector3(0, 0, 0),
                             rotationSpeed: 3017.333333,
                             planetAccessory: [])

        return [mercury, venus, earth, mars, jupiter, saturn, uranus, neptune]
    }

    // MARK: - Outlet

    @IBOutlet var sceneView: ARSCNView!

    // MARK: - Node

    private lazy var sun: SCNNode = { [sunPosition] in
        let sun = SCNNode(geometry: SCNSphere(radius: 0.15))
        sun.position = sunPosition
        sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sun")

        return sun
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        sceneView.autoenablesDefaultLighting = true

        sceneView.debugOptions = [SCNDebugOptions.showWorldOrigin]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // render all the scene in background thread to minimize lag at startup of the app
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let `self` = self else { return }

            // add sun to rootNode
            self.sceneView.scene.rootNode.addChildNode(self.sun)

            // create our planet based on data
            self.planets.forEach { planet in
                // create planet axis to be startpoint of the planet
                let planetAxis = SCNNode(geometry: SCNPlane(width: 0, height: 0))
                planetAxis.position = self.sunPosition

                // planet node
                let planetNode = SCNNode(geometry: SCNSphere(radius: planet.diameter))
                planetNode.position = planetAxis.position.append(planet.distance)
                planetNode.eulerAngles = planet.angle
                planetNode.geometry?.firstMaterial?.diffuse.contents = planet.skin

                // planet accessory node
                for accessory in planet.planetAccessory {
                    let node = accessory.node
                    node.geometry?.firstMaterial?.diffuse.contents = accessory.skin
                    node.eulerAngles = accessory.angle

                    planetNode.addChildNode(node)
                }

                planetAxis.addChildNode(planetNode)

                // planet orbit
                let orbit = SCNNode(geometry: SCNTorus(ringRadius: CGFloat(planetNode.position.x), pipeRadius: 0.001))
                orbit.position.y = planetNode.position.y
                orbit.position.z = planetNode.position.z
                orbit.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                orbit.opacity = 0.5

                planetAxis.addChildNode(orbit)

                // planet rotate action
                let planetRotateAction = SCNAction.rotate(by: 360.degreesToRadians(), around: SCNVector3(0, 1, 0), duration: planet.rotationSpeed)
                let rotateForever = SCNAction.repeatForever(planetRotateAction)
                planetAxis.runAction(rotateForever)

                self.sceneView.scene.rootNode.addChildNode(planetAxis)
            }

            // make sure running the session on main thread
            DispatchQueue.main.async {
                // Run the view's session
                self.sceneView.session.run(configuration)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }
}
