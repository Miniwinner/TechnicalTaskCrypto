//
//  CryptoCell.swift
//  TechnicalTaskCrypto
//
//  Created by Александр Кузьминов on 23.01.24.
//

import Foundation
import UIKit
import SnapKit

final class CryptoCell: UITableViewCell {
    
    lazy var cryptoName = CryptoLabel(style: .cryptoName, text: "None")
    lazy var cryptoToken = CryptoLabel(style: .cryptoTicker, text: "None")
    lazy var cryptoPrice = CryptoLabel(style: .cryptoName, text: "None")
    lazy var cryptoDeltaPrice = CryptoLabel(style: .cryptoTicker, text: "None")
    lazy var cryptoImage = CryptoImageView(style: .cryptoImage)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupData(model: RequiredModel) {
        cryptoImage.image = UIImage(named: model.symbol.lowercased())
        cryptoName.text = model.name
        cryptoPrice.text = "$ \((Double(model.priceUsd)! * 10).rounded() / 10)"
        cryptoToken.text = model.symbol
        cryptoDeltaPrice.text = rg(model: model.changePercent24Hr)
    }
 
    private func rg(model: String) -> String {
        var stroka = ""
        if Double(model)! < 0 {
             stroka = "( \((Double(model)! * 100).rounded() / 100)%)"
            cryptoDeltaPrice.textColor = .red
        } else {
            stroka = "(+ \((Double(model)! * 100).rounded() / 100)%)"
            cryptoDeltaPrice.textColor = UIColor(red: 36 / 255.0, green: 178 / 255.0, blue: 93 / 255.0, alpha: 1) }
        return stroka
    }
    private func setupUI() {
        backgroundColor = .clear
        cryptoPrice.textAlignment = .right
        cryptoDeltaPrice.textAlignment = .right
        addSubview(cryptoName)
        addSubview(cryptoToken)
        addSubview(cryptoPrice)
        addSubview(cryptoDeltaPrice)
        addSubview(cryptoImage)
    }
    private func setupLayout() {
        cryptoImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(25)
            make.height.width.equalTo(48)
        }
        cryptoName.snp.makeConstraints { make in
            make.left.equalTo(cryptoImage.snp.right).offset(10)
            make.top.equalToSuperview().offset(12)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(20)
        }
        cryptoToken.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.left.equalTo(cryptoImage.snp.right).offset(10)
            make.height.equalTo(18)
            make.width.lessThanOrEqualTo(200)
        }
        cryptoPrice.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().inset(25)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(200)
        }
        cryptoDeltaPrice.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(25)
            make.height.equalTo(18)
            make.width.lessThanOrEqualTo(200)
        }
    }
}
