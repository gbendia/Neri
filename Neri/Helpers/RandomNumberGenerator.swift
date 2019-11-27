import Foundation

class RandomNumberGenerator {
    open func generateInt(from floor: Int = 0, to cealing: Int) -> Int {
        return Int(arc4random_uniform(10))
    }
}
