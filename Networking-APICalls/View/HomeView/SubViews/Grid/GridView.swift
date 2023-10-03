//
//  GridView.swift
//  ListingDemoSwiftUI
//
//  Created by Jaymeen Unadkat on 05/07/23.
//

import Foundation
import SwiftUI

/// `GridView`
struct GridView: View {
    @Binding var arrHomeScreenData: [HomeScreenModel?]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let rows = [
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 10){
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(0 ..< self.arrHomeScreenData.count, id: \.self) { i in
                        GridCell(homeScreenModel: self.$arrHomeScreenData[i])
                        .frame(height: ScreenSize.SCREEN_HEIGHT/4, alignment: .center)
                    }

                }
            }
        }

    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(arrHomeScreenData: .constant([]))
    }
}
