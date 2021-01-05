//
//  PageCell.swift
//  BakeryHelper
//
//  Created by Claire De Guzman on 2020-10-22.
//  Copyright © 2020 Claire De Guzman. All rights reserved.
//

import Foundation
import UIKit
class PageCell: UICollectionViewCell {
    
    var page: Page? {
        
        didSet {
            
            guard let page = page else {
                return
                
            }
            
            imageView.image = UIImage(named: page.imageName)
                let color = UIColor(white: 0.2, alpha: 1)
                       
            let attributedText = NSMutableAttributedString(string: page.title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: color])
                       
            attributedText.append(NSAttributedString(string: "\n\n\(page.message)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: color]))
                       
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
                       
            let length = attributedText.string.count
            attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
                       
            textView.attributedText = attributedText
            
            
        }
    }
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setupViews()
        
    }

    func setupViews ()  {
        backgroundColor = .white
        addSubview(imageView)
        addSubview(textView)
        addSubview(lineSeperatorView)
        
        
        imageView.anchorToTop(topAnchor, left: leftAnchor, bottom: textView.bottomAnchor, right: rightAnchor)
        textView.anchorToTop(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        lineSeperatorView.anchorToTop(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        lineSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"shopping")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
       let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.isEditable = false
        return tv
    }()
    
    let lineSeperatorView: UIView = {
        let ls = UIView()
        ls.backgroundColor = UIColor(white: 0.1, alpha: 5)
        return ls
    }()

    required init?(coder: NSCoder) {
        fatalError("Error Message")
    }
    
    
    
}



