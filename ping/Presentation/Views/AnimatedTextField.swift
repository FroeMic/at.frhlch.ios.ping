//
//  AnimatedTextField.swift
//  tip
//
//  Created by Michael Fröhlich on 08.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

@IBDesignable
class AnimatedTextField: UITextField {
    
    private var borderBottomView: DashedView!
    private var borderBottomViewHeightConstraint: NSLayoutConstraint!
    private var borderBottomViewBottomConstraint: NSLayoutConstraint!
    
    @IBInspectable
    var prefix: String = ""
    
    @IBInspectable
    var dashColor: UIColor = .black {
        didSet {
            borderBottomView.dashColor = dashColor
        }
    }
    
    var textWithoutPrefix: String? {
        didSet {
            guard let textWithoutPrefix = textWithoutPrefix else {
                self.text = nil
                return
            }
            
            guard prefix != "" && textWithoutPrefix != "" else {
                self.text = textWithoutPrefix
                return
            }
        
            self.text = "\(prefix) \(textWithoutPrefix)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        styleView()
    }
    
    // MARK: Setup
    private func initialSetup() {
        
        delegate = self
        
        borderBottomView = DashedView(frame: CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 2.0))
        borderBottomView.dashLength = 15.0
        borderBottomView.spaceLength = 10.0
        addSubview(borderBottomView)
        
        borderBottomView.translatesAutoresizingMaskIntoConstraints = false
        
        borderBottomViewHeightConstraint = NSLayoutConstraint(item: borderBottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 2.0)
        borderBottomViewBottomConstraint = NSLayoutConstraint(item: borderBottomView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: borderBottomView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: borderBottomView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)

        
        self.addConstraint(borderBottomViewHeightConstraint)
        self.addConstraint(borderBottomViewBottomConstraint)
        self.addConstraint(leadingConstraint)
        self.addConstraint(trailingConstraint)
        
    }
    
    private func styleView() {
        borderStyle = .none
    }

    
    private func animateBorderBottomDashed() {
        UIView.animate(withDuration: 0.2, animations: {
            self.borderBottomViewHeightConstraint.constant = 2.0
            self.borderBottomViewBottomConstraint.constant = 0.0
            self.borderBottomView.spaceLength = 10.0
        })
    }
    
    private func animateBorderBottomSolid() {
        UIView.animate(withDuration: 1.2, animations: {
            self.borderBottomViewHeightConstraint.constant = 4.0
            self.borderBottomViewBottomConstraint.constant = 2.0
            self.borderBottomView.spaceLength = 0.0
        })
    }
    
    
    // MARK: User Interaction
    fileprivate func didSelectTextField() {
        animateBorderBottomSolid()
    }
    
    fileprivate func didDeselectTextField() {
        animateBorderBottomDashed()
    }
}

extension AnimatedTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didSelectTextField()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didDeselectTextField()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let beginning: UITextPosition = textField.beginningOfDocument
        let cursorLocation: UITextPosition? = textField.position(from: beginning, offset: range.location + string.count)
        
        let typeCasteToStringFirst = textField.text as NSString?
        textWithoutPrefix = typeCasteToStringFirst?.replacingCharacters(in: range, with: string)
        
        let replacementText = textWithoutPrefix ?? ""
        if replacementText == "" {
            textField.text = ""
        } else if prefix == "" {
            textField.text = replacementText
        } else {
            textField.text = "\(prefix) \(replacementText)"
        }
        
        if let cursorLocation = cursorLocation {
            textField.selectedTextRange = textField.textRange(from: cursorLocation, to: cursorLocation)
        }
        
        return false
    }

}

