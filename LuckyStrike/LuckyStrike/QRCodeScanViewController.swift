//
//  QRCodeScanViewController.swift
//  LuckyStrike
//
//  Created by 수현 on 2022/02/04.
//

import UIKit
import AVFoundation

class QRCodeScanViewController: UIViewController {

    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

extension QRCodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func basicSetting() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            setVideoLayer()
            setGuideCrossLineView()
            
            captureSession.startRunning()
        } catch { print("error") }
    }
    
    func setVideoLayer() {
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = view.layer.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
    }
    
    func setGuideCrossLineView() {
        let guideCrossLine = UIImageView()
        guideCrossLine.image = UIImage(systemName: "plus")
        guideCrossLine.tintColor = .green
        view.addSubview(guideCrossLine)
        guideCrossLine.translatesAutoresizingMaskIntoConstraints = false
        guideCrossLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guideCrossLine.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        guideCrossLine.widthAnchor.constraint(equalToConstant: 30).isActive = true
        guideCrossLine.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else { return }
            
            if stringValue.hasPrefix("http://") || stringValue.hasPrefix("https://") {
                print(stringValue)
                
                self.captureSession.stopRunning()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
