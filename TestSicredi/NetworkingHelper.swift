//
//  NetworkingHelper.swift
//  TestSicredi
//
//  Created by George Gomes on 16/05/20.
//  Copyright © 2020 George Gomes. All rights reserved.
//

import Foundation
import SystemConfiguration

class NetworkingManager {
    /**
        # isConnected
         is a static variable of the Boolean type to know if the device is connected to the Internet by data or wifi, returns true if it is connected and false if it is not.
                
        ## Recomendations

        - Try to use only in networking request classes
    */
    static var isConnected: Bool = {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRoutReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1, { zeroSocketAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSocketAddress)
            })
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRoutReachability!, &flags) == false {
            return false
        }
        
        // working in  cellular and wifi
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        let isConnected = (isReachable && !needsConnection)
        
        return isConnected
    }()
}
