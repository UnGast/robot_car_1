import ArgumentParser
import RemoteServer
import MockRobotController

struct Serve: ParsableCommand {
  @Option(name: .shortAndLong)
  var host: String?

  @Option(name: .shortAndLong)
  var port: UInt?

  func run() throws {
    let controller = MockRobotController()

    let server = RemoteServer(controller: controller, host: host, port: port)

    try server.serve()
  }
}

Serve.main()
/*
var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()*/