//
//  ScannerVC.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/01.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Firebase

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //MARK:- Properties
    public var codesFromAPI = [BarcodeMeta]() // holds all barcodes keys and values from API.
    private var barcodeData = [BarcodeMeta]() // holds every item a user scanned, unfiltered.
    public var newBarcodesCount = [BarcodeMeta]() // holds filtered barcodes with itemCount.
    public var barcodeDataForCart = [BarcodeMeta]() //holds filtered barcodes to use in cartVC.
    private var barcodeCountForCart = [Int]() // holds only itemCount numbers.
    
    private var previewView: UIView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var detectionOverlay: CALayer! = nil
    var rootLayer: CALayer! = nil
    var barcodeFrameView:CALayer?
    
    // MARK: - View Setup and Failure Support
    
    func setupNavBar() {
        title = "Scan"
        navigationController?.navigationBar.barTintColor = Colour.ikYellow
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        let cartButtonItem = UIBarButtonItem(title: "Cart", style: .plain, target: self, action: #selector(cartButtonPressed))
        self.navigationItem.rightBarButtonItem  = cartButtonItem
    }
    
    @objc func cartButtonPressed() {
        let vc = CartVC()
        vc.cartVCBarcodeItems = newBarcodesCount //passing the customized array to our cartVC
        vc.cartVCBarcodeItemsPrices = barcodeDataForCart
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // action taken if camera is un able to scan barcodes on device
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
        // this is what happens when a bar code is successfully found
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
        // this creates the green box that surrounds successful barcode scans
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
        // displays an alert to the user when barcode is found
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
        // this is where you put any code you want excecuted once a barcode is found and "Okay" is selected
        
        // 1. loop through barcodes the API is holding and find a match with scanned barcode.
        for data in codesFromAPI {
            if(barcode.elementsEqual(data.uid)){
                // 2. find matching uids by comparing user scanned codes to codesFromAPI uids.
                let duplicateBarcode = barcodeData.filter { $0.uid == data.uid }.count + 1
                
                //print("DEBUG: ", barcodeCountForCart, barcodeDataForCart)
                // 3. If the duplicate count is 1, we just add to the array we want to send to the cartVC.
                
                if (duplicateBarcode == 1) {
                    newBarcodesCount.append(data)
                    barcodeCountForCart.append(duplicateBarcode)
                    barcodeDataForCart.append(data)
                    guard let itemIndex = barcodeDataForCart.firstIndex(of: data) else { return } //holding index of the matching items, so it's the same index positioning set in all our other created arrays we created and are using.
                    newBarcodesCount[itemIndex].itemCount = duplicateBarcode
                    //print("DEBUG: count for each fruit duplicate: ", barcodeCountForCart)
                    
                } else {
                    guard let itemIndex = barcodeDataForCart.firstIndex(of: data) else { return }
                    //4. Update the barcodeCountForCart array index number by +1, and set the new number at the same index.
                    barcodeCountForCart[itemIndex] = duplicateBarcode
                    barcodeDataForCart[itemIndex] = data
                    // 5. newBarcodesCount array is used to update the itemsCount for each product.
                    newBarcodesCount[itemIndex].itemCount = duplicateBarcode
                    newBarcodesCount[itemIndex].price += barcodeDataForCart[itemIndex].price
                }
                barcodeData.append(data)
            }
        }
    }
    
    //MARK: Helper Functions
    
    func fetchBarcodes() {
        BarcodeService.shared.fetchBarcode { (barcodes) in
            self.codesFromAPI = barcodes
        }
    }
}
