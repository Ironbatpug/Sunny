//
//  FavoriteCityTableViewCell.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 05..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class FavoriteCityTableViewCell: UITableViewCell {
    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(cityName: String){
        self.cityName.text = cityName
    }
}
