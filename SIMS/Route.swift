//
//  Route.swift
//  SIMS
//
//  Created by Dharani Reddy on 07/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import Foundation


let absoluteURL = URL(string: "http://track.playgps.co.in/beta/api/Hospital/Index.php")!

enum Route {
    case login              // GET
    case register           // POST
    case bookAmbulance      // POST
    
    var cmd: String {
        return cmdString
    }
    
    private var cmdString: String {
        switch self {
        case .login:
            return "Get_User"
        case .register:
            return "Save_User"
        case .bookAmbulance:
            return "bookampbulance"
        }
    }
}
