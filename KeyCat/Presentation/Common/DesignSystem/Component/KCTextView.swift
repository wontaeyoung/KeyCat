//
//  KCTextView.swift
//  KeyCat
//
//  Created by 원태영 on 4/30/24.
//

import UIKit
import SnapKit

final class KCTextView: UITextView {
  
  private var maxLength: Int?
  
  init(placeholder: String? = nil, maxLength: Int? = nil, isResponder: Bool = false) {
    super.init(frame: .zero, textContainer: nil)
    
    self.configure {
      $0.font = KCAsset.Font.contentText
      $0.textColor = KCAsset.Color.black
      $0.tintColor = KCAsset.Color.brand
      $0.textAlignment = .natural
      $0.autocapitalizationType = .none
      $0.autocorrectionType = .no
      $0.spellCheckingType = .no
      $0.showsHorizontalScrollIndicator = false
      $0.showsVerticalScrollIndicator = false
      $0.delegate = $0
      $0.applyLineSpacing()
      
      $0.addSubviews(placeholderLabel)
      
      $0.layer.configure {
        $0.cornerRadius = 10
        $0.borderWidth = 1
        $0.borderColor = KCAsset.Color.lightGrayBackground.cgColor
      }
      
      if isResponder { $0.becomeFirstResponder() }
      self.maxLength = maxLength
    }
    
    placeholderLabel.configure {
      $0.text = placeholder
      
      $0.snp.makeConstraints { make in
        make.top.equalTo(self).inset(textContainerInset.top)
        make.horizontalEdges.equalTo(self).inset(textContainerInset.top * 0.75)
        make.bottom.greaterThanOrEqualTo(self).inset(textContainerInset.bottom)
      }
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var placeholderLabel = UILabel().configured {
    $0.font = font
    $0.textColor = KCAsset.Color.lightGrayForeground
    $0.numberOfLines = 0
    $0.textAlignment = .natural
  }
}

extension KCTextView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    togglePlaceholderVisibility()
    applyLineSpacing()
  }
  
  /* 다시 조절
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard let maxLength else { return true }
    
    return self.text.count < maxLength
  }
   */
}

extension KCTextView {
  private func togglePlaceholderVisibility() {
    guard let text = self.text else { return }
    
    placeholderLabel.isHidden = text.isFilled
  }
  
  private func applyLineSpacing() {
    guard let text = self.text else { return }
    
    let style = NSMutableParagraphStyle().configured {
      $0.lineSpacing = 10
    }
    
    self.attributedText = NSMutableAttributedString(string: text).configured {
      let range = NSRange(location: 0, length: $0.length)
      
      $0.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
      $0.addAttribute(NSAttributedString.Key.font, value: KCAsset.Font.contentText, range: range)
    }
  }
}
