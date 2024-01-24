//
//  StackView.swift
//  TechnicalTaskCrypto
//
//  Created by Александр Кузьминов on 24.01.24.
//

import Foundation
import UIKit

class CryptoStackView: UIStackView {
    let firstRow: [String] = ["Market Cap", "Supply", "Volume 24Hr"]
    var secondRow: [String] = ["","",""]
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
    func setupLabel() {
        for (labels, fontSize, textColor) in [(firstRow, 14, UIColor.gray), (secondRow, 16, UIColor.white)] {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 8
            for text in labels {
                let label = createLabel(text: text)
                label.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
                label.textColor = textColor
                rowStackView.addArrangedSubview(label)
            }
            self.addArrangedSubview(rowStackView)
        }
    }
    enum Style {
        case stackOne
    }
    init(style: Style,secondRow: [String]){
        self.secondRow = secondRow
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupLabel()
        switch style {
        case .stackOne:
            backgroundColor = .clear
            axis = .vertical
            distribution = .fillEqually
            spacing = 8
        }
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
