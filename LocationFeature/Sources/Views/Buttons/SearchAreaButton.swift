//
//  SearchAreaButton.swift
//  LocationFeature
//
//  Created by Russell Stephenson on 5/22/19.
//  Copyright © 2019 Russell Apps. All rights reserved.
//

import UIKit

final class SearchAreaButton: UIButton {
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
    }
    
}

// MARK: - Private Methods

private extension SearchAreaButton {
    
    func commonInit() {
        alpha = 0.0
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.0
        
        addShadow(ofColor: .black, radius: 1.0, offset: CGSize(width: -2, height: 1), opacity: 0.5)
    }
    
}
