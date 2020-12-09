import RobotControllerApplication
import GStreamer
import RemoteServer

GStreamer.initialize()
let application = RobotControllerApplication(robotController: MockRobotController(), cameraStreamer: MockCameraStreamer.self)
try application.start()