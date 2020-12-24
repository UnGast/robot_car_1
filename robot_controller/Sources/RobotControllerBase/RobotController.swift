import BaseGPIO
import RemoteProtocol
import class GStreamer.Element
open class RobotController {
  open var gpioController: GPIOController
  open var cameras: [String: Camera] = [:]

  public init(gpioController: GPIOController) {
    self.gpioController = gpioController
  }

  open func getCameraStreamSource(id cameraId: String) -> GStreamer.Element {
    fatalError("getCameraStreamSource() not implemented")
  }

  open func updateMotionState(_ motionState: MotionState) {
    fatalError("updateMotionState() not implemented")
  }
}