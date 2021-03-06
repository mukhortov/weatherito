import Foundation
import ForecastKit

public struct ForecastEntity {
    
    public var summary: String = ""
    public var temperature: Float = 0.0
    
}

// MARK: - Init

internal extension ForecastEntity {
    
    init(forecast: Forecast) {
        self.summary = forecast.summary
        self.temperature = forecast.temperature
    }
    
}

// MARK: - Data

internal extension ForecastEntity {
    
    internal func toData() -> Data {
        var dictionary: [String: AnyObject] = [:]
        dictionary["temperature"] = self.temperature as AnyObject?
        dictionary["summary"] = self.summary as AnyObject?
        return try! JSONSerialization.data(withJSONObject: dictionary, options: [])
    }
    
    internal init?(data: Data) {
        guard let  object = try? JSONSerialization.jsonObject(with: data, options: []),
            let dictionary: [String: AnyObject] = object as? [String: AnyObject],
            let temperature = dictionary["temperature"] as? Float,
            let summary = dictionary["summary"] as? String else { return nil }
        self.temperature = temperature
        self.summary = summary
    }
    
}
