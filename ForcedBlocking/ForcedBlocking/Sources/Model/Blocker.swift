import Foundation
import ManagedSettings
import DeviceActivity

struct Blocker {
    
    let store = ManagedSettingsStore()
    let model = BlockingModel.shared
    
    func block(completion: @escaping (Result<Void, Error>) -> Void) {
        let selectedAppTokens = model.selectedAppsTokens
        
        let deviceActivityCenter = DeviceActivityCenter()
        
        let blockSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )
        
        store.shield.applications = selectedAppTokens
        do {
            try deviceActivityCenter.startMonitoring(DeviceActivityName.daily, during: blockSchedule)
        } catch {
            completion(.failure(error))
            return
        }
        completion(.success(()))
    }
    
    func unblockAllApps() {
        store.shield.applications = []
    }
    
}
