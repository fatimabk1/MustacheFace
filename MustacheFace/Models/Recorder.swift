//
//  Recorder.swift
//  MustacheFace
//
//  Created by Fatima Kahbi on 1/1/24.
//

import Foundation
import AVFoundation
import Photos

// TODO: error handling / propogation
// TODO: Rename to View Model
class Recorder: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    @Published var session = AVCaptureSession()
    @Published var isRecording = false
    
    private var sessionQueue = DispatchQueue(label: "sessionQueue", qos: .userInitiated)
    private let videoOutput = AVCaptureMovieFileOutput()
    
    var isAuthorized: Bool {
        get async {
            let videoStatus = AVCaptureDevice.authorizationStatus(for: .video)
            var videoAuth = videoStatus == .authorized
            if videoStatus == .notDetermined {
                videoAuth = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
            var audioAuth = audioStatus == .authorized
            if audioStatus == .notDetermined {
                audioAuth = await AVCaptureDevice.requestAccess(for: .audio)
            }
            
            return videoAuth && audioAuth
        }
    }

    override init() {
        super.init()
        addInputs()
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        sessionQueue.async { [unowned self] in
            self.session.startRunning()
        }
    }


    func setupCaptureSession() async {
        guard await isAuthorized else { return }
        
        // Set up the capture session.
        sessionQueue.async {
            self.session.beginConfiguration()
            self.addInputs()
            guard self.session.canAddOutput(self.videoOutput) else { return }
            self.session.addOutput(self.videoOutput)
            self.session.commitConfiguration()
            // setup camera preview
            
            
            self.session.startRunning()
        }
    }
    
    
    
    
    
    private func addInputs() {
        print("Adding inputs")
        // add video input
        guard let videoDevice = AVCaptureDevice.default(for: .video), 
                let input = try? AVCaptureDeviceInput(device: videoDevice),
            session.canAddInput(input) else {
            print("Failed adding video input")
            return
        }
        session.addInput(input)
        
        // add audio input
        guard let audioDevice = AVCaptureDevice.default(for: .audio), 
                let input = try? AVCaptureDeviceInput(device: audioDevice),
              session.canAddInput(input) else {
            print("Failed adding audio input")
            return
        }
        session.addInput(input)
    }
    
    func startRecording() {
        print("Calling start")
        guard let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("out.mp4") else { return }
        if videoOutput.isRecording == false {
            if FileManager.default.fileExists(atPath: outputURL.path()) {
                try? FileManager.default.removeItem(at: outputURL)
            }
            videoOutput.startRecording(to: outputURL, recordingDelegate: self)
            self.isRecording = true
        }
    }
        
    func stopRecording() {
        print("Calling finish")
        if videoOutput.isRecording {
            videoOutput.stopRecording()
            self.isRecording = false
        }
    }
        
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("Recording finished")
        // TODO: replace with saving to ORM
        // Check for recording error
        if let error = error {
          print("Error recording: \(error)")
          return
        }

        // Save video to Photos
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
        }) { saved, error in
            if saved {
                print("Successfully saved video to Photos.")
            } else if let error = error {
                print("Error saving video to Photos: \(error)")
            }
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?){
        print("Recording started")
    }
    
}


//    var isAuthorized: Bool {
////        Task {
//            // check video authorization, request if undetermined
//            let videoStatus = AVCaptureDevice.authorizationStatus(for: .video)
//            var videoAuth = videoStatus == .authorized
//            if videoStatus == .notDetermined {
//                AVCaptureDevice.requestAccess(for: .video) { granted in
//                    videoAuth = granted
//                }
//            }
//
//            // check audio authorization, request if undetermined
//            let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
//            var audioAuth = audioStatus == .authorized
//            if audioStatus == .notDetermined {
//                AVCaptureDevice.requestAccess(for: .audio) { granted in
//                    audioAuth = granted
//                }
//            }
//
//            let isAuthorized = (videoAuth && audioAuth)
//            return isAuthorized
////        }
//    }


//        if !isAuthorized {
//            print("not authorized")
//            return
//        } else {
//            print("authorized")
//        }


//    override init() {
//        Task {
//            await setupCaptureSession()
//        }
//    }
