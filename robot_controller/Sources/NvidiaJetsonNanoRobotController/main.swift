import RobotControllerApplication

let application = RobotControllerApplication(robotController: NvidiaJetsonNanoRobotController(), cameraStreamer: NvidiaCameraStreamer.self)
try application.start()