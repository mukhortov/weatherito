import Foundation

public class WeatherObservable: NSObject {
    
    // MARK: - Attributes
    
    internal let userDefaults: UserDefaults
    internal let observer: (ForecastEntity) -> Void
    
    // MARK: - Init
    
    public init(userDefaults: UserDefaults = UserDefaults.standard, observer: @escaping (ForecastEntity) -> Void) {
        self.userDefaults = userDefaults
        self.observer = observer
        super.init()
        self.userDefaults.addObserver(self,
                                      forKeyPath: Keys.Forecast.rawValue,
                                      options: NSKeyValueObservingOptions.new,
                                      context: nil)
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        self.notifyObserverIfData()
    }
    
    private func notifyObserverIfData() {
        guard let data = self.userDefaults.value(forKey: Keys.Forecast.rawValue) as? Data,
            let forecast = ForecastEntity(data: data) else { return }
        DispatchQueue.main.async { [weak self] in 
            self?.observer(forecast)
        }
    }
    
    // MARK: - Private

    deinit {
        self.userDefaults.removeObserver(self, forKeyPath: Keys.Forecast.rawValue)
    }
}
