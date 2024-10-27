//
//  FilterView.swift
//  KheloTechAssingment
//
//  Created by Abhinav on 27/10/24.
//

import UIKit

class FilterView: UIView {
    @IBOutlet weak var btnCross:UIButton!
    @IBOutlet weak var contentView:UIView!
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          commoninit()
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
          commoninit()
      }
      func commoninit(){
          
          Bundle.main.loadNibNamed("FilterView", owner: self)
          addSubview(contentView)
          contentView.frame = self.bounds
          contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
      }
}
