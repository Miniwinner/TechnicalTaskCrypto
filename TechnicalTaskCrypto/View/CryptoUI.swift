//
//  CryptoUI.swift
//  TechnicalTaskCrypto
//
//  Created by Александр Кузьминов on 23.01.24.
//

import Foundation
import UIKit

class CryptoLabel: UILabel {
    enum Style {
        case headerMain
        case cryptoName
        case cryptoTicker
        case nameVC
        case size12Bold
    }
    
    init(style: Style, text:String){
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        switch style {
        case .headerMain:
            textColor = .white
            backgroundColor = .clear
            font = UIFont.systemFont(ofSize: 24, weight: .regular)
            let labelText = "Trending Coins"
            let attributedString = NSMutableAttributedString(string: labelText)
            let kernValue: CGFloat = 0.48
            let range = NSRange(location: 0, length: labelText.count)

            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: range)

            attributedText = attributedString
            
        case .cryptoName:
            textColor = .white
            font = UIFont.systemFont(ofSize: 18, weight: .regular)
        case .cryptoTicker:
            textColor = .white
            font = UIFont.systemFont(ofSize: 14, weight: .regular)
        case .nameVC:
            textColor = .white
            font = UIFont.systemFont(ofSize: 26, weight: .regular)
        case .size12Bold:
            textColor = .white
            font = UIFont.systemFont(ofSize: 12, weight: .regular)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CryptoImageView: UIImageView {
    enum Style {
      case cryptoImage
      case backView
    }
    init(style: Style){
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        switch style {
        case .cryptoImage:
            layer.cornerRadius = 12
            layer.masksToBounds = true
            backgroundColor = UIColor(red: 35/255, green: 30/255, blue: 28/255, alpha: 1)
        case .backView:
            image = UIImage(named: "home1")
            contentMode = .scaleToFill
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class CryptoButton: UIButton {
    enum Style {
        case search
        case cancel
    }
    
    init(style: Style) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .search:
            layer.cornerRadius = 12
            layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            layer.borderWidth = 1
            setImage(UIImage(named: "search"), for: .normal)
            imageView?.contentMode = .scaleToFill
            backgroundColor = UIColor(red: 35/255, green: 30/255, blue: 28/255, alpha: 1)
        case .cancel:
            setTitle("Cancel", for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            titleLabel?.textColor = .gray
            isHidden = true
            
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
