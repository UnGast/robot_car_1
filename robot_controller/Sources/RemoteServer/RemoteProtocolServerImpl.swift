import Vapor
import RemoteProtocol
import RobotControllerBase

public class RemoteProtocolServerImpl: RemoteProtocolServer {
  private let socket: WebSocket
  private let robotController: RobotController

  public init(_ robotController: RobotController, _ socket: WebSocket) {
    self.robotController = robotController
    self.socket = socket
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
      default:
        break
      }
    } catch {
      print("error occurred while handling message: \(error)")
    }
  }
}