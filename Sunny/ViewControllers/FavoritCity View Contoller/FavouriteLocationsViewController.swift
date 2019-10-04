//
//  FavouriteLocationsViewController.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 04..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class FavouriteLocationsViewController: UIViewController {
    @IBOutlet weak var favoriteTableView: UITableView!
    var cities = [Location]()


    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
    }
    
    func initData(forLocations locations: [Location]) {
        cities = locations
    }
    
}

extension FavouriteLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCityTableViewCell") as? FavoriteCityTableViewCell else { return UITableViewCell()}
        let location = cities[indexPath.row]
        let cityName = location.city
        cell.configureCell(cityName: cityName)
        return cell
    }
}
