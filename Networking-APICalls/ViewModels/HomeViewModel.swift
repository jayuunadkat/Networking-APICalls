//
//  HomeViewModel.swift
//  ListingDemoSwiftUI
//
//  Created by Jaymeen Unadkat on 05/07/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    /// `Declarations`
    @Published var arrHomeScreenData: [HomeScreenModel?] = []
    @Published var selectedTab: Int = 0
    
}

extension HomeViewModel {
    /// `api call` for home screen data
    func getHomeScreenData(success: @escaping () -> Void) {
        HomeScreenModel.getHomeScreenData(params: nil, showLoader: true) { arrHomeScreenData, _ in
            self.arrHomeScreenData = arrHomeScreenData
            success()
        } failure: { error in
            print("Error>>\(error)")
        }
    }
}
