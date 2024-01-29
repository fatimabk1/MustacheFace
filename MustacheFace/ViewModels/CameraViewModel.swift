//
//  VideoCaptureViewModel.swift
//  MustacheFace
//
//  Created by Fatima Kahbi on 1/1/24.
//

import Foundation
import AVFoundation

//@MainActor
final class CameraViewModel: ObservableObject {
    var sessionQueue = DispatchQueue(label: "sessionQueue", qos: .userInitiated)
    var session = AVCaptureSession()
    private var model = Camera() // make it more clearly named
    private var videoAuth: Bool = false
    private var audioAuth: Bool = false
    
    @Published var needToCheck = false
    @Published var isRecording = false
    @Published var alert = AlertItem() // has error
    
    func setup() {
        model.setupSession(session: session, sessionQueue: sessionQueue) { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.handleError(error)
        }
    }
    
    func checkPermissions(completion: @escaping(Bool) -> Void) {
        // MARK: Check for video permission
        let videoStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch(videoStatus) {
        case .authorized:
            print("Has permission for Video - auth")
            videoAuth = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] status in
                guard let strongSelf = self else { return }
                if status {
                    print("Has permission for Video - nd")
                    strongSelf.videoAuth = true
                } else {
                    print("No permission for Video - nd")
                    strongSelf.videoAuth = false
                    strongSelf.handleError(CameraError.noPermission)
                }
            }
            
        default:
            print("NOOOO permission for Video")
            self.handleError(CameraError.noPermission)
        }
        
        // MARK: Check for audio permission
        let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        switch(audioStatus) {
        case .authorized:
            print("Has permission for Audio - auth")
            audioAuth = true
        case .notDetermined:
//            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .audio) { [weak self] status in
                guard let strongSelf = self else { return }
                if status {
                    print("Has permission for audio - nd")
                    strongSelf.audioAuth = true
                } else {
                    print("No permission for audio - nd")
                    strongSelf.audioAuth = false
                    strongSelf.handleError(CameraError.noPermission)
                }
//                strongSelf.sessionQueue.resume()
            }
        default:
            print("NOOOO permission for audio")
            self.handleError(CameraError.noPermission)
        }
        
        let isAuthorized = videoAuth && audioAuth
        completion(isAuthorized)
    }
    
    private func handleError(_ error: Error?) {
            guard let specificError = error as? CameraError else {
                print("Unkown error")
//                alert.title = "Unkown Error"
//                alert.isPresented = true
                return
            }
            
            switch specificError {
            case .noAudio, .noVideo, .noPermission:
//                alert.title = "Please grant camera permission"
                print("Please grant camera permission")
            case .unableToOutput:
//                alert.title = "Unable to output file"
                print("Unable to output file")
            case .unableToRecord:
                print("Unable to record")
//                alert.title = "Unable to record"
            case .selfIsNil, .noSessionQueue:
//                alert.title = "Unable to use camera"
                print("Unable to record")
            }
        print(specificError)
//          alert.isPresented = true
    }
    
    func startRecording() {
        guard let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("output.mp4") else {
//            alert.isPresented.toggle()
            print("Unable to output 83")
            return
        }
        if !isRecording {
            if FileManager.default.fileExists(atPath: outputURL.path) {
                do {
                    try FileManager.default.removeItem(at: outputURL)
                } catch {
//                    alert.isPresented.toggle()
                    print("Unable to record 91")
                    return
                }
            }
            model.startRecording(to: outputURL)
            isRecording = true
        }
    }
    
    func stopRecording() {
        model.stopRecording()
        isRecording = false
    }
    
    
}
