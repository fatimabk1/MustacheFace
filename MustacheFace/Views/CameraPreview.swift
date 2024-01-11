//
//  CameraPreview.swift
//  MustacheFace
//
//  Created by Fatima Kahbi on 1/1/24.
//

import SwiftUI
import UIKit
import AVFoundation


struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
//    func makeUIView(context: Context) -> VideoPreviewView {
//        let view = VideoPreviewView()
//        view.videoPreviewLayer.session = self.captureSession
//        return view
//    }
//    
//    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
//        
//    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.session = self.session
//        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            layer.session = session
            layer.frame = uiView.bounds
        }
    }
}

#Preview {
    @State var session = AVCaptureSession()
    return CameraPreview(session: session)
}
