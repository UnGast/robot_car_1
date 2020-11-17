import Vapor
import RobotControllerBase

public class RemoteServer {
  let app: Application
  let controller: RobotController
  var protocolServers = [RemoteProtocolServerImpl]()
  
  public init(controller: RobotController) {
    self.app = Application()
    self.controller = controller
    self.setupRoutes()
  }

  public func setupRoutes() {
    app.get { req in
        return "please connect over websocket"
    }

    app.webSocket("") { [unowned self] req, ws in
        let server = RemoteProtocolServerImpl(controller, ws)
        protocolServers.append(server)
        server.startCommunication()
    }
  }

  public func serve() throws {
    try app.run()
  }
}