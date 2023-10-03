//
//  ListView.swift
//  ListingDemoSwiftUI
//
//  Created by Jaymeen Unadkat on 05/07/23.
//

import SwiftUI

///`ListView`
struct ListView: View {
    @Binding var arrHomeScreenData: [HomeScreenModel?]
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0 ..< self.arrHomeScreenData.count, id: \.self) { i in
                    ListCell(homeScreenModel:self.$arrHomeScreenData[i])
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(arrHomeScreenData: .constant([]))
    }
}


