import Foundation

class HeartRateMonitor: Monitor {
    
    func start() {
        
    }
    
    func dangerousHeartRate(for elder: Elder) -> Bool {
        var isDangerous = false
        if (elder.heartRate >= 0) {
            isDangerous = dangerousHeartRateBy(age: elder.age(), heartRate: elder.heartRate)
        }
        return isDangerous
    }
    
    private func dangerousHeartRateBy(age: Int, heartRate: Int) -> Bool {
        let maxWarning = checkMaxHeartRate(age: age, heartRate: heartRate)
        if (maxWarning) {
            return true
        }
        
        var min = 0
        var max = 0
        
        if (age < 30) {
            min = 43
            max = 98
        } else if (age < 40) {
            min = 46
            max = 100
        } else if (age < 50) {
            min = 46
            max = 101
        } else if (age < 60) {
            min = 46
            max = 102
        } else if (age < 70) {
            min = 44
            max = 102
        } else if (age < 80) {
            min = 43
            max = 101
        } else if (age < 90) {
            min = 44
            max = 101
        } else {
            min = 43
            max = 146
        }
        
        return heartRate < min || heartRate > max
    }
    
    private func checkMaxHeartRate(age: Int, heartRate: Int) -> Bool {
        let max = Double(220 - age) * 0.85
        return Double(heartRate) > max
    }
    
}
