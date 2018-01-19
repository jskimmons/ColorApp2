//
//  ViewController.swift
//  CVTest
//
//  Created by Joseph Skimmons on 5/23/17.
//  Copyright © 2017 Joseph Skimmons. All rights reserved.
//  Collect Software

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var statusLabel: UILabel!
//    @IBOutlet var the_test_label: UIView!
    
    @IBOutlet weak var objLabel: UILabel!

    @IBOutlet weak var previewImg: UIView!
    
    let captureSession = AVCaptureSession()
//    var previewLayer:CALayer!
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureDevice:AVCaptureDevice!
    
    var takePhoto = false
    
    var colorName = ""
    
    //var photoVC:PhotoViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            //menuButton.target = self.revealViewController()
            //menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        _ = OpenCVWrapper()
        
        pickColor()
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: name)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
         */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCamera()
        self.statusLabel.text = ""
    }
    
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        if let availableDevices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .back).devices {
            captureDevice = availableDevices.first
            beginSession()
        }
        
    }
    
    func beginSession () {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(captureDeviceInput)
            
        }catch {
            print(error.localizedDescription)
        }
        
        
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
            self.previewLayer = previewLayer
            self.previewImg.layer.addSublayer(self.previewLayer!)
//            self.previewImg.layer.layoutManager = CAConstraintLayoutManager.layoutManager();
//            self.previewImg.layer.addConstraint(CAConstraint.constraintWithAttribute(CAConstraintAttribute.MinX, relativeTo: self.previewImg.layer, attribute: CAConstraintAttribute.MinX, scale: 1, offset: 0));
//            self.previewImg.layer.addConstraint(CAConstraint.constraintWithAttribute(CAConstraintAttribute.MaxX, relativeTo: self.previewImg.layer, attribute: CAConstraintAttribute.MaxX, scale: 1, offset: 0));
//            self.previewImg.layer.addConstraint(CAConstraint.constraintWithAttribute(CAConstraintAttribute.Width, relativeTo: self.previewImg.layer, attribute: CAConstraintAttribute.Width, scale: 1, offset: 0));
//            self.previewImg.layer.addConstraint(CAConstraint.constraintWithAttribute(CAConstraintAttribute.Height, relativeTo: self.previewImg.layer, attribute: CAConstraintAttribute.Height, scale: 1, offset: 0));
            self.previewLayer?.frame = self.previewImg.layer.frame
            captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)]
            
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            
            captureSession.commitConfiguration()
            
            
            let queue = DispatchQueue(label: "com.brianadvent.captureQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
            
            
        }
        
    }
    
    @IBAction func camBtn(_ sender: Any) {
        takePhoto = true
        
    }
    
    @IBAction func skipBtn(_ sender: Any) {
        pickColor()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {

        
        if takePhoto {
            takePhoto = false
            
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                
                // method that takes in image and returns the result (if blue etc)
//                let _ = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                
                let kanye = OpenCVWrapper()
                if (kanye.checkColorImg(image)) {
                    
                    DispatchQueue.main.async {
                        self.statusLabel.text = "Nice!"
                        self.statusLabel.textColor = UIColor.green
                    }
                    pickColor()
                    
                }
                else{
                    DispatchQueue.main.async {
                        self.statusLabel.text = "Try Again!"
                        self.statusLabel.textColor = UIColor.red
                    }
                }
                
                
                let img = kanye.testImg(image)
                UIImageWriteToSavedPhotosAlbum(img!, nil, nil, nil);
            
 
            }
            
            
        }
    }
    
    
    func getImageFromSampleBuffer (buffer:CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
            
        }
        
        return nil
    }
    
    func stopCaptureSession () {
        self.captureSession.stopRunning()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickColor() {
        let rand = randomInt(min: 0, max: 3)
        let jcole = OpenCVWrapper()
        switch(rand){
            case 0:
                colorName =  "red"
                DispatchQueue.main.async {
                    self.objLabel.text = "Find " + self.colorName
                    //self.objLabel.textColor = UIColor.red
                }
                jcole.getCVScalar(0)
            
            
            case 1:
                colorName =  "blue"
                DispatchQueue.main.async {
                    self.objLabel.text = "Find " + self.colorName
                    //self.objLabel.textColor = UIColor.blue
                    
                }
                jcole.getCVScalar(1)
            case 2:
                colorName =  "green"
                DispatchQueue.main.async {
                    self.objLabel.text = "Find " + self.colorName
                    //self.objLabel.textColor = UIColor.blue
                    
                }
                jcole.getCVScalar(2)
        case 3:
            colorName =  "yellow"
            DispatchQueue.main.async {
                self.objLabel.text = "Find " + self.colorName
                //self.objLabel.textColor = UIColor.blue
                
            }
            jcole.getCVScalar(3)
            default:
                colorName = "ERROR"
        }
        
//        let alert = UIAlertController(title: "Objective", message: "Find " + colorName, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Begin", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
}
