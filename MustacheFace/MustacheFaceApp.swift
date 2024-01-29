//
//  MustacheFaceApp.swift
//  MustacheFace
//
//  Created by Fatima Kahbi on 1/1/24.
//

import SwiftUI

@main
struct MustacheFaceApp: App {
//    var sessionQueue = DispatchQueue(label: "sessionQueue", qos: .userInitiated)
    
    var body: some Scene {
        WindowGroup {
            MainScreenView(/*sessionQueue: sessionQueue*/)
        }
    }
}
