//
//  KtextField.swift
//  Biap
//
//  Created by Ahmed Shawky on 04/03/2023.
//
import UIKit

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class PasswordTextField: TextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.isSecureTextEntry = true
        
        //show/hide button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(named: "ic_visibility_off"), for: .normal)
        button.setImage(UIImage(named: "ic_visibility_on"), for: .selected)
        rightView = button
        rightViewMode = .always
        button.addTarget(self, action: #selector(showHidePassword(_:)), for: .touchUpInside)
    }
    
    @objc private func showHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }
    
}

//@IBDesignable
//public class KTextField: UITextField {
//    
//    @IBInspectable public var borderWidth: CGFloat = 0.0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//    
//    @IBInspectable public var borderColor: UIColor = .clear {
//        didSet {
//            layer.borderColor = borderColor.cgColor
//        }
//    }
//    
//    /// Make the corners rounded with the specified radius
//    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//        }
//    }
//    
//    /// Sets the placeholder color
//    @IBInspectable public var placeholderColor: UIColor = .lightGray {
//        didSet {
//            let placeholderStr = placeholder ?? ""
//            attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
//        }
//    }
//    
//    public override var placeholder: String? {
//        didSet {
//            let placeholderStr = placeholder ?? ""
//            attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
//        }
//    }
//    
//    /// Sets left margin
//    @IBInspectable public var leftMargin: CGFloat = 10.0 {
//        didSet {
//            setMargins()
//        }
//    }
//    
//    /// Sets right margin
//    @IBInspectable public var rightMargin: CGFloat = 10.0 {
//        didSet {NSAttributedString.Key.foregroundColor
//            setMargins()
//        }
//    }
//    
//    // MARK: - init methods
//    override public init(frame: CGRect) {
//        super.init(frame: frame)
//        applyStyles()
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        applyStyles()
//    }
//    
//    // MARK: - Layout
//    override public func layoutSubviews() {
//        super.layoutSubviews()
//        // updateUnderLineFrame()
//        updateAccessoryViewFrame()
//    }
//    
//    // MARK: - Styles
//    private func applyStyles() {
//        // applyUnderLine()
//        setMargins()
//    }
//    
//    // MARK: - Margins
//    private var leftAcessoryView = UIView()
//    private var rightAcessoryView = UIView()
//    private func setMargins() {
//        // Left Margin
//        leftView = nil
//        leftViewMode = .never
//        if leftMargin > 0 {
//            if nil == leftView {
//                leftAcessoryView.backgroundColor = .clear
//                leftView = leftAcessoryView
//                leftViewMode = .always
//            }
//        }
//        updateAccessoryViewFrame()
//        
//        // Right Margin
//        rightView = nil
//        rightViewMode = .never
//        if rightMargin > 0 {
//            if nil == rightView {
//                rightAcessoryView.backgroundColor = .clear
//                rightView = rightAcessoryView
//                rightViewMode = .always
//            }
//            updateAccessoryViewFrame()
//        }
//    }
//    
//    private func updateAccessoryViewFrame() {
//        // Left View Frame
//        var leftRect = bounds
//        leftRect.size.width = leftMargin
//        leftAcessoryView.frame = leftRect
//        // Right View Frame
//        var rightRect = bounds
//        rightRect.size.width = rightMargin
//        rightAcessoryView.frame = rightRect
//    }
//}
