//
//  Networking_APICallsApp.swift
//  Networking-APICalls
//
//  Created by Jaymeen Unadkat on 03/10/23.
//

import SwiftUI

@main
struct Networking_APICallsApp: App {
    @State private var showIndicator: Bool = false

    var body: some Scene {
        WindowGroup {
            HomeView()
                .onReceive(NotificationCenter.default.publisher(for: .showIndicator)) { result in
                    if let showIndicator = result.object as? Bool {
                        self.showIndicator = showIndicator
                    }
                }
                .activityIndicator(show: self.showIndicator)

        }
    }
}
