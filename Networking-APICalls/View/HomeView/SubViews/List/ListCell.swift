//
//  ListCell.swift
//  ListingDemoSwiftUI
//
//  Created by Jaymeen Unadkat on 05/07/23.
//

import SwiftUI

/// `ListCell`
struct ListCell: View {
    @Binding var homeScreenModel: HomeScreenModel?
    var body: some View {
        ZStack(alignment: .leading) {
            
            Color.appSnippetsColor
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.red, .pink]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    VStack {
                        Text("\(self.homeScreenModel?.id ?? 0)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.myDarkCustomColor)
                        
                        Text("km")
                            .font(.caption)
                            .foregroundColor(Color.myDarkCustomColor)
                    }
                }
                .frame(width: 70, height: 70, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text(self.homeScreenModel?.title ?? "")
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .padding(.bottom, 5)
                        .foregroundColor(Color.myDarkCustomColor)

                    
                    HStack(alignment: .center) {
                        Text(self.homeScreenModel?.body ?? "")
                            .foregroundColor(Color.myDarkCustomColor)
                    }
                    .padding(.bottom, 5)
                    
                }
                .padding(.horizontal, 5)
            }
            .padding(15)
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
    

struct ListCell_Previews: PreviewProvider {
    static var previews: some View {
        ListCell(homeScreenModel: .constant(nil))
    }
}
