//
//  historyCell.swift
//  giphyApp
//
//  Created by MacBook on 5/21/20.
//  Copyright © 2020 den4iklvivua. All rights reserved.
//

import UIKit
import EasySwiftLayout

class HistoryCell: UICollectionViewCell {
    
    //MARK: - Variables for UI
    var image = UIImageView()
    var title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        image
            .add(toSuperview: self)
            .pinEdge(.top, toEdge: .top, ofView: self)
            .size(toSquareWithSide: 80)
            .centerInView(self, axis: .x)
        title
            .add(toSuperview: self)
            .centerInView(self, axis: .x)
            .pinEdge(.bottom, toEdge: .bottom, ofView: self)
        
        title.textColor = UIColor.white
        title.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
