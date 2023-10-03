//
//  ActivityIndicatorView.swift
//  ListingDemoSwiftUI
//
//  Created by Jaymeen Unadkat on 05/07/23.
//

import Foundation
import SwiftUI

///`View Modifier`
extension View {
    func activityIndicator(show: Bool) -> some View {
        self.modifier(ActivityIndicatorExt(show: show))
    }
}

// MARK: - ActivityIndicatorExt
struct ActivityIndicatorExt: ViewModifier {
    var show: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if show {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView()
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Color.myCustomColor.opacity(0.9))
                    .cornerRadius(15)
            }
        }
    }
}
