//
//  ActorViewModel.swift
//  Live It
//
//  Created by Muniyaraj on 23/09/24.
//

import Foundation


actor BankAccount{
    
    private var balance: Double = 100
    
    func deposit(amount: Double){
        balance += amount
    }
    
    func withdraw(amount: Double)-> Bool{
        if amount <= balance{
            balance -= amount
            return true
        }
        return false
    }
}
