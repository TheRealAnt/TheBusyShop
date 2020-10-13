//
//  ScannerVC.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/01.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation
import Vision
import AVFoundation
import UIKit
import Firebase

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  // MARK: - Variables
var didTapNoise: ((String) -> Void)?
  
  private var codes = [BarcodeMeta]()
  public var barcodes = [BarcodeMeta]()
  public var fruitCallback: ((String) -> ())?
  public var sendAttachmentCallback: (([BarcodeMeta]) -> Void)?
  var itemsForCartArray: [BarcodeMeta] = []

  //MARK:- Properties
  
  var barcode: BarcodeMeta?
  
    //MARK:- API
    
    func fetchUser() {
  //    BarcodeService.shared.fetchBarcode { (barcode) in
  //      print("DEBUG: Main tab barcode is \(barcode.description)" )
  //      self.barcode = barcode
  //    }
    }
    
    func authenticateUserAndConfigureUI() {
      if Auth.auth().currentUser == nil {
        print("DEBUG: User is NOT logged in...")
        handleLogin()
      } else {
         print("DEBUG: User IS logged in...")
        fetchUser()
      }
    }
    
    func logUserOut() {
      do {
        try Auth.auth().signOut()
      } catch let error {
        print("DEBUG: Failed to sin out with error \(error.localizedDescription)")
      }
    }
    
    func handleLogin() {
      let email = "techcheck@ikhokha.com"
      let password = "password"
      AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
        if let error = error {
          print("DEBUG: Error loggin in \(error.localizedDescription)")
          return
        }
        
        print("DEBUG: Successful login")
      }
      
    }
    
    func handleRegistration() {
      let credentials = AuthCredentials(email: "techcheck@ikhokha.com", password: "password")
      AuthService.shared.registerUser(credentials: credentials) { (error, ref) in
        print("DEBUG: Sign in successfull...")
      }
    }
  
  //MARK:- API
  
  func fetchBarcodes() {
    BarcodeService.shared.fetchBarcode { (barcodes) in
      self.codes = barcodes
    }
  }

  private var previewView: UIView!
  var captureSession: AVCaptureSession!
  var previewLayer: AVCaptureVideoPreviewLayer!
  var detectionOverlay: CALayer! = nil
  var rootLayer: CALayer! = nil
  var barcodeFrameView:CALayer?
  
  // MARK: - View Setup and Failure Support
  
  func setupNavBar() {
    title = "Scan"
    navigationController?.navigationBar.barTintColor = .yellow
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    let cartButtonItem = UIBarButtonItem(title: "Cart", style: .plain, target: self, action: #selector(cartButtonPressed))
    self.navigationItem.rightBarButtonItem  = cartButtonItem
  }

  @objc func cartButtonPressed() {
    let vc = CartVC()
    vc.arry = barcodes
     navigationController?.pushViewController(vc, animated: true)
  }
  
  func sendBarcode(barcode: String) {
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    authenticateUserAndConfigureUI()
    setupNavBar()
    fetchBarcodes()
    view.backgroundColor = UIColor.black
    captureSession = AVCaptureSession()
    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
    let videoInput: AVCaptureDeviceInput
    do {
      videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
    } catch {
      return
    }
    if (captureSession.canAddInput(videoInput)) {
      captureSession.addInput(videoInput)
    } else {
      unsupportedCamera()
      return
    }
    let metadataOutput = AVCaptureMetadataOutput()
    if (captureSession.canAddOutput(metadataOutput)) {
      captureSession.addOutput(metadataOutput)
      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .code128]
    } else {
      unsupportedCamera()
      return
    }
    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.layer.bounds
    previewLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(previewLayer)
    captureSession.startRunning()
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  func unsupportedCamera() {
    //            action taken if camera is un able to scan barcodes on device
    self.errorAlert(title: "Cannot Support Scanning", message: "Your device is un able to scan barcodes.")
    captureSession = nil
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if (captureSession?.isRunning == false) {
      captureSession.startRunning()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if (captureSession?.isRunning == true) {
      captureSession.stopRunning()
    }
  }
  
  // MARK: - Barcode Found
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    //            this is what happens when a bar code is successfully found
    captureSession.stopRunning()
    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
      guard let stringValue = readableObject.stringValue else { return }
      createBox(metadataObject: metadataObject)
      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
      self.createAlert(title: "Barcode Scanned", message: "the barcode: \(stringValue)", barcode: stringValue)
    }
  }
  
  func createBox(metadataObject: AVMetadataObject) {
    //        this creates the green box that surrounds successful barcode scans
    barcodeFrameView = CALayer()
    if let barcodeFrameView = barcodeFrameView {
      barcodeFrameView.borderColor = UIColor.green.cgColor
      barcodeFrameView.borderWidth = 5
      barcodeFrameView.cornerRadius = 7
      self.view.layer.addSublayer(barcodeFrameView)
    }
    let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObject)
    barcodeFrameView?.frame = barCodeObject!.bounds
    barcodeFrameView?.frame.origin.y = (barcodeFrameView?.frame.origin.y)! - (barcodeFrameView?.frame.width)!/3
    barcodeFrameView?.frame.size.height = 2/3*(barcodeFrameView?.frame.width)!
  }
  
  // MARK: - Alerts and barcodeFound()
  
  func createAlert(title: String, message: String, barcode: String) {
    //        displays an alert to the user when barcode is found
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let saveAction = UIAlertAction(title: "Okay", style: .default, handler: { alert -> Void in
      self.barcodeFound(barcode: barcode)
      self.view.layer.sublayers?.removeLast()
      self.captureSession.startRunning()
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
      (action : UIAlertAction!) -> Void in
      self.view.layer.sublayers?.removeLast()
      self.captureSession.startRunning()
    })
    alertController.addAction(cancelAction)
    alertController.addAction(saveAction)
    alertController.preferredAction = saveAction
    self.present(alertController, animated: true, completion: nil)
  }
  
  func errorAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Okay", style: .default))
    present(alertController, animated: true)
  }
  
  func barcodeFound(barcode: String){
    //        this is where you put any code you want excecuted once a barcode is found and "Okay" is selected
    
    for barcode1 in codes {
      if(barcode.elementsEqual(barcode1.uid)){
        barcodes.append(barcode1)
      }
    }
  }
  
  public var sendBarcodesCallback: ((String) -> Void)?
  

}




