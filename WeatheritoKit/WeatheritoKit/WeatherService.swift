import Foundation
import ForecastKit
import LocationKit
import CoreLocation

public class WeatherService {
    
    // MARK: - Properties
    
    internal let locationManager: LocationManager
    internal let forecastClient: ForecastClient
    internal let userDefaults: UserDefaults
    
    // MARK: - Init
    
    public init(appKey: String, userDefaults: UserDefaults = UserDefaults.standard) {
        self.locationManager = LocationManager()
        self.forecastClient = ForecastClient(appKey: appKey)
        self.userDefaults = userDefaults
    }
    
    // MARK: - Public
    
    public func sync(completion: @escaping (Error?) -> Void) {
        self.locationManager.authorize { [weak self] status in
            if status != .authorizedWhenInUse { return }
            self?.locationManager.location(observer: { [weak self] (location) in
                let latitude = Double(location.coordinate.latitude)
                let longitude = Double(location.coordinate.longitude)
                self?.forecastClient.fetch(latitude: latitude, longitude: longitude, completion: { (forecast, error) in
                    if let forecast = forecast {
                        self?.save(forecast: forecast)
                    }
                    completion(error)
                })
            })
        }
    }
    
    // MARK: - Private
    
    private func save(forecast: Forecast) {
        let data = ForecastEntity(forecast: forecast).toData()
        self.userDefaults.setValue(data, forKey: Keys.Forecast.rawValue)
        self.userDefaults.synchronize()
    }
    
}
