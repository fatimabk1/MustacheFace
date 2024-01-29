//
//  ContentView.swift
//  MustacheFace
//
//  Created by Fatima Kahbi on 1/1/24.
//

import SwiftUI
import AVFoundation

struct MainScreenView: View {
    @StateObject var vm = CameraViewModel()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            CameraPreview(session: $vm.session, sessionQueue: vm.sessionQueue)
                .ignoresSafeArea()
            Group {
                if vm.isRecording {
                    stopButton(vm: vm)
                } else {
                    startButton(vm: vm)
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear {
            vm.checkPermissions { granted in
                if granted {
                    vm.setup()
                } else {
                    vm.alert.title = "Failure with Permission"
                    vm.alert.isPresented = true
                }
            }
        }
        .alert(vm.alert.title, isPresented: $vm.alert.isPresented) {
            Button("OK", role: .cancel) {}
        }
    }
}

struct startButton: View {
    @ObservedObject var vm: CameraViewModel
    var body: some View {
        Button {
            vm.startRecording()
        } label: {
            Image(systemName: "record.circle")
                .scaleEffect(3)
                .foregroundStyle(.white)
                .padding()
        }
    }
}
struct stopButton: View {
    @ObservedObject var vm: CameraViewModel
    var body: some View {
        Button {
            vm.stopRecording()
        } label: {
            Image(systemName: "stop.circle")
                .scaleEffect(3)
                .foregroundStyle(.red)
                .padding()
        }
    }
}


#Preview {
    var sessionQueue = DispatchQueue(label: "sessionQueue", qos: .userInitiated)
    return MainScreenView()
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
