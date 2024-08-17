//
//  CameraViewModel.swift
//  CustomAlbum
//
//  Created by 김시종 on 8/17/24.
//

import AVFoundation
import SwiftUI


class CameraViewModel: NSObject {
    private let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    @Published var isSessionRunning = false
    @Published var capturedImage: UIImage?
    
    override init() {
        super.init()
        configureSession()
    }
    
    private func configureSession() {
        session.beginConfiguration()
        
        //후면 카메라
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(input) else {
            return
        }
        session.addInput(input)
        
        //사전 출력
        guard session.canAddOutput(output) else {
            return
        }
        session.addOutput(output)
        
        session.commitConfiguration()
    }
    
    func startSession() {
        if !session.isRunning {
            session.startRunning()
            isSessionRunning = true
        }
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
            isSessionRunning = false
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func setupPreviewLayer(with view: UIView) {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.bounds
        view.layer.addSublayer(previewLayer!)
    }
}


extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else {
            return
        }
        capturedImage = image
    }
}
