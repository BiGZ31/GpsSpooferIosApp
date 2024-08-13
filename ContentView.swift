import SwiftUI
import MapKit
import CoreLocation

// Define a struct to conform to Identifiable
struct IdentifiableCoordinate: Identifiable {
    let id = UUID() // Unique identifier
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.388805, longitude: 2.166614), // Default location
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @StateObject private var locationManager = LocationSimulator()
    
    // Marker for the simulated location
    @State private var simulatedLocation: IdentifiableCoordinate? = nil

    var body: some View {
        NavigationView {
            VStack {
                // Header with location icon and title
                HStack {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    Text("Spoofer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(.top, 20) // Add top padding

                // Map view
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: simulatedLocation != nil ? [simulatedLocation!] : []) { location in
                    MapPin(coordinate: location.coordinate, tint: .red)
                }
                .frame(height: 450) // Adjust height as needed
                .padding(.vertical, 20) // Vertical padding to separate from other content
                .cornerRadius(35)
                
                // Button to simulate location
                Button(action: {
                    let centerCoordinate = region.center
                    locationManager.startSimulatingLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude, altitude: 0)
                    simulatedLocation = IdentifiableCoordinate(coordinate: centerCoordinate)
                }) {
                    Text("Simulate Location")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20) // Padding from bottom

                // Description text
                Text("This is a location simulation app for testing purposes. 👀")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer() // Push content to the top
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Make sure VStack takes full available space
            .padding() // Padding around the VStack
        }
        .onChange(of: locationManager.currentLocation) { newLocation in
            if let newLocation = newLocation {
                region.center = newLocation.coordinate
                simulatedLocation = IdentifiableCoordinate(coordinate: newLocation.coordinate)
            }
        }
    }
}
#Preview {
    ContentView()
}
