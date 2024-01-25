//
//  SearchViewController.swift
//  TechnicalTaskCrypto
//
//  Created by Александр Кузьминов on 24.01.24.
//

import UIKit

final class SearchViewController: UIViewController {
    private let vm = CryptoViewModel()
    lazy var backView = CryptoImageView(style: .backView)
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    lazy var cryptoCollection: UITableView = {
        let collection = UITableView()
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupUI()
        setupLayout()
        vm.loadData(limitPlus: vm.limit)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
            self.searchController.isActive = true
        }
    }
    func setupUI() {
        view.backgroundColor = .black
        view.addSubview(backView)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationItem.hidesBackButton = true
        
        cryptoCollection.register(CryptoCell.self, forCellReuseIdentifier: "crypto")
        cryptoCollection.delegate = self
        cryptoCollection.dataSource = self
        view.addSubview(cryptoCollection)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           navigationController?.popViewController(animated: true)
    }
    func setupLayout() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cryptoCollection.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    private func setupSearchBar() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 15, weight: .regular) as Any
        ]
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.searchTextField.layer.cornerRadius = 18
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        searchController.searchBar.searchTextField.backgroundColor = .black
        searchController.searchBar.searchTextField.borderStyle = .none
        searchController.searchBar.searchTextField.tintColor = .white
        searchController.searchBar.searchTextField.textColor = .black
        searchController.searchBar.tintColor = .white
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Write symbol...", attributes: attributes)
        searchController.searchBar.backgroundColor = .clear
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.clearsContextBeforeDrawing = true
        searchController.searchBar.searchTextField.layer.borderColor = UIColor.gray.cgColor
        searchController.searchBar.searchTextField.layer.borderWidth = 0.5
        navigationItem.titleView?.backgroundColor = .clear
        navigationItem.searchController?.searchBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        navigationController?.navigationBar.tintColor = UIColor.black
    }
}
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        vm.filterText(text: searchText)
        cryptoCollection.reloadData()
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.filterCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cryptoCollection.dequeueReusableCell(withIdentifier: "crypto", for: indexPath) as? CryptoCell else { fatalError("Error crypto view") }
        cell.setupData(model: vm.filterIndex(index: indexPath.row))
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
}
