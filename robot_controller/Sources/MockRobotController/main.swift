import RobotControllerApplication
import GStreamer

GStreamer.initialize()
let application = RobotControllerApplication(robotController: MockRobotController())
try application.start()