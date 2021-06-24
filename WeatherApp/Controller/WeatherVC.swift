//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by Abhiram Sarvadevabhatla on 24/06/21.
//

import UIKit

class WeatherVC: UIViewController {
    
    
    var cityName : String = ""
    let raidus : CGFloat = 120.0
    var weatherViewModel = WeatherViewModel(weatherAPI: WeatherService())
    let dispatchGroup = DispatchGroup()
    @IBOutlet weak var sunSetLbl: UILabel!
    
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunriseSunsetVw: UIView!
    @IBOutlet weak var temparatureLbl: UILabel!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var minTempLbl: UILabel!
    
    @IBOutlet weak var backgroundImageVw: UIImageView!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var statusImgVw: UIImageView!
    @IBOutlet weak var weatherNameMainLbl: UILabel!
    
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    
    @IBOutlet weak var activityInd: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispatchGroup.enter()
        activityInd.startAnimating()
        weatherViewModel.fetchWeatherData(cityName: cityName)
        
        
        self.weatherViewModel.didFinishFetch = {(weather : WeatherModel?) in
            if let weather = weather {
                self.dispatchGroup.notify(queue: .main) {
                    self.temparatureLbl.text = weather.temperatureString
                    self.weatherNameMainLbl.text = weather.mainDesc
                    self.maxTempLbl.text = weather.maxTempString
                    self.minTempLbl.text = weather.minTempString
                    self.humidity.text = weather.humidityString
                    self.windLbl.text = weather.winSpeedString
                    self.cityNameLbl.text = weather.cityName
                    self.backgroundImageVw.image = UIImage(named:weather.updateBackgroundImage(description: weather.description))
                    
                    let sunriseTime = Date(timeIntervalSince1970: (weather.sunrise))
                    let sunsetTime = Date(timeIntervalSince1970: (weather.sunset))
                    let currentTime = Date()
                    
                    let elapsedTime = currentTime.timeIntervalSince(sunriseTime)
                    let yetToCoverTime = sunsetTime.timeIntervalSince(sunriseTime)
                    
                    var angle = 0.0
                    if elapsedTime < 0 {
                        angle = .pi
                    } else {
                        angle = (elapsedTime/yetToCoverTime)
                        if angle >= 1 {
                            angle = 1
                        }
                    }
                    print(angle)
                    
                    let formatter = DateFormatter()
                    formatter.dateStyle = .none
                    formatter.timeStyle = .short
                    formatter.dateFormat = "HH:mm"
                    formatter.timeZone = TimeZone(secondsFromGMT: Int(weather.timezone))
                    
                    
                    
                    let formattedSunriseTime = formatter.string(from: sunriseTime)
                    let formattedSunsetTime = formatter.string(from: sunsetTime)
                    let formattedCurrentTime = formatter.string(from: currentTime)
                    
                    print(formattedSunriseTime)
                    print(formattedSunsetTime)
                    print(formattedCurrentTime)
                    
                    self.addSunriseAndSunsetView(sunriseTime: formattedSunriseTime, sunsetTime: formattedSunsetTime,angle: angle)
                    
                }
            }
            do {
                DispatchQueue.main.async {
                    self.activityInd.stopAnimating()
                }
                self.dispatchGroup.leave()
            }
            
        }
        self.weatherViewModel.showAlertClosure = {
            self.activityInd.stopAnimating()
            if self.weatherViewModel.error != nil  {
                do {
                    print(self.weatherViewModel.error?.localizedDescription ?? "")
                    self.dispatchGroup.leave()
                }
            }
        }
    }
    
    func addSunriseAndSunsetView(sunriseTime : String, sunsetTime : String, angle : Double) {
        
        sunriseLbl.text = sunriseTime
        sunSetLbl.text = sunsetTime
        
        drawSemiCircle(angle: angle)
        addLine(fromPoint: CGPoint.init(x: self.sunriseSunsetVw.frame.origin.x + 20, y: self.sunriseSunsetVw.frame.size.height - 50), toPoint: CGPoint.init(x: self.sunriseSunsetVw.frame.width - 20, y: self.sunriseSunsetVw.frame.size.height - 50))
        
    }
    
    func drawSemiCircle(angle: Double) {
        
        
        let point = CGPoint.init(x: self.sunriseSunsetVw.frame.size.width/2, y: self.sunriseSunsetVw.frame.size.height - 50)
        
        let path = UIBezierPath(arcCenter: point, radius: raidus, startAngle: .pi, endAngle: 0, clockwise: true)

        var endAngle1 = .pi * CGFloat(angle)
        if angle == .pi {
            endAngle1 = .pi
        } else {
            endAngle1 = -.pi * CGFloat(1.0 - angle)
        }
        let path1 = UIBezierPath(arcCenter: point, radius: raidus, startAngle: .pi, endAngle: endAngle1, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineDashPattern = [6,6]
        self.sunriseSunsetVw.layer.addSublayer(shapeLayer)
        
        
        let imageSunName = "Sun"
        let imageSun = UIImage(named: imageSunName)
        let imageView = UIImageView(image: imageSun)
        imageView.frame = CGRect(x: path1.currentPoint.x-20, y: path1.currentPoint.y-20, width: 40, height: 40)
        
        self.sunriseSunsetVw.addSubview(imageView)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path1.cgPath
        animation.repeatCount = 0
        animation.duration = 1.0
        imageView.layer.add(animation, forKey: "animate along path")
        
    }
    func addLine(fromPoint start: CGPoint, toPoint end:CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.white.cgColor
        line.lineWidth = 1
        line.lineJoin = CAShapeLayerLineJoin.round
        self.sunriseSunsetVw.layer.addSublayer(line)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }

}
