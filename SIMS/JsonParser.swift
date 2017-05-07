//
//  JsonParser.swift
//  SIMS
//
//  Created by Dharani Reddy on 07/05/17.
//  Copyright © 2017 sims. All rights reserved.
//

import Foundation
import SwiftyJSON

class JsonParser {
    
    class func parseMemberInfo(jsonString: String) -> Member {
        let json = JSON(parseJSON: jsonString)
        
        let userID = json["userid"].stringValue
        let name = json["name"].stringValue
        let mobileNo = json["mobileno"].stringValue
        let emailID = json["emailid"].stringValue
        let contactAddress = json["contactaddress"].stringValue
        let landMark = json["landmark"].stringValue
        let city = json["city"].stringValue
        let createDate = json["create_date"].stringValue
        let token = json["token"].stringValue
        let age = json["age"].stringValue
        let gender = json["gender"].stringValue
        let otp = json["otp"].stringValue
        let status = json["status"].stringValue
        
        return Member(userid: userID, name: name, mobileno: mobileNo, emailid: emailID, contactaddress: contactAddress, landmark: landMark, city: city, create_date: createDate, token: token, age: age, gender: gender, otp: otp, status: status)
    }
}
