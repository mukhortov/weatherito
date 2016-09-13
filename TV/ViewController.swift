import UIKit
import WeatheritoKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    private var service: WeatherService!
    private var observable: WeatherObservable!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.service = WeatherService(appKey: "b556da9252961da55f49c101b1af2d8a")
        self.service.sync { (error) in
            if let error = error {
                print("Syncing error: \(error)")
            }
        }
        self.observable = WeatherObservable(observer: { [weak self] (entity) in
            self?.summaryLabel.text = entity.summary
            let celsius = (entity.temperature - 32) * 5/9
            self?.temperatureLabel.text = "\(celsius) °C"
        })
    }

}

