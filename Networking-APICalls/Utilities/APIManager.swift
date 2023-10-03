//
//  APIManager.swift
//  Networking-APICalls
//
//  Created by Jaymeen Unadkat on 03/10/23.
//

import SwiftUI
import SystemConfiguration
import Alamofire
import Combine
import Network

///`StatusCode`
public enum StatusCode: Int {
    case Success = 200
    case Unauthorized = 401
    case Fail = 402
    case InvalidConfiguration = 403
    case ListRefresh = 406
    case UserNotExist = 404
    case relationSuccess = 201
    case widgetRefresh = 408
}


///This is APIManager uses Alamofire for APICalls.
class APIManager: NSObject {
    private var cancellableSet: Set<AnyCancellable> = []

    /**
     This method is used to check internet connectivity.
     - Returns: Return boolean value to indicate device is connected with internet or not
     */
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()

        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []

        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }

    /**
     This method is used to make Alamofire request with or without parameters.
     - Parameters:
     - url: URL of request
     - method: HTTPMethod of request
     - parameter: Parameter of request
     - success: Success closure of method
     - response: Response object of request
     - failure: Failure closure of method
     - error: Failure error
     - connectionFailed: Network connection faild closure of method
     - error: Network error
     */
    class func makeRequest(with url: String, method: HTTPMethod, parameter: [String:Any]?, success: @escaping (_ response: Any) -> Void, failure: @escaping (_ error: String,_ errorcode: Int, _ isAuth: Bool) -> Void, connectionFailed: @escaping (_ error: String) -> Void) {

        if(isConnectedToNetwork()) {
            // Utilities.printLog(url)

            let url = Constant.ServerAPI.BASE_URL + url
            /*print(url)*/

            if let param = parameter, let data = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) {
                print(String(data: data, encoding: .utf8) ?? "Nil Param")
            }

            let headers = [
                Constant.content_type: "application/json",
//                Constant.Authorization: "Bearer \(currentUser?.authorization ?? "")",
            ] as [String: String]


            let httpHeaders = HTTPHeaders.init(headers)
            /*print(headers)
             print("Method: \n",method.rawValue)*/

            AF.request(url, method: method, parameters: parameter, encoding: JSONEncoding.default, headers: httpHeaders).responseData { response in
                guard let str = response.data?.prettyPrintedJSONString else { return }
                Logger.logResponse(ofAPI: url, logType: .info, object: str)

                switch response.result {
                case .success(let data):
                    // print("Response: \n", data.prettyPrintedJSONString ?? "nil")

                    if let res = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]] {
                        let statusCode = response.response?.statusCode
//                        let msg = res["message"] as? String ?? IdentifiableKeys.FailureMessage.kCommanErrorMessage
                        /// `accessToken invalid`
                        if statusCode == StatusCode.Success.rawValue {
                            /// `success`
                            let responseData = try? JSONSerialization.jsonObject(with: data, options: [])
                            success(responseData as AnyObject)
                        } else {
                            /// `failure`
                            if response.response?.statusCode == 401 {
                                failure("msg", 401, true)
                            } else {
                                failure("msg", response.response?.statusCode ?? 402, false)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    if !error.localizedDescription.contains("cancelled") {
                        failure(IdentifiableKeys.FailureMessage.kCommanErrorMessage, 400, false)
                    }
                }
            }
        } else {
            failure(IdentifiableKeys.FailureMessage.kNoInternetConnection, 400, false)
        }
    }


    // MARK: - Call Api To Upload Single image wirh request data in form data for edit profile
    class func makeRequestWithMedia(_ URLString : String,params: [String:Any]?, dataImage: [String: Data]?, dataVideo: [String: Data]?, dataAudio: [String: Data]?, withSuccess success: @escaping (_ responseDictionary: Any) -> Void, failure: @escaping (_ error: String, Int, _ isAuth: Bool) -> Void, connectionFailed: @escaping (_ error: String) -> Void) {

        if(isConnectedToNetwork()) {
            let url = Constant.ServerAPI.BASE_URL + URLString
            print(url)
            if let param = params, let data = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) {
                print(String(data: data, encoding: .utf8) ?? "Nil Param")
            }


            let headers = [
                Constant.content_type: "application/json",
//                Constant.Authorization: "Bearer \(currentUser?.authorization ?? "")",
            ] as [String: String]

            let httpHeaders = HTTPHeaders.init(headers)

            let currentTimeStamp = Date().toMillis()

            AF.upload(multipartFormData: { multipartFormData in
                if let arrData = dataImage {
                    if arrData.count != 0 {
                        for (imageKey, imageValue) in arrData {
                            print("\(String(describing: currentTimeStamp)).jpg")
                            multipartFormData.append(imageValue, withName: imageKey, fileName: "\(String(describing: currentTimeStamp)).jpg", mimeType: "image/jpg")
                        }
                    }
                }

                if let arrVideoData = dataVideo {
                    if arrVideoData.count != 0 {
                        for (videoKey, videoValue) in arrVideoData {
                            print("\(String(describing: currentTimeStamp)).mp4")
                            multipartFormData.append(videoValue, withName: videoKey, fileName: "\(String(describing: currentTimeStamp)).mp4", mimeType: "video/mp4")
                        }
                    }
                }

                if let arrAudioData = dataAudio {
                    if arrAudioData.count != 0 {
                        for (audioKey, audioValue) in arrAudioData {
                            print("\(String(describing: currentTimeStamp)).mp3")
                            multipartFormData.append(audioValue, withName: audioKey, fileName: "\(String(describing: currentTimeStamp)).mp3", mimeType: "audio/mpeg")
                        }
                    }
                }

                if params != nil {
                    for key in params!.keys {
                        let name = String(key)
                        if let val = params![name] as? String {
                            multipartFormData.append(val.data(using: .utf8)!, withName: name)
                        } else if let val = params![name] as? CGFloat {
                            multipartFormData.append("\(val)".data(using: .utf8)!, withName: name)
                        } else if let val = params![name] as? Int {
                            multipartFormData.append("\(val)".data(using: .utf8)!, withName: name)
                        }
                    }
                }
            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: httpHeaders).responseData { response in
                switch response.result {
                case .success(let data):
                    print("Response: \n", data.prettyPrintedJSONString ?? "nil")
                    if let res = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let statusCode = response.response?.statusCode
                        let msg = res["message"] as? String ?? IdentifiableKeys.FailureMessage.kCommanErrorMessage
                        /// `access token` invalid
                        if statusCode == StatusCode.Success.rawValue {
                            /// `success`
                            let responseData = try? JSONSerialization.jsonObject(with: data, options: [])
                            success(responseData as AnyObject)
                        }
                        else {
                            /// `failure`
                            failure(msg, response.response?.statusCode ?? 402, false)

                            /* if response.response?.statusCode == 401 {
                             failure(msg ,401, true)
                             } else {
                             failure(msg, response.response?.statusCode ?? 402, false)
                             } */
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)

                    if error.localizedDescription != "cancelled" {

                    }
                }
            }
        } else {
            failure(IdentifiableKeys.FailureMessage.kNoInternetConnection, 400, false)
        }
    }
}

// MARK: - Data Extnsions
extension Data {
    /// `prints the json to pretty format`
    var prettyPrintedJSONString: String? {
        /// `NSString gives us a nice sanitized debugDescription`
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }

        return prettyPrintedString
    }
}

// MARK: - Date Extensions
extension Date {
    func toMillis() -> Int {
        return Int(self.timeIntervalSince1970 * 1000)
    }

    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        return dateFormatter.string(from: self)
    }
}

// MARK: - API Extensions with Combine
extension APIManager {
    /// `make api request (combine + alamofire)`
    static func makeNetworkRequest<T: Codable>(url: String, method: HTTPMethod, parameters: [String: Any]?, responseType: T.Type) -> AnyPublisher<DataResponse<T, AFError>, Never> {
        let apiUrl = "\(Constant.ServerAPI.BASE_URL)\(url)"
        print("api_url: \(apiUrl)")

//        guard let currentUser = UserDefaults.getData(UserDefaultsKey.kLoginUser, data: UserModel.self) else { return Empty(completeImmediately: false).eraseToAnyPublisher() }

        let headers = [
            Constant.content_type: "application/json",
//            Constant.Authorization: "Bearer \(currentUser.data?.authorization ?? "")",
        ] as [String: String]

        print("api_headers: \(headers)")
        let httpHeaders = HTTPHeaders.init(headers)

        return AF.request(apiUrl, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeaders)
            .validate()
            .publishDecodable(type: T.self)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map({ response -> DataResponse<T, AFError> in
                if let responseData = response.data, let prettyJSON = responseData.prettyPrintedJSONString {
                    Logger.logResponse(ofAPI: apiUrl, logType: .info, object: prettyJSON)
                }

                return response.mapError({
//                    Alert.show(message: $0.localizedDescription)

                    return $0
                })
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    /// `make api request with multipart form data (combine + alamorie)`
    static func makeNetworkRequestWithMultipart<T: Codable>(url: String, parameters: [String: Any]?,  dataImage: [String: Data]?, dataVideo: [String: Data]?, dataAudio: [String: Data]?, responseType: T.Type) -> AnyPublisher<DataResponse<T, AFError>, Never> {
        let apiUrl = "\(Constant.ServerAPI.BASE_URL)\(url)"
        print("api_url: \(apiUrl)")

//        guard let currentUser = UserDefaults.getData(UserDefaultsKey.kLoginUser, data: UserModel.self) else { return Empty(completeImmediately: false).eraseToAnyPublisher() }

        let headers = [
            Constant.content_type: "application/json",
//            Constant.Authorization: "Bearer \(currentUser.data?.authorization ?? "")",
        ] as [String: String]

        print("api_headers: \(headers)")
        let httpHeaders = HTTPHeaders.init(headers)

        let currentTimeStamp = Date().toMillis()

        return AF.upload(multipartFormData: { multipartFormData in
            if let arrData = dataImage {
                if arrData.count != 0 {
                    for (imageKey, imageValue) in arrData {
                        print("\(String(describing: currentTimeStamp)).jpg")
                        multipartFormData.append(imageValue, withName: imageKey, fileName: "\(String(describing: currentTimeStamp)).jpg", mimeType: "image/jpg")
                    }
                }
            }

            if let arrVideoData = dataVideo {
                if arrVideoData.count != 0 {
                    for (videoKey, videoValue) in arrVideoData {
                        print("\(String(describing: currentTimeStamp)).mp4")
                        multipartFormData.append(videoValue, withName: videoKey, fileName: "\(String(describing: currentTimeStamp)).mp4", mimeType: "video/mp4")
                    }
                }
            }

            if let arrAudioData = dataAudio {
                if arrAudioData.count != 0 {
                    for (audioKey, audioValue) in arrAudioData {
                        print("\(String(describing: currentTimeStamp)).mp3")
                        multipartFormData.append(audioValue, withName: audioKey, fileName: "\(String(describing: currentTimeStamp)).mp3", mimeType: "audio/mpeg")
                    }
                }
            }

            if parameters != nil {
                for key in parameters!.keys {
                    let name = String(key)

                    if let val = parameters![name] as? String {
                        multipartFormData.append(val.data(using: .utf8)!, withName: name)
                    } else if let val = parameters![name] as? CGFloat {
                        multipartFormData.append("\(val)".data(using: .utf8)!, withName: name)
                    } else if let val = parameters![name] as? Int {
                        multipartFormData.append("\(val)".data(using: .utf8)!, withName: name)
                    }
                }
            }
        }, to: apiUrl, usingThreshold: UInt64.init(), method: .post, headers: httpHeaders)
        .validate()
        .publishDecodable(type: T.self)
        .subscribe(on: DispatchQueue.global(qos: .background))
        .map({ response -> DataResponse<T, AFError> in
            if let responseData = response.data, let prettyJSON = responseData.prettyPrintedJSONString {
                Logger.logResponse(ofAPI: apiUrl, logType: .info, object: prettyJSON)
            }

            return response.mapError({
//                Alert.show(message: $0.localizedDescription)

                return $0
            })
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    /// `sample example for api call`
    func getCities() -> Void {
        APIManager.makeNetworkRequest(url: "Constant.ServerAPI.kGetCity", method: .get, parameters: nil, responseType: Int.self)
            .sink(receiveCompletion: { completion -> Void in
                switch completion {
                case .failure(let error):
                    print("🐛 error while making network request: \(error.localizedDescription)")
                case .finished:
                    print("🚀 successfully fetched data from the network.")
                }
            }, receiveValue: { response -> Void in
                if response.error != nil {
                    /// `open alert`
                } else {
                    /// `bind data`
                }
            })
            .store(in: &self.cancellableSet)

        self.cancellableSet.forEach({ $0.cancel() })
    }
}
