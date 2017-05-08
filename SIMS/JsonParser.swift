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
        let jsonObj = json["mydata"]
        
        let userID = jsonObj["userid"].stringValue
        let name = jsonObj["name"].stringValue
        let mobileNo = jsonObj["mobileno"].stringValue
        let emailID = jsonObj["emailid"].stringValue
        let contactAddress = jsonObj["contactaddress"].stringValue
        let landMark = jsonObj["landmark"].stringValue
        let city = jsonObj["city"].stringValue
        let createDate = jsonObj["create_date"].stringValue
        let token = jsonObj["token"].stringValue
        let age = jsonObj["age"].stringValue
        let gender = jsonObj["gender"].stringValue
        let otp = jsonObj["otp"].stringValue
        let status = jsonObj["status"].stringValue
        
        return Member(userid: userID, name: name, mobileno: mobileNo, emailid: emailID, contactaddress: contactAddress, landmark: landMark, city: city, create_date: createDate, token: token, age: age, gender: gender, otp: otp, status: status)
    }
}
