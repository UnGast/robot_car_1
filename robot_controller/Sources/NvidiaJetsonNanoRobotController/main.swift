import RobotControllerApplication

let application = RobotControllerApplication(robotController: NvidiaJetsonNanoRobotController())
try application.start()