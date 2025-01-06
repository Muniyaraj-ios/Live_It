//
//  String+Extension.swift
//  Live It
//
//  Created by Muniyaraj on 23/08/24.
//

import Foundation

extension String{
    func isValidPhoneNumber() -> Bool {
        let PHONE_REGEX = "^\\+?[0-9]{10,14}$"//"^[0-9]{10,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func isValidEmail() -> Bool {
        //This regex will limit the user from inserting three dots in email address (or any number of consecutive dots)
        //username and domain must not begin or end with dot
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let dotRegEx = "^(?=.{1,64}@.{4,64}$)(?=.{6,100}$).*"
        
        let predicate1 = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let predicate2 = NSPredicate(format: "SELF MATCHES %@", dotRegEx)
        return predicate1.evaluate(with: self) && predicate2.evaluate(with: self)
    }
    
    func isValidPhoneWithCountryCode() -> Bool {
        let regEx = "^\\+(?:[0-9]?){6,14}[0-9]$"
        let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
        return phoneCheck.evaluate(with: self)
    }
}
