//
//  CryptoProtocol.swift
//  TechnicalTaskCrypto
//
//  Created by Александр Кузьминов on 24.01.24.
//

import Foundation

protocol CryptoViewModelProtocol {
    var limit: Int { get }
    var headers: [String] { get }
    var load: (() -> Void)? { get set }
    
    func loadData(limitPlus: Int)
    func filterText(text: String)
    func filterCount() -> Int
    func filterIndex(index: Int) -> RequiredModel
    func cryptoCount() -> Int
    func cryptoIndex(index: Int) -> RequiredModel
}
