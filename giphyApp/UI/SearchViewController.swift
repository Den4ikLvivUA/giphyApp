//
//  SearchViewController.swift
//  giphyApp
//
//  Created by MacBook on 5/21/20.
//  Copyright © 2020 den4iklvivua. All rights reserved.
//

import UIKit
import GiphyUISDK
import GiphyCoreSDK
import EasySwiftLayout

class SearchViewController: UIViewController {

    //MARK: - UI Elements:
    var searchBar = UISearchBar()
    var foundURL = [String]()
    var gifImage = UIImageView()
    var nameLabel = UILabel()
    
    
    fileprivate let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HistoryCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    var items = [HistorySearchItem]()
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNeededUI()
        ServerManager.shared.sendWebHookToDevs()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "didUpdateHistory"), object: nil, queue: .main) { (notification) in
            self.getAllHistory()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        items = DatabaseManager.shared.showAllHistory().reversed()
        self.searchBar.becomeFirstResponder()
        self.collection.reloadData()
    }
    
    //MARK: - Set Default UI
    
    private func setNeededUI() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        nameLabel.text = "Example of Search"
        nameLabel.textAlignment = .center
        if let font = UIFont(name: "Copperplate-Light", size: 20){
            nameLabel.font = font
        }
        
        self.view.addSubview(searchBar)
        
        searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        
        //VS:
            
        
        nameLabel
            .add(toSuperview: view)
            .pinEdge(.top, toEdge: .bottom, ofView: searchBar)
            .size(CGSize(width: self.view.frame.width, height: 40))
        gifImage
            .add(toSuperview: view)
            .pinEdge(.top, toEdge: .bottom, ofView: nameLabel)
            .size(toSquareWithSide: self.view.frame.width/2)
            .centerInView(view, axis: .x)
        collection
            .add(toSuperview: view)
            .pinEdge(.top, toEdge: .bottom, ofView: searchBar)
            .centerInView(view, axis: .x)
            .size(CGSize(width: self.view.frame.width, height: self.view.frame.height-nameLabel.frame.size.height-searchBar.frame.size.height-10))
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
    }
    
    private func getAllHistory() {
        items = DatabaseManager.shared.showAllHistory().reversed()
        self.collection.reloadData()
    }
}


//MARK: - Extensions

extension SearchViewController: UISearchBarDelegate {
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        self.nameLabel.text = searchText
        ServerManager.shared.searchImgByName(name: searchText, completionHandler: {urls in
            DispatchQueue.main.async {
                guard let url = urls.randomElement() else {
                    print("random element Nil!")
                    return
                }
                self.gifImage.loadGifWithUrl(url: url, name: searchText)
            }
        })
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.gifImage.isHidden = true
    }
}


//MARK: - CollectionView

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
//        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let float = searchBar.frame.size.height + nameLabel.frame.size.height + 20
//        return CGSize.init(width: view.frame.width, height: view.frame.height-float)
        return CGSize(width: collectionView.frame.width/3-10, height: collectionView.frame.width/3-10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if (items)
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! HistoryCell
//        let cell = UICollectionViewCell()
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 12.0
        guard let data = item.picture else {
            return cell
        }
        
        cell.image.image = UIImage.gif(data: data)
        cell.title.text = item.name
        cell.image.contentMode = .scaleToFill
        return cell
    }
}


