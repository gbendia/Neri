import Foundation
import HealthKit

class HeartRateMeter: NSObject, HKWorkoutSessionDelegate {
    
    static let singleton = HeartRateMeter()
    
    override private init() {
        super.init()
    }
    
    private let healthStore = HKHealthStore()
    private var heartRateDelegate: HeartRateDelegate?
    
    // State of the app - is the workout activated
    private var workoutActive = false
    private var toggledWorkout = false
    
    // Define the activity type and location
    private var session: HKWorkoutSession?
    private let heartRateUnit = HKUnit(from: "count/min")
    private var anchor = HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
    private var currentQuery: HKQuery?
    
    func startFetching() {
        if (!toggledWorkout) {
            guard HKHealthStore.isHealthDataAvailable() == true else {
                print("HealthKit not authorized.")
                return
            }
            
            guard let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
                print("HealthKit not authorized.")
                return
            }
            
            let dataTypes = Set(arrayLiteral: quantityType)
            healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
                if success == false {
                    print("HealthKit not authorized.")
                }
            }
            
            if (self.workoutActive) {
                
            } else {
                // Start a new workout session to be able to fetch heart rate
                self.workoutActive = true
                startWorkout()
            }
        }
    }
    
    internal func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            workoutDidStart(date)
        case .ended:
            workoutDidEnd(date)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    internal func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // Do nothing for now
        print("Workout error")
    }
    
    
    private func workoutDidStart(_ date : Date) {
        if let query = createHeartRateStreamingQuery(date) {
            self.currentQuery = query
            healthStore.execute(query)
        }
    }
    
    private func workoutDidEnd(_ date : Date) {
        healthStore.stop(self.currentQuery!)
        session = nil
    }
    
    private func startWorkout() {
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return
        }
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .crossTraining
        workoutConfiguration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            session?.delegate = self
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
        self.session?.startActivity(with: Date())
    }
    
    private func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery? {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            self.updateHeartRate(sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            self.updateHeartRate(samples)
        }
        return heartRateQuery
    }
    
    private func updateHeartRate(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        
        DispatchQueue.main.async {
            guard let sample = heartRateSamples.first else{return}
            let heartRate = Int(sample.quantity.doubleValue(for: self.heartRateUnit))
            self.heartRateDelegate!.heartRateUpdated(heartRate: heartRate)
        }
    }
    
    private func stopWorkout() {
        self.workoutActive = false
        
        if let workout = self.session {
            workout.end()
        }
    }
    
    func toggle() {
        if (workoutActive) {
            stopWorkout()
            toggledWorkout = true
        } else {
            toggledWorkout = false
            startFetching()
        }
    }
    
    func isActive() -> Bool {
        return workoutActive
    }
    
    func setHeartRateDelegate(_ delegate: HeartRateDelegate) {
        self.heartRateDelegate = delegate
    }
    
}

protocol HeartRateDelegate {
    func heartRateUpdated(heartRate: Int)
}
