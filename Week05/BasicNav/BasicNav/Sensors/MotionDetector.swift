//
// reads the phone's motion sensors (from 05-BubbleLevel + 05-Seismometer, same file in both)
// pitch = tilting forward/back, roll = tilting left/right, zAcceleration = shaking up/down
// NOTE: the simulator has no sensors, so these stay at 0 there. run it on a real phone

import CoreMotion
import UIKit

// @Observable = any view reading pitch / roll / zAcceleration redraws when they change
@Observable
class MotionDetector {
  // the thing that actually talks to the sensors
  private let motionManager = CMMotionManager()
  // a repeating timer that checks the sensors
  private var timer = Timer()
  // how often to check (0.01 = 100 times a second)
  private var updateInterval: TimeInterval

  // the numbers the views read
  var pitch: Double = 0
  var roll: Double = 0
  var zAcceleration: Double = 0

  // a "call me after every check" hook. the graph uses it to add a point each time
  var onUpdate: (() -> Void) = {}

  // which way the phone is turned, so left/right still makes sense sideways
  private var currentOrientation: UIDeviceOrientation = .landscapeLeft
  private var orientationObserver: NSObjectProtocol? = nil
  let notification = UIDevice.orientationDidChangeNotification

  init(updateInterval: TimeInterval) {
    self.updateInterval = updateInterval
  }

  // turn the sensors on
  func start() {
    if motionManager.isDeviceMotionAvailable {
      motionManager.startDeviceMotionUpdates()
      // every updateInterval seconds, read the newest numbers
      timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
        self.updateMotionData()
      }
    } else {
      // this is what happens in the simulator
      print("Motion data isn't available on this device.")
    }

    // also listen for the phone being turned (portrait, sideways...)
    UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    orientationObserver = NotificationCenter.default.addObserver(
      forName: notification, object: nil, queue: .main
    ) { [weak self] _ in
      switch UIDevice.current.orientation {
      case .faceUp, .faceDown, .unknown:
        // flat or unknown = keep the last one
        break
      default:
        self?.currentOrientation = UIDevice.current.orientation
      }
    }
  }

  // copy the latest sensor numbers into my variables
  func updateMotionData() {
    if let data = motionManager.deviceMotion {
      // fix roll/pitch for whichever way the phone is turned
      (roll, pitch) = currentOrientation.adjustedRollAndPitch(data.attitude)
      zAcceleration = data.userAcceleration.z
      onUpdate()
    }
  }

  // turn everything off (saves battery when you leave the page)
  func stop() {
    motionManager.stopDeviceMotionUpdates()
    timer.invalidate()
    if let orientationObserver = orientationObserver {
      NotificationCenter.default.removeObserver(orientationObserver, name: notification, object: nil)
    }
    orientationObserver = nil
  }

  // deinit = runs when this gets thrown away. stop just in case
  deinit {
    stop()
  }
}

extension MotionDetector {
  // start + give me back the detector, handy for #Preview
  func started() -> MotionDetector {
    start()
    return self
  }
}

extension UIDeviceOrientation {
  // swap / flip roll and pitch depending on how the phone is held
  func adjustedRollAndPitch(_ attitude: CMAttitude) -> (roll: Double, pitch: Double) {
    switch self {
    case .unknown, .faceUp, .faceDown:
      return (attitude.roll, -attitude.pitch)
    case .landscapeLeft:
      return (attitude.pitch, -attitude.roll)
    case .portrait:
      return (attitude.roll, attitude.pitch)
    case .portraitUpsideDown:
      return (-attitude.roll, -attitude.pitch)
    case .landscapeRight:
      return (-attitude.pitch, attitude.roll)
    @unknown default:
      return (attitude.roll, attitude.pitch)
    }
  }
}

extension Double {
  // turn a number into the same-length text every time, like "+00.25"
  // so the numbers on screen don't jiggle around
  func describeAsFixedLengthString(integerDigits: Int = 2, fractionDigits: Int = 2) -> String {
    self.formatted(
      .number
        .sign(strategy: .always())
        .precision(.integerAndFractionLength(integer: integerDigits, fraction: fractionDigits))
    )
  }
}
