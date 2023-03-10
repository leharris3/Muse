//
//  UserCard.swift
//  Research-App
//
//  Created by Levi Harris on 3/7/23.
//

import UIKit

class UserCard: NSObject {
    
    var firstName: String? = ""
    var age: Int = 99
    var sex = ""
    var preference = ""
    
    var interests: [String] = []
    var bio: String? = ""
    var graduatationDate: String? = "" // i.e. class of 2024
    var major: String? = "" // "Computer Science"
    var dateOfBirth: Date? = nil

}
