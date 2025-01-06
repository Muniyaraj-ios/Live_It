//
//  Constatnt.swift
//  Live It
//
//  Created by MacBook on 26/09/24.
//

import Foundation

public struct Constant{
    static let appName: String = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    static let bundleIdentitifer: String = Bundle.main.bundleIdentifier ?? ""
    static let build_number: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    static let version_Number: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}
