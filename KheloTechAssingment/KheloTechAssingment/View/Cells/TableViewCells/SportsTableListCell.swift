//
//  SportsTableListCell.swift
//  KheloTechAssingment
//
//  Created by Abhinav on 26/10/24.
//

import UIKit

class SportsTableListCell: UITableViewCell {
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.layer.cornerRadius = 12
        viewContainer.layer.borderColor = UIColor.systemGray4.cgColor
        viewContainer.layer.borderWidth = 1
        self.selectionStyle = .none
        
        viewContainer.clipsToBounds = false
        viewContainer.layer.shadowColor = UIColor.white.cgColor
        viewContainer.layer.shadowOpacity = 0.4
        viewContainer.layer.shadowOffset = CGSize.zero
        viewContainer.layer.shadowRadius = 10
        viewContainer.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 12).cgPath
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
