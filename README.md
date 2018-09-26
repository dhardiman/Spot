# Spot

Simple wrapper around CLLocationManager to make it easy to get the current location of the device.

## Usage
```swift
let service = LocationService()
service.requestLocation { result in
  switch result {
    case .success(let coordinate):
      // use coordinate
    case .failure(let error):
      // handle error
  }
}
```