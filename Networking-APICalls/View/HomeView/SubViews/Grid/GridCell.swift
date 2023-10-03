//
//  GridCell.swift
//  ListingDemoSwiftUI
//
//  Created by Jaymeen Unadkat on 05/07/23.
//

import SwiftUI

///`GridCell`
struct GridCell: View {
    @Binding var homeScreenModel: HomeScreenModel?
    var body: some View {
        ZStack(alignment: .center) {
            
            Color.appSnippetsColor
            VStack {
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

struct GridCell_Previews: PreviewProvider {
    static var previews: some View {
        GridCell(homeScreenModel: .constant(
            HomeScreenModel(
                userID: 10,
                id: 98,
                title: "at nam consequatur ea labore ea harum",
                body: "cupiditate quo est a modi nesciunt soluta\nipsa voluptas error itaque dicta in\nautem qui minus magnam et distinctio eum\naccusamus ratione error aut")
        ))
    }
}
