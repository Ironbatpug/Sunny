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
        self.sunRiseDate.text = sunRiseDate.dateAsStringFormatted(withDateFormat: "MM-dd HH:mm:ss")
        self.sunSetDate.text = sunSetDate.dateAsStringFormatted(withDateFormat: "MM-dd HH:mm:ss")
        self.weatherImage.image = UIImage(named: weatherimageName)
    }

}
