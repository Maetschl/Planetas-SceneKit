import SceneKit
import QuartzCore

class GameViewController: NSViewController {

    var scene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()

        let sunGeometry = SCNSphere(radius: 5)
        sunGeometry.materials.first?.diffuse.contents = NSColor.yellow
        let sunNode = SCNNode(geometry: sunGeometry)
        scene.rootNode.addChildNode(sunNode)

        let planetGeometry = SCNSphere(radius: 2)
        planetGeometry.materials.first?.diffuse.contents = NSColor.blue
        let planetNode = SCNNode(geometry: planetGeometry)
        planetNode.position.x += 12
        sunNode.addChildNode(planetNode)


        let moonGeometry = SCNSphere(radius: 0.5)
        moonGeometry.materials.first?.diffuse.contents = NSColor.lightGray
        let moonNode = SCNNode(geometry: moonGeometry)
        moonNode.position.x += 4
        planetNode.addChildNode(moonNode)


        let actionRotate = SCNAction.rotateBy(x: 0.0, y: .pi/5, z: 0.0, duration: 1.0)

        let rotateForever = SCNAction.repeatForever(actionRotate)
//
        planetNode.runAction(rotateForever)


        sunNode.runAction(rotateForever)


        moonNode.runAction(
            SCNAction.repeatForever(
                SCNAction.group([
                    SCNAction.wait(duration: 0.2),
                    SCNAction.customAction(duration: 0.0, action: { (_, _) in
                        let moonClone = moonNode.clone()
                        moonClone.removeAllActions()
                        moonClone.scale = SCNVector3(0.5, 0.5, 0.5)
                        self.scene.rootNode.addChildNode(moonClone)
                        moonClone.position = moonNode.worldPosition
                    })
                ])
            )
        )



    }

    func setupScene() {
        // create a new scene
        scene = SCNScene(named: "art.scnassets/scene.scn")!

        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)

        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)

        // retrieve the SCNView
        let scnView = self.view as! SCNView

        // set the scene to the view
        scnView.scene = scene

        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true

        // show statistics such as fps and timing information
        scnView.showsStatistics = true

        // configure the view
        scnView.backgroundColor = NSColor.black
    }

}
