//
//  S_R_C_V_Import_USDZApp.swift
//  S_R_C_V_Import_USDZ
//
//  Created by Alexander Blong on 17/06/2025.
//

import SwiftUI

@main
struct S_R_C_V_Import_USDZApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}
