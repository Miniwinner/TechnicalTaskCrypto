//
//  CryptoModel.swift
//  TechnicalTaskCrypto
//
//  Created by Александр Кузьминов on 23.01.24.
//

import Foundation

struct Crypto: Codable {
    let data: [[String: String?]]
    let timestamp: Int
}
