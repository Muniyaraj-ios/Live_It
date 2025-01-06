//
//  Thread+Extension.swift
//  Live It
//
//  Created by Muniyaraj on 29/08/24.
//

import Foundation

extension Thread{
    static func executedOnMain(_ handler: @escaping()->Void ){
        if Thread.isMainThread{ 
            handler()
        }else{
            DispatchQueue.main.async { handler() }
        }
    }
}
