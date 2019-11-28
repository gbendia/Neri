import Foundation

class DateHelper {
    private init() {}
    
    static func dateFrom(string: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)!
    }
    
    static func stringFrom(date: Date, as format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static let DATE_ONLY_FORMAT = "dd/MM/yyyy"
    static let DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss"
}
