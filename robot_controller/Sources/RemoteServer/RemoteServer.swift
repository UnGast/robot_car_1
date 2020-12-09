import Vapor
import RobotControllerBase

public class RemoteServer {
  public static let defaultHost = "127.0.0.1"
  public static let defaultPort: Int = 8080
  
  let app: Application
  let host: String
  let port: Int
  let controller: RobotController
  let cameraStreamer: CameraStreamer.Type
  var protocolServers = [RemoteProtocolServerImpl]()
  
  public init(controller: RobotController, cameraStreamer: CameraStreamer.Type, host: String? = nil, port: Int? = nil) {
    self.app = Application()
    self.host = host ?? Self.defaultHost
    self.port = port ?? Self.defaultPort
    app.http.server.configuration.hostname = self.host
    app.http.server.configuration.port = Int(self.port)
    self.controller = controller
    self.cameraStreamer = cameraStreamer
    self.setupRoutes()
  }

  public func setupRoutes() {
    app.get { req in
        return "please connect over websocket"
    }

    app.webSocket("") { [unowned self] req, ws in
        let server = RemoteProtocolServerImpl(robotController: controller, cameraStreamer: cameraStreamer, socket: ws, host: host)
        protocolServers.append(server)
        server.startCommunication()
        ws.onClose.whenComplete { _ in
          server.destroy()
          protocolServers.removeAll(where: { $0 === server })
        }
    }
  }

  public func serve() throws {
    try app.server.start()
    let promise = app.eventLoopGroup.next().makePromise(of: Void.self)
    app.running = .start(using: promise)
    // TODO: in the vapor code there is more here, something with signalling or so: https://github.com/vapor/vapor/blob/master/Sources/Vapor/Commands/ServeCommand.swift
    try app.running?.onStop.wait()
  }
}