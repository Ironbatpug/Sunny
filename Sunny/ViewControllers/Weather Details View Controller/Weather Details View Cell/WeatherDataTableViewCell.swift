//
//  WeatherDataTableViewCell.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 04..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class WeatherDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var maxTempValueLabel: UILabel!
    @IBOutlet weak var minTempValueLabel: UILabel!
    @IBOutlet weak var sunRiseDate: UILabel!
    @IBOutlet weak var sunSetDate: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configureCell(maxTempeture maxTemp: String, minTempeture minTemp: String, sunRise sunRiseDate: Date, sunSet sunSetDate: Date, weatherimageName: String) {
        self.maxTempValueLabel.text = maxTemp + " °C"
        self.minTempValueLabel.text = minTemp + " °C"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm:ss"
        
        self.sunRiseDate.text = dateFormatter.string(from: sunRiseDate)
        self.sunSetDate.text = dateFormatter.string(from: sunSetDate)
        self.weatherImage.image = UIImage(named: weatherimageName)
    }

}
