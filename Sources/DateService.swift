import Foundation

protocol DateFormatterProtocol {
    var timeZone: TimeZone! { get set }
    var dateFormat: String! { get set }
    func string(from date: Date) -> String
    
}

extension DateFormatter: DateFormatterProtocol {
    
    static func dateFormatterFactory() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter
    }
    
    static func amzDateFormatterFactory() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmssZZZZZ"
        dateFormatter.timeZone =  TimeZone(abbreviation: "GMT")
        return dateFormatter
    }
}

protocol DateServiceProtocol {
    func getDate() -> String
    func getAmzDate() -> String
}

class DateService: DateServiceProtocol {
    internal var date: Date
    internal var amzDateFormatter: DateFormatterProtocol
    internal var dateFormatter: DateFormatterProtocol

    init(date: Date, dateFormatter: DateFormatterProtocol, amzDateFormatter: DateFormatterProtocol) {
        self.date = date
        self.dateFormatter = dateFormatter
        self.amzDateFormatter = amzDateFormatter
    }
    
    func getDate() -> String {
        return dateFormatter.string(from: date)
    }
    
    func getAmzDate() -> String {
        return amzDateFormatter.string(from: date)
    }
}
