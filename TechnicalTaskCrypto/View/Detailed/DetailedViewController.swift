//
//  DetailedViewController.swift
//  TechnicalTaskCrypto
//
//  Created by Александр Кузьминов on 23.01.24.
//

import UIKit

final class DetailedViewController: UIViewController {
    private let vm = CryptoViewModel()
    lazy var header = CryptoLabel(style: .nameVC, text: "None1")
    lazy var price = CryptoLabel(style: .headerMain, text: "None2")
    lazy var deltaPrice = CryptoLabel(style: .cryptoTicker, text: "None3")
    lazy var backView = CryptoImageView(style: .backView)
    lazy var stackData = CryptoStackView(style: .stackOne, secondRow: data)
    
    private var data: [String] = Array(repeating: "1", count: 3)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    func setupData(model: RequiredModel) {
        header.text = model.name
        price.text = "$ \((Double(model.priceUsd)! * 100).rounded() / 100)"
        deltaPrice.text = rg(model: model.changePercent24Hr)
        data[0] = "$\(convertToDouble(str: model.marketCap).formatMarketCap())"
        data[1] = "\(convertToDouble(str: model.supply).formatMarketCap())"
        data[2] = "$\(convertToDouble(str: model.volume).formatMarketCap())"
    }
    private func convertToDouble(str: String) -> Double {
        let num: Double = Double(str)!
        return num
    }
    private func rg(model: String) -> String {
        var stroka = ""
        if Double(model)! < 0 {
            stroka = "( \((Double(model)! * 10).rounded() / 10)%)"
            deltaPrice.textColor = .red
        } else {
            stroka = "(+ \((Double(model)! * 10).rounded() / 10)%)"
            deltaPrice.textColor = UIColor(red: 36 / 255.0, green: 178 / 255.0, blue: 93 / 255.0, alpha: 1) }
        return stroka
    }
    private func setupUI() {
        view.addSubview(backView)
        view.addSubview(header)
        view.addSubview(price)
        view.addSubview(deltaPrice)
        view.addSubview(stackData)
    }
    private func setupLayout() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(100)
            make.height.equalTo(30)
            make.width.lessThanOrEqualTo(200)
        }
        price.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(header.snp.bottom).offset(50)
            make.height.equalTo(26)
            make.width.lessThanOrEqualTo(200)
        }
        deltaPrice.snp.makeConstraints { make in
            make.bottom.equalTo(price)
            make.left.equalTo(price.snp.right).offset(20)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(20)
        }
        stackData.snp.makeConstraints { make in
            make.top.equalTo(price.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(36)
        }
    }
}
extension Double {
    func formatMarketCap() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        let billion = 1_000_000_000.0
        let million = 1_000_000.0
        if self >= billion {
            let formattedNumber = self / billion
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber)) ?? "")B"
        } else if self >= million {
            let formattedNumber = self / million
            return "\(numberFormatter.string(from: NSNumber(value: formattedNumber)) ?? "")M"
        } else {
            return "\(numberFormatter.string(from: NSNumber(value: self)) ?? "")"
        }
    }
}
