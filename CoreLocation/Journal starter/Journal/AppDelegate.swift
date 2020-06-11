/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  let center = UNUserNotificationCenter.current()
  let locationManager = CLLocationManager()
  static let geoCoder = CLGeocoder()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let rayWenderlichColor = UIColor(red: 0/255, green: 104/255, blue: 55/255, alpha: 1)
    UITabBar.appearance().tintColor = rayWenderlichColor

    center.requestAuthorization(options: [.alert, .sound]) { granted, error in

    }
    locationManager.requestAlwaysAuthorization()
    locationManager.startMonitoringVisits()
    locationManager.delegate = self
    locationManager.distanceFilter = 35
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.startUpdatingLocation()

    return true
  }
}

extension AppDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    let clLocation = CLLocation(latitude: visit.coordinate.latitude , longitude: visit.coordinate.longitude)

    AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
      if let place = placemarks?.first {
        let description = "\(place)"
        self.newVisitReceived(visit, description: description)
      }
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }

    AppDelegate.geoCoder.reverseGeocodeLocation(location) { placemark, _ in
      if let place = placemark?.first {
        let description = "Fake visit: \(place)"
        let fakeVisit = FakeVisit(coordinates: location.coordinate, arrivalDate: Date(), departureDate: Date())
        self.newVisitReceived(fakeVisit, description: description)
      }
    }
  }

  func newVisitReceived(_ visit: CLVisit, description: String) {
    let location = Location(visit: visit, descriptionString: description)
    LocationsStorage.shared.saveLocationOnDisk(location)

    let content = UNMutableNotificationContent()
    content.title = "New Journal entry"
    content.body = location.description
    content.sound = .default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: location.description, content: content, trigger: trigger)

    center.add(request, withCompletionHandler: nil)
  }
}

final class FakeVisit: CLVisit {
  private let myCoordinates: CLLocationCoordinate2D
  private let myArrivalDate: Date
  private let myDepartureDate: Date

  override var coordinate: CLLocationCoordinate2D {
    return myCoordinates
  }

  override var arrivalDate: Date {
    return myArrivalDate
  }

  override var departureDate: Date {
    return myDepartureDate
  }

  init(coordinates: CLLocationCoordinate2D, arrivalDate: Date, departureDate: Date) {
    myCoordinates = coordinates
    myArrivalDate = arrivalDate
    myDepartureDate = departureDate
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
