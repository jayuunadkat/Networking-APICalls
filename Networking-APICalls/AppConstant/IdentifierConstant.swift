//
//  IdentifierConstant.swift
//  Networking-APICalls
//
//  Created by Jaymeen Unadkat on 03/10/23.
//

import Foundation
///`IdentifiableKeys`
struct IdentifiableKeys {

    ///`API Failure messages`
    struct FailureMessage {
        static let kNoInternetConnection                        = "Please check your internet connection"
        static let kCommanErrorMessage                          = "Something went wrong. please try again later"
        static let kDataNotFound                                = "No Result Found"
    }

    ///`ImageName Constants`
    struct ImageName {
        static let kAvatar                                      = "Avatar"
        static let kPerson                                      = "person.circle"
    }

    struct Labels {
        static let kLIST                                          = "LIST"
        static let kGRID                                          = "GRID"
    }
}
