//
//  DatabaseManager.swift
//  giphyApp
//
//  Created by MacBook on 5/21/20.
//  Copyright © 2020 den4iklvivua. All rights reserved.
//

import Realm
import RealmSwift
import UIKit

public class DatabaseManager {
    public static let shared = DatabaseManager()
    
    public init() {
        print("Inited Database Manager")
    }
    
    public func addNewHistoryItem(name: String, data: Data) {
        do {
            let item = HistorySearchItem()
            item.name = name
            item.picture = data
            
            let realm = try Realm()
            
            try realm.write {
                realm.add(item)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didUpdateHistory"), object: nil)
        }catch{
            print("Error setting new value! \(error)")
        }
    }
    
    public func showAllHistory() -> [HistorySearchItem] {
        var items: [HistorySearchItem] = []
        do {
            let realm = try Realm()
            let itemsFound = realm.objects(HistorySearchItem.self)
            items = itemsFound.toArray()
        }catch{
            print("Error getting values! \(error)")
        }
        return items
    }
}


public class HistorySearchItem: Object {
    @objc dynamic var name: String?
    @objc dynamic var picture: Data? = nil
}

public class HistoryUserSearch: Object {
    let items = List<HistorySearchItem>()
}




