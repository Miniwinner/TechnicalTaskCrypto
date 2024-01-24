//
//  CryptoViewModel.swift
//  TechnicalTaskCrypto
//
//  Created by Александр Кузьминов on 23.01.24.
//

import Foundation

class CryptoViewModel: CryptoViewModelProtocol {
    private var dataModel: [RequiredModel] = []
    private var filteredDataModel: [RequiredModel] = []
    var limit = 0
    let headers: [String] = ["Market Cap", "Supply", "Volume 24Hr"]
    
    var load: (() -> Void)?
    func loadData(limitPlus: Int) {
        limit += limitPlus
        CryptoService.shared.fetchData(limit: limit) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let dataCRP):
                guard !dataCRP.data.isEmpty else { return }
                let requiredModels: [RequiredModel] = dataCRP.data.compactMap { data in
                    guard let symbol = data["symbol"],
                          let name = data["name"],
                          let id = data["id"],
                          let changePercent24Hr = data["changePercent24Hr"],
                          let priceUsd = data["priceUsd"],
                          let supply = data["supply"],
                          let marketCap = data["marketCapUsd"],
                          let volumeUsd24Hr = data["volumeUsd24Hr"] else { return nil }
                    return RequiredModel(symbol: symbol ?? "btc",
                                         name: name ?? "BTC",
                                         id: id ?? "BTC",
                                         changePercent24Hr: changePercent24Hr ?? "100",
                                         priceUsd: priceUsd ?? "100",
                                         marketCap: marketCap ?? "100",
                                         supply: supply ?? "100",
                                         volume: volumeUsd24Hr ?? "100")
                }
                let reqArray = Array(requiredModels.suffix(limitPlus))
                self.dataModel.append(contentsOf: reqArray)
                load?()
            case .failure(let error):
                print(error)
            }
        }
    }
    func filterText(text: String) {
        filteredDataModel = dataModel.filter { item in
            return item.symbol.contains(text.uppercased())
        }
    }
    func filterCount() -> Int { return filteredDataModel.count }
    func filterIndex(index: Int) -> RequiredModel { return filteredDataModel[index] }
    
    func cryptoCount() -> Int { return dataModel.count }
    func cryptoIndex(index: Int) -> RequiredModel { dataModel[index] }
    
}
