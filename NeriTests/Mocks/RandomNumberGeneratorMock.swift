import Foundation
@testable import Neri

class RandomNumberGeneratorMockAlwaysZero: RandomNumberGenerator {
    override func generateInt(from floor: Int = 0, to cealing: Int) -> Int {
        return 0
    }
}
