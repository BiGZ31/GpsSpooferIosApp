import CoreLocation
import Combine

class LocationSimulator: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation? = nil

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func startSimulatingLocation(latitude: Double, longitude: Double, altitude: Double) {
        // Create a CLLocation with the correct initializer
        currentLocation = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            altitude: altitude,
            horizontalAccuracy: 0,
            verticalAccuracy: 0,
            timestamp: Date()
        )
        // Notify CLLocationManager to simulate location updates
        locationManager.startUpdatingLocation()
    }

    func stopSimulatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = currentLocation {
            // Use the simulated location instead of the real location
            currentLocation = newLocation
        }
    }
}
