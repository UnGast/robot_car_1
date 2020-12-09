import ArgumentParser
import RemoteServer
import RobotControllerBase
import GStreamer

public class RobotControllerApplication {
  public let robotController: RobotController
  public let cameraStreamer: CameraStreamer.Type
  
  public init(robotController: RobotController, cameraStreamer: CameraStreamer.Type) {
    self.robotController = robotController
    self.cameraStreamer = cameraStreamer
  }

  public func start() throws {
    GStreamer.initialize()

    var serveCommand = try Serve.parseAsRoot(nil) as! Serve
    try serveCommand.run()

    let server = RemoteServer(controller: robotController, cameraStreamer: cameraStreamer, host: serveCommand.host, port: serveCommand.port)
    try server.serve()
  }

  struct Serve: ParsableCommand {
    @Option(name: .shortAndLong)
    var host: String?

    @Option(name: .shortAndLong)
    var port: Int?

    func run() throws {}
  }
}