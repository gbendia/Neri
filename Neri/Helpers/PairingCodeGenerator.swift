import Foundation

class PairingCodeGenerator {
    static func generate(with digits: Int = 6, generator: RandomNumberGenerator = RandomNumberGenerator()) -> String {
        var code = ""
        for _ in Range(1...digits) {
            let randomInt = generator.generateInt(to: 10)
            code.append(String(randomInt))
        }
        return code
    }
}
