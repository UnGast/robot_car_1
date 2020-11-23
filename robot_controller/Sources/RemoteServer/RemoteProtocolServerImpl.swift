import Vapor
import RemoteProtocol
import RobotControllerBase

public class RemoteProtocolServerImpl: RemoteProtocolServer {
  private let socket: WebSocket
  private let robotController: RobotController
  private let cameraStreamers: [String: CameraStreamer]

  public init(_ robotController: RobotController, _ socket: WebSocket) {
    self.robotController = robotController
    self.socket = socket
    self.cameraStreamers = robotController.cameras.reduce(into: [String: CameraStreamer]()) {
      $0[$1.id] = CameraStreamer(camera: $1)
    }
    for camera in cameraStreamers.values {
      camera.startStream()
    }
  }

  public func startCommunication() {
    socket.onText { [unowned self] socket, text in
      let message = RemoteProtocol.deserializeMessage(text)
      print("server received message", message)
      handle(message as! RemoteProtocolClientMessage)
    }
    send(RemoteProtocol.ServerHandshakeMessage(serverState: .Ok))
    send(RemoteProtocol.ServerGPIOHeadersMessage(headers: robotController.gpioController.headers))
    send(RemoteProtocol.ServerGPIOStatesMessage(states: robotController.gpioController.getPinStates()))
    send(RemoteProtocol.ServerCameraInfoMessage(cameras: robotController.cameras.map {
      CameraInfo(id: $0.id, name: $0.name, streamPort: cameraStreamers[$0.id]!.streamPort)
    }))
  }

  public func send<M: RemoteProtocolServerMessage>(_ message: M) {
    socket.send(message.serialize())
  }

  public func handle(_ message: RemoteProtocolClientMessage) {
    print("handle", message)
    do {
      switch message {
      case let message as RemoteProtocol.ClientSetGPIODirectionMessage:
        try robotController.gpioController.set(gpioId: message.gpioId, direction: message.direction)
        send(RemoteProtocol.ServerGPIOStatesMessage(states: robotController.gpioController.getPinStates()))
      case let message as RemoteProtocol.ClientSetGPIOValueMessage:
        try robotController.gpioController.set(gpioId: message.gpioId, value: message.value)
        send(RemoteProtocol.ServerGPIOStatesMessage(states: robotController.gpioController.getPinStates()))
      default:
        print("Received message type that was not handled! \(message)")
      }
    } catch {
      print("error occurred while handling message: \(error)")
    }
  }
}