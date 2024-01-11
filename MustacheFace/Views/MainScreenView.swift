//
//  ContentView.swift
//  MustacheFace
//
//  Created by Fatima Kahbi on 1/1/24.
//

import SwiftUI

struct MainScreenView: View {
    @State var recorder = Recorder()
    
    var body: some View {
        VStack {
            CameraPreview(session: recorder.session)
            HStack {
                Button("Start") {
                    recorder.startRecording()
                }
                Text(" | ")
                Button("Stop") {
                    recorder.stopRecording()
                }
            }
        }
        .padding()
    }
}

#Preview {
    MainScreenView()
}

/*
 - Saved video collection / data store
 - Models:
    - Video model
    - Video w/metadata model (tag, duration)
 - ViewModels:
    - VideoCaptureVM()
        - creates a new video asset
        - provides mustache data for camera
 */


/*
 
 STRUCTURE
 - Capture view
    - Video recorder
    - Mustache button toolbar
        - 3D mustache on face with ARKit
    - stop/start recording button
    - pop-up w/tag field
 - Recordings View
    - Grid of video previews w/tag + duration

 */
