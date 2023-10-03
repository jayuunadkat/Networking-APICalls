//
//  HomeView.swift
//  ListingDemoSwiftUI
//
//  Created by Jaymeen Unadkat on 05/07/23.
//

import SwiftUI

///`HomeView`
struct HomeView: View {
    ///`Declarations`
    @StateObject private var homeVM: HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack {
                    CustomTabBarView(currentTab: self.$homeVM.selectedTab, tabBarOptions: [
                        IdentifiableKeys.Labels.kLIST,
                        IdentifiableKeys.Labels.kGRID
                    ])
                    
                    if self.homeVM.arrHomeScreenData.count == 0 {
                        Spacer()
                        
                        Image(systemName: IdentifiableKeys.ImageName.kPerson)
                            .resizable()
                            .frame(width: 40.0, height: 40.0, alignment: .center)
                            .font(.system(size: Constant.FontSize._20FontSize))
                        
                        Text("No Data found!")
                            .font(.system(size: Constant.FontSize._20FontSize))
                        
                        Spacer()
                    } else {
                        if self.homeVM.selectedTab == 0 {
                            ListView(arrHomeScreenData: self.$homeVM.arrHomeScreenData)
                                .padding(.horizontal,10)
                        } else {
                            GridView(arrHomeScreenData: self.$homeVM.arrHomeScreenData)
                                .padding(.horizontal,10)
                        }
                    }
                }
            }
        }
        .onAppear {
            self.homeVM.getHomeScreenData{}
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
