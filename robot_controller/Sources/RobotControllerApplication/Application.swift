import ArgumentParser
import RemoteServer
import RobotControllerBase

public class RobotControllerApplication {
  private var robotController: RobotController
  
  public init(robotController: RobotController) {
    self.robotController = robotController
  }

  public func start() throws {
    var serveCommand = try Serve.parseAsRoot(nil) as! Serve
    try serveCommand.run()

    let server = RemoteServer(controller: robotController, host: serveCommand.host, port: serveCommand.port)
    try server.serve()
  }

  struct Serve: ParsableCommand {
    @Option(name: .shortAndLong)
    var host: String?

    @Option(name: .shortAndLong)
    var port: UInt?

    func run() throws {}
  }
}