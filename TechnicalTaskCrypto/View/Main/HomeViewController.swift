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
    
    lazy var searchButton = CryptoButton(style: .search)
    lazy var cancelButton = CryptoButton(style: .cancel)
    private var refreshControl = UIRefreshControl()
    
    private var searchBar = UISearchBar()
    
    lazy var cryptoCollection: UITableView = {
        let collection = UITableView()
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.separatorStyle = .none
        return collection
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
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
//        let vc = SearchViewController()
//        navigationController?.pushViewController(vc, animated: true)
        UIView.animate(withDuration: 0.6) { [self] in
            mainHeader.isHidden = true
            searchButton.isHidden = true
           
            searchBar.isHidden = false
            searchBar.becomeFirstResponder()
            cancelButton.isHidden = false
            cryptoCollection.reloadData()
        }
        self.view.layoutIfNeeded()
    }
    @objc private func hideSearch() {
        UIView.animate(withDuration: 0.6) { [self] in
            mainHeader.isHidden = false
            searchButton.isHidden = false
           
            searchBar.isHidden = true
            searchBar.searchTextField.text = nil
            cancelButton.isHidden = true
            cryptoCollection.reloadData()
        }
        self.view.layoutIfNeeded()

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
        cancelButton.addTarget(self, action: #selector(hideSearch), for: .touchUpInside)
        view.addSubview(cancelButton)
        view.bringSubviewToFront(searchButton)
        
        searchBar.isHidden = true
        searchBar.delegate = self
        view.addSubview(searchBar)
        
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
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(28)
            make.width.lessThanOrEqualTo(213)
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
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(20)
            make.width.lessThanOrEqualTo(285)
            make.height.equalTo(40)
        }
        searchBar.searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(searchBar.snp.right).offset(10)
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(40)
            make.right.equalToSuperview().inset(20)
            make.width.lessThanOrEqualTo(70)
        }
    }
    private func setupSearchBar() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 15, weight: .regular) as Any
        ]
        searchBar.searchBarStyle = .default
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.layer.cornerRadius = 12
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.backgroundColor = .black
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.tintColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Write symbol...", attributes: attributes)
        searchBar.backgroundColor = .clear
        searchBar.showsCancelButton = false
        searchBar.clearsContextBeforeDrawing = true
        searchBar.searchTextField.layer.borderColor = UIColor.gray.cgColor
        searchBar.searchTextField.layer.borderWidth = 0.5
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        vm.filterText(text: searchText)
        DispatchQueue.main.async {
            self.cryptoCollection.reloadData()
        }
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBar.isHidden ? vm.cryptoCount() : vm.filterCount()
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cryptoCollection.dequeueReusableCell(withIdentifier: "crypto", for: indexPath) as? CryptoCell else { fatalError("Error crypto view") }
        if searchBar.isHidden  { cell.setupData(model: vm.cryptoIndex(index: indexPath.row))
        } else { cell.setupData(model: vm.filterIndex(index: indexPath.row)) }
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
