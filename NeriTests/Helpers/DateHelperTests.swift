import XCTest
import Foundation
@testable import Neri

class DateHelperTests: XCTestCase {
    
    /*
     * Given a date with day 11, month 8 and year 2014,
     * when converting this date to string,
     * then should return 11/8/2014.
     */
    func testConvertNormalDateToString() {
        let expectedString = "11/08/2014"
        let dateToBeConverted = generateDate(day: 11, month: 8, year: 2014)
        let stringFromDate = DateHelper.stringFrom(date: dateToBeConverted, as: DateHelper.DATE_ONLY_FORMAT)
        
        XCTAssertEqual(stringFromDate, expectedString)
    }
    
    /*
     * Given a date and time as "2019-05-25 23:59:00",
     * when converting this date to string,
     * then should return 11/8/2014.
     */
    func testConvertDateTimeToString() {
        let expectedString = "2019-05-25 23:59:00"
        let dateTimeToBeConverted = generateDateTime(day: 25, month: 5, year: 2019, hours: 23, minutes: 59, seconds: 00)
        let stringFromDate = DateHelper.stringFrom(date: dateTimeToBeConverted, as: DateHelper.DATE_TIME_FORMAT)
        
        XCTAssertEqual(stringFromDate, expectedString)
    }
    
    /*
     * Given a date with a one digit month formated as a string("11/8/2014"),
     * when converting this string to Date,
     * then should return a date equals to August 11th of 2014.
     */
    func testConvertStringWithOneDigitMonthToDate() {
        let expectedDate = generateDate(day: 11, month: 8, year: 2014)
        let stringToBeConverted = "11/8/2014"
        let dateFromString = DateHelper.dateFrom(string: stringToBeConverted, format: DateHelper.DATE_ONLY_FORMAT)
        
        XCTAssertEqual(dateFromString, expectedDate)
    }
    
    /*
     * Given a date with a two digits month formated as a string("10/10/2014"),
     * when converting this string to Date,
     * then should return a date equals to October 10th of 2014.
     */
    func testConvertStringWithTwoDigitsMonthToDate() {
        let expectedDate = generateDate(day: 10, month: 10, year: 2014)
        let stringToBeConverted = "10/10/2014"
        let dateFromString = DateHelper.dateFrom(string: stringToBeConverted, format: DateHelper.DATE_ONLY_FORMAT)
        
        XCTAssertEqual(dateFromString, expectedDate)
    }
    
    /*
     * Given a date and time formated as a string,
     * when converting this string to Date,
     * then should return a date equals to the equivalent date of the string.
     */
    func testConvertStringDateAndTimeToDate() {
        let expectedDateTime = generateDateTime(day: 11, month: 8, year: 2019, hours: 15, minutes: 23, seconds: 57)
        let stringToBeConverted = "2019-08-11 15:23:57"
        let dateFromString = DateHelper.dateFrom(string: stringToBeConverted, format: DateHelper.DATE_TIME_FORMAT)
        
        XCTAssertEqual(dateFromString, expectedDateTime)
    }
    
    private func generateDate(day: Int, month: Int, year: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)!
    }
    
    private func generateDateTime(day: Int, month: Int, year: Int, hours: Int, minutes: Int, seconds: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hours
        dateComponents.minute = minutes
        dateComponents.second = seconds
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)!
    }
    
}
