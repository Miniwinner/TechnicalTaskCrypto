//
//  ViewController.swift
//  TechnicalTaskCrypto
//
//  Created by Александр Кузьминов on 23.01.24.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    private let vm = CryptoViewModel()
    lazy var mainHeader = CryptoLabel(style: .headerMain, text: "Trending Coins")
    lazy var backView = CryptoImageView(style: .backView)
    private let searchButton = CryptoButton(style: .search)
    private var refreshControl = UIRefreshControl()
    
    lazy var cryptoCollection: UITableView = {
        let collection = UITableView()
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.separatorStyle = .none
        return collection
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        reload()
        vm.loadData(limitPlus: 20)
    }
    private func reload() {
        vm.load = { [weak self] in
            DispatchQueue.main.async {
                self?.cryptoCollection.reloadData()
            }
        }
    }
    @objc private func showSearch() {
       let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func refreshTable(_ sender: AnyObject) {
        vm.loadData(limitPlus: vm.limit)
        vm.load = { [weak self] in
            DispatchQueue.main.async {
                self?.cryptoCollection.reloadData()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cryptoCollection.contentInset = UIEdgeInsets(top: self.refreshControl.frame.height, left: 0, bottom: 0, right: 0)
            self.refreshControl.endRefreshing()
            self.cryptoCollection.contentInset = .zero
        }
    }
    private func setupUI() {
        view.addSubview(backView)
        searchButton.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
        view.addSubview(searchButton)
        view.bringSubviewToFront(searchButton)

        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)

        view.backgroundColor = .black
        view.addSubview(mainHeader)
        cryptoCollection.register(CryptoCell.self, forCellReuseIdentifier: "crypto")
        cryptoCollection.delegate = self
        cryptoCollection.dataSource = self
        cryptoCollection.addSubview(refreshControl)
        view.addSubview(cryptoCollection)
        
    }
    private func setupLayout() {
        mainHeader.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(28)
            make.width.equalTo(213)
        }
        cryptoCollection.snp.makeConstraints { make in
            make.top.equalTo(mainHeader.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(mainHeader)
            make.right.equalToSuperview().inset(10)
            make.height.width.equalTo(40)
        }
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.cryptoCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cryptoCollection.dequeueReusableCell(withIdentifier: "crypto", for: indexPath) as? CryptoCell else { fatalError("Error crypto view") }
        cell.setupData(model: vm.cryptoIndex(index: indexPath.row))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailedViewController()
        vc.setupData(model: vm.cryptoIndex(index: indexPath.row))
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == vm.cryptoCount() - 5 {
            vm.loadData(limitPlus: 10)
            vm.load = { [weak self] in
                DispatchQueue.main.async {
                    self?.cryptoCollection.reloadData()
                }
            }
        }
    }
}
