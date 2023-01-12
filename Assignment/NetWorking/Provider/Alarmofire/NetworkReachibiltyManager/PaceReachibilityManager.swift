//
//  PaceReachibilityManager.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/9/23.
//

import Foundation
import Alamofire

class PaceReachibilityManager {
    static let shared = PaceReachibilityManager()
    private init() {}
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = {[unowned self]  status in
            switch status {
                
            case .notReachable:
//                PaceSnackBar.shared.showSnackBar("check_internet".localize, color: T.Colors.coralPinkColor, duration: .forever)
                break
            case .unknown :
                break
            case .reachable(.ethernetOrWiFi):
                self.showInternetConnectionMessage()
                break
            case .reachable(.wwan):
                self.showInternetConnectionMessage()
                break
            }
        }
        
        // start listening
        reachabilityManager?.startListening()
    }
    
    private func showInternetConnectionMessage () {
//        PaceSnackBar.shared.hideSnackbar()
//        PaceSnackBar.shared.showSnackBar("internet_established".localize, color: T.Colors.appGreenColor)
    }
    
}
