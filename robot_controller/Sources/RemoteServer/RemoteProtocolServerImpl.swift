import Vapor
import RemoteProtocol
import RobotControllerBase

public class RemoteProtocolServerImpl: RemoteProtocolServer {
  private let socket: WebSocket
  private let robotController: RobotController
  private let cameraStreamer: CameraStreamer.Type
  private let host: String
  private var cameraStreamers: [String: CameraStreamer] = [:]

  public init(robotController: RobotController, cameraStreamer: CameraStreamer.Type, socket: WebSocket, host: String) {
    self.robotController = robotController
    self.cameraStreamer = cameraStreamer
    self.socket = socket
    self.host = host
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
    sendCameraInfoMessage()
  }

  public func send<M: RemoteProtocolServerMessage>(_ message: M) {
    socket.send(message.serialize())
  }

  public func handle(_ message: RemoteProtocolClientMessage) {
    print("handle", message)
    do {
      switch message {
      case let message as RemoteProtocol.ClientHandshakeMessage:
        break

      case let message as RemoteProtocol.ClientSetGPIODirectionMessage:
        try robotController.gpioController.set(gpioId: message.gpioId, direction: message.direction)
        send(RemoteProtocol.ServerGPIOStatesMessage(states: robotController.gpioController.getPinStates()))

      case let message as RemoteProtocol.ClientSetGPIOValueMessage:
        try robotController.gpioController.set(gpioId: message.gpioId, value: message.value)
        send(RemoteProtocol.ServerGPIOStatesMessage(states: robotController.gpioController.getPinStates()))

      case let message as RemoteProtocol.ClientRequestCameraStreamMessage:
        serveCameraStream(id: message.cameraId)

      default:
        print("Received message type that was not handled! \(message)")
      }
    } catch {
      print("error occurred while handling message: \(error)")
    }
  }
 
  private func sendCameraInfoMessage() {
    send(RemoteProtocol.ServerCameraInfoMessage(cameras: robotController.cameras.values.map {
      var stream: CameraInfo.StreamInfo? = nil
      if let streamer = cameraStreamers[$0.id] {
        stream = CameraInfo.StreamInfo(host: host, port: streamer.port, codec: streamer.codec)
      } 
      return CameraInfo(id: $0.id, name: $0.name, stream: stream)
    }))
  }

  private func serveCameraStream(id cameraId: String) {
    if cameraStreamers[cameraId] == nil {
      let streamer = self.cameraStreamer.init(host: host, source: robotController.getCameraStreamSource(id: cameraId))
      cameraStreamers[cameraId] = streamer
      try! streamer.startStream()
    }
    sendCameraInfoMessage()
  }

  internal func destroy() {
    for streamer in cameraStreamers.values {
      streamer.destroy()
    }
  }
}