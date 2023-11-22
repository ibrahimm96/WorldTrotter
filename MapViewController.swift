import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var isMapRegionChangingByUser = false

    override func loadView() {
        mapView = MKMapView()
        mapView.delegate = self
        view = mapView

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Add Segmented Control
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)

        // Segmented Control Constraints
        let segTopConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let segLeadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let segTrailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        segTopConstraint.isActive = true
        segLeadingConstraint.isActive = true
        segTrailingConstraint.isActive = true

        // Add Switch
        let pointOfInterestSwitch = UISwitch()
        pointOfInterestSwitch.addTarget(self, action: #selector(pointOfInterestToggle(_:)), for: .valueChanged)
        pointOfInterestSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pointOfInterestSwitch)

        // Switch Constraints
        let switchTopConstraint = pointOfInterestSwitch.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8)
        let switchLeadingConstraint = pointOfInterestSwitch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        switchTopConstraint.isActive = true
        switchLeadingConstraint.isActive = true

        // Add Switch's Label
        let switchLabel = UILabel()
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        switchLabel.text = "Points of Interest"
        switchLabel.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(switchLabel)

        let switchLabelTopConstraint = switchLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 15)
        let switchLabelLeadingConstraint = switchLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80)
        switchLabelTopConstraint.isActive = true
        switchLabelLeadingConstraint.isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0].coordinate

        // Check if the map is not manually moved by the user
        if !isMapRegionChangingByUser {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: userLocation, span: span)
            mapView.setRegion(region, animated: true)
        }

        mapView.showsUserLocation = true
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        // The map region is about to change
        isMapRegionChangingByUser = true
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // The map region changed
        isMapRegionChangingByUser = false
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }

    @objc func pointOfInterestToggle(_ sender: UISwitch) {
        if sender.isOn {
            mapView.pointOfInterestFilter = .includingAll
            print("Switch Toggled ONN")
        } else {
            mapView.pointOfInterestFilter = .excludingAll
            print("Switch Toggled OFF")
        }
    }
}

