import Foundation

class PairingCodeGenerator {
    static func generateCode(with digits: Int = 6, generator: RandomNumberGenerator = RandomNumberGenerator()) -> String {
        var code = ""
        for _ in Range(0...digits) {
            let randomInt = generator.generateInt(to: 10)
            code.append(String(randomInt))
        }
        return code
    }
}
