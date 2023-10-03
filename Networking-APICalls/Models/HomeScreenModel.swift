//
//  HomeScreenModel.swift
//  ListingDemoSwiftUI
//
//  Created by Jaymeen Unadkat on 05/07/23.
//

import Foundation

/// `HomeScreenModel`
struct HomeScreenModel: Codable {
    let userID, id: Int?
    let title, body: String?
    
    enum CodingKeys: String, CodingKey {
        case userID
        case id
        case title
        case body
    }
}

// MARK: - API Calls
extension HomeScreenModel {
    /// `api call` for home screen data
    static func getHomeScreenData(params: [String: Any]?, showLoader: Bool, success: @escaping ([HomeScreenModel?], String) -> Void, failure: @escaping (String) -> Void) -> Void {
        if showLoader {
            Indicator.show()
        }
        APIManager.makeRequest(with: Constant.ServerAPI.kPosts, method: .get, parameter: nil) { response in
            guard let json = response as? [[String: Any]] else { return }
            guard let data = try? JSONSerialization.data(withJSONObject: json) else { return }
            
            do {
                let homeScreenModel = try JSONDecoder().decode([HomeScreenModel].self, from: data)
                success(homeScreenModel, "")
                Indicator.hide()
            } catch let error {
                print(error)
            }
            
        } failure: { error, errorcode, isAuth in
            failure(error)
        } connectionFailed: { error in
            failure(error)
        }
    }
}


