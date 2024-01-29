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
    @Binding var session: AVCaptureSession
    var sessionQueue: DispatchQueue
    
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
          
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        sessionQueue.async {
            session.startRunning()
        }
        
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
    let sessionQueue = DispatchQueue(label: "sessionQueue", qos: .userInitiated)
    return CameraPreview(session: $session, sessionQueue: sessionQueue)
}
