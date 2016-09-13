import UIKit
import WeatheritoKit

class ViewController: UIViewController {

    // MARK: - Attributes
    
    var service: WeatherService!
    var observable: WeatherObservable!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.service = WeatherService(appKey: "b556da9252961da55f49c101b1af2d8a")
        self.observable = WeatherObservable(observer: { [weak self] forecast in
            self?.forecastUpdated(forecast)
            
            })
        self.service.sync { error in
            if let error = error {
                print("Error synchronizing weather: \(error)")
            }
        }
    }
    
    // MARK: - Private
    
    func forecastUpdated(_ forecast: ForecastEntity) {
        let celsius = (forecast.temperature - 32) * 5/9
        self.temperatureLabel.text = "\(celsius) °C"
        self.summaryLabel.text = forecast.summary
    }
}

