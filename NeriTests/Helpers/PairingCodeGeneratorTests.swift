import XCTest
import Foundation
@testable import Neri

class PairingCodeGeneratorTests: XCTestCase {

    let zeroIntGenerator = RandomNumberGeneratorMockAlwaysZero()

    /*
     * Given a number generator generating only zeros,
     * when generating a pairing code with default size,
     * then the code returned should have only zeros.
     */
    func testPairingCodeWithDefaultSizeShouldBeAbleToStartWithZeroTest() {
        let expectedCode = "000000"
        let generatedCode = PairingCodeGenerator.generate(generator: zeroIntGenerator)
        
        XCTAssertEqual(generatedCode, expectedCode)
    }

    /*
     * Given a number generator generating numbers normally,
     * when generating a pairing code with 10 digits,
     * then the code returned should have size equals to 10.
     */
    func testGenerateCodeWithTwoDigitsNumberGenerator() {
        let expectedCodeSize = 10
        let generatedCode = PairingCodeGenerator.generate(with: 10)
        
        XCTAssertEqual(generatedCode.count, expectedCodeSize)
    }

}
