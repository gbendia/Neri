import Foundation
import CoreMotion

class MotionMeter {
    
    static let singleton = MotionMeter()
    private let MAX_NUMBER_OF_EVALUATIONS = 20
    private let ACCELETOMETER_CEILING = 3.0
    
    private let motionManager = CMMotionManager()
    private var delegate: MotionMeterDelegate?
    
    private var currentState = EvaluationState.NothingDetected
    
    private var xAccArray = [Double]()
    private var yAccArray = [Double]()
    private var zAccArray = [Double]()
        
    private var axisToEvaluate = [[Double]]()
    private var numberOfTimesEvaluated = 0
    
    private var notifiedFall = false
    private var isActive = false
    
    private init() {
        motionManager.deviceMotionUpdateInterval = 0.2
        notifyOK()
    }
    
    func startFetching() {
        if (!isActive) {
            print("Started fetchin motion data")
            isActive = true
            motionManager.startDeviceMotionUpdates(to: OperationQueue()) { (deviceMotion: CMDeviceMotion?, error: Error?) in
                if error != nil {
                   print("Encountered error: \(error!)")
                }
                if deviceMotion != nil {
                    self.evaluateMotionData(deviceMotion!)
                }
            }
        }
    }

    private func evaluateMotionData(_ motion: CMDeviceMotion) {
        let xAcc = motion.userAcceleration.x
        let yAcc = motion.userAcceleration.y
        let zAcc = motion.userAcceleration.z
        
        xAccArray = append(value: xAcc, to: xAccArray)
        yAccArray = append(value: yAcc, to: yAccArray)
        zAccArray = append(value: zAcc, to: zAccArray)
        
        switch currentState {
        case .NothingDetected:
            if (xAccArray.count > 1 && checkLastValuesCrossed()) {
                self.currentState = .AxisCrossed
            }
            break
        case .AxisCrossed:
            if (numberOfTimesEvaluated > MAX_NUMBER_OF_EVALUATIONS) {
                currentState = .NothingDetected
                numberOfTimesEvaluated = 0
            } else if (evaluatingAxisOvertookCeilingValue()) {
                axisToEvaluate = [[Double]]()
                notifiedFall = false
                currentState = .FallDetected
            }
            numberOfTimesEvaluated += 1
            break
        case .FallDetected:
            if (!notifiedFall) {
                notifyFall()
            }
            break
        }
    }
    
    private func append(value: Double, to array: [Double], max: Int = 30) -> [Double] {
        var auxArray = array
        
        if (array.count < max) {
            auxArray.append(value)
        } else {
            auxArray = Array(array[1...])
            auxArray.append(value)
        }
        
        return auxArray
    }
    
    private func checkLastValuesCrossed() -> Bool {
        axisToEvaluate = [[Double]]()
        
        var appendedX = false
        var appendedY = false
        var appendedZ = false
        
        if (xAndYCrossed()) {
            if (!appendedX) {
                axisToEvaluate.append(xAccArray)
                appendedX = true
            }
            if (!appendedY) {
                axisToEvaluate.append(yAccArray)
                appendedY = true
            }
        }
        if (xAndZCrossed()) {
            if (!appendedX) {
                axisToEvaluate.append(xAccArray)
                appendedX = true
            }
            if (!appendedZ) {
                axisToEvaluate.append(zAccArray)
                appendedZ = true
            }
        }
        if (yAndZCrossed()) {
            if (!appendedY) {
                axisToEvaluate.append(yAccArray)
                appendedY = true
            }
            if (!appendedZ) {
                axisToEvaluate.append(zAccArray)
                appendedZ = true
            }
        }
        
        return axisToEvaluate.count > 0
    }
    
    private func xAndYCrossed() -> Bool {
        if (((xAccArray[xAccArray.count-2] < yAccArray[yAccArray.count-2]) && (xAccArray[xAccArray.count-1] > yAccArray[yAccArray.count-1])) || ((xAccArray[xAccArray.count-2] > yAccArray[yAccArray.count-2]) && (xAccArray[xAccArray.count-1] < yAccArray[yAccArray.count-1]))) {
            return true
        }
        return false
    }
    
    private func xAndZCrossed() -> Bool {
        if (((xAccArray[xAccArray.count-2] < zAccArray[zAccArray.count-2]) && (xAccArray[xAccArray.count-1] > zAccArray[zAccArray.count-1])) || ((xAccArray[xAccArray.count-2] > zAccArray[zAccArray.count-2]) && (xAccArray[xAccArray.count-1] < zAccArray[zAccArray.count-1]))) {
            return true
        }
        return false
    }
    
    private func yAndZCrossed() -> Bool {
        if (((yAccArray[yAccArray.count-2] < zAccArray[zAccArray.count-2]) && (yAccArray[yAccArray.count-1] > zAccArray[zAccArray.count-1])) || ((yAccArray[yAccArray.count-2] > zAccArray[zAccArray.count-2]) && (yAccArray[yAccArray.count-1] < zAccArray[zAccArray.count-1]))) {
            return true
        }
        return false
    }
    
    private func evaluatingAxisOvertookCeilingValue() -> Bool {
        for array in axisToEvaluate {
            for value in array {
                if (abs(value) > ACCELETOMETER_CEILING) {
                    return true
                }
            }
        }
        return false
    }
    
    private func notifyFall() {
        print("NOTIFING FALL")
        delegate?.fallDetected()
        notifiedFall = true
        ConnectivitySession.singleton.sendData("fallDetected", true)
    }
    
    private func notifyOK() {
        notifiedFall = false
        ConnectivitySession.singleton.sendData("fallDetected", false)
    }
    
    func setOkState() {
        notifyOK()
        currentState = .NothingDetected
    }
    
    func setDelegate(_ delegate: MotionMeterDelegate) {
        self.delegate = delegate
    }
    
    func toggle() {
        if (isActive) {
            print("Stoping fetching motion data")
            motionManager.stopDeviceMotionUpdates()
        } else {
            startFetching()
        }
        
        isActive = !isActive
    }
    
    private enum EvaluationState {
        case NothingDetected
        case AxisCrossed
        case FallDetected
    }

}

protocol MotionMeterDelegate {
    func fallDetected()
}
