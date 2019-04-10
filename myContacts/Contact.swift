//
//  Contact.swift
//  myContacts
//
//  Created by james luo on 4/9/19.
//  Copyright © 2019 james luo. All rights reserved.
//

import Foundation
class Contact{
    var Name : String
    var Number: String
    var LastName : String
    init(name:String ,lastName: String, number: String) {
        self.Name = name
        self.Number = number
        self.LastName = lastName
        if lastName != ""{
            self.Name = name + " " + lastName
        }
    }
}
