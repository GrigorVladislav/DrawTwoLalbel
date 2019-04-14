//
//  ViewController.swift
//  DrawTwoLabel
//
//  Created by Admin on 14.04.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var label1 = UILabel()
    lazy var label2 = UILabel()
    lazy var link = NSRange()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView()
        view.backgroundColor = .white
        let screenWidth = UIScreen.main.bounds.width
        label1.frame = CGRect(x: 0, y: 300, width: screenWidth-200, height: 50)
        label2.frame = CGRect(x: 0, y: 350, width: screenWidth-200, height: 50)
        firstLabel()
        secondLabel()
        view.addSubview(label1)
        view.addSubview(label2)
        
        self.view = view
        
    }
    func firstLabel(){
        let content = "Hello world!"
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 3.0
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        shadow.shadowColor = UIColor.black
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.right
        
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica", size: 34)!,
            .foregroundColor: UIColor.blue,
            .shadow: shadow, .paragraphStyle: style
        ]
        let attributedString = NSMutableAttributedString(string: content, attributes: attr)
        let hello = NSRange(content.startIndex..<content.firstIndex(of: " ")!, in: content)
        let world = NSRange(content.firstIndex(of: " ")!..<content.endIndex, in: content)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: hello)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: world)
        label1.attributedText = attributedString
    }
    
    func secondLabel(){
        let content = "String is a link"
        link = (content as NSString).range(of: "link")
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica", size: 30)!,
            .foregroundColor: UIColor.red, .paragraphStyle: style
        ]
        
        let attributedString = NSMutableAttributedString(string: content, attributes: attr)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: link)
        label2.attributedText = attributedString
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel))
        label2.addGestureRecognizer(gesture)
        label2.isUserInteractionEnabled = true
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {

        if let url = URL(string: "https://www.apple.com") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func drawFirstLine(view: UIView){
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}





