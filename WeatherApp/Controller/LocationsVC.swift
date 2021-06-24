//
//  LocationsVC.swift
//  WeatherApp
//
//  Created by Abhiram Sarvadevabhatla on 22/06/21.
//

import UIKit

class LocationsVC: UIViewController {
    
    
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var locationsTblVw: UITableView!
    @IBOutlet weak var noCitiesVw: UIView!
    @IBOutlet weak var citiesVw: UIView!
    
    var locationsArray : [String] = []
    let sharedDefaults = UserDefaults.standard
    let sharedDefaultsKey = "locationsArray"

    override func viewDidLoad() {
        super.viewDidLoad()
        locationsTblVw.delegate = self
        locationsTblVw.dataSource = self
        self.notificationLbl.text = "No City data to show, Please add a  city and retry"
        
        if sharedDefaults.value(forKey: sharedDefaultsKey) != nil {
            self.locationsArray = sharedDefaults.value(forKey: sharedDefaultsKey) as! [String]
        }
        let hour = Calendar.current.component(.hour, from: Date())
        print(hour)
        switch hour {
        case 6...18:
            locationsTblVw.backgroundView = UIImageView(image: UIImage(named: "morningBg"))
        case 19...23,0...5:
            locationsTblVw.backgroundView = UIImageView(image: UIImage(named: "nightBg"))
        default:
            locationsTblVw.backgroundView = UIImageView(image: UIImage(named: "morningBg"))
        }
        hideOrShowListOfCities()
        // Do any additional setup after loading the view.
    }
    func hideOrShowListOfCities() {
        if locationsArray.count == 0 {
            self.noCitiesVw.isHidden = false
            self.citiesVw.isHidden = true
        } else {
            self.noCitiesVw.isHidden = true
            self.citiesVw.isHidden = false
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showWeather" {
            let selectedIndexPath = sender as! IndexPath
            print(selectedIndexPath.row)
            let destinationVC = segue.destination as! WeatherVC
            destinationVC.cityName = locationsArray[selectedIndexPath.row]
            
        } else {
            let destinationVC = segue.destination as! AddLocationsVC
            destinationVC.delegate = self
        }
        
    }

}
extension LocationsVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showWeather", sender: indexPath)
    }
 
}

extension LocationsVC : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "locationsCell"
        let  locationsCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! LocationsTblVwCell
        locationsCell.cityName.text = locationsArray[indexPath.row]
        return locationsCell
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locationsArray.remove(at: indexPath.row)
            sharedDefaults.setValue(locationsArray, forKey:sharedDefaultsKey)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            hideOrShowListOfCities()
        }
    }
    
    
}
extension LocationsVC : FetchingCitiesDelegate {
    func getCities(cityName: String?) {
        if let cityName = cityName {
            if !locationsArray.contains(cityName) {
                print(cityName)
                locationsArray.append(cityName)
                sharedDefaults.setValue(locationsArray, forKey: sharedDefaultsKey)
            } else {
                print("Error : City Already Added")
            }
        }
        self.hideOrShowListOfCities()
        self.locationsTblVw.reloadData()
    }
}
