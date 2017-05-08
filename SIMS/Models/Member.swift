//
//  Member.swift
//  SIMS
//
//  Created by Dharani Reddy on 07/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import Foundation

struct Member {
    internal var userid: String?
    internal var name: String?
    internal var mobileno: String?
    internal var emailid: String?
    internal var contactaddress: String?
    internal var landmark: String?
    internal var city: String?
    internal var create_date: String?
    internal var token: String?
    internal var age: String?
    internal var gender: String?
    internal var otp: String?
    internal var status: String?
}

extension Member {
    
    struct Static {
        static var instance: Member?
    }
    
    static func currentMember() -> Member? {
        return Static.instance!
    }
    
    static func setCurrentMember(_ member: Member) {
        Static.instance = member
    }
}

func currentMember() -> Member {
    return Member.currentMember()!
}
