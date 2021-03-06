import WebSocketKit
import RemoteProtocol
import Foundation

public class RemoteProtocolClientImpl: RemoteProtocolClient {
  private let store: Store
  private let socket: WebSocket

  public init(_ store: Store, _ socket: WebSocket) {
    self.store = store
    self.socket = socket
  }

  public func startCommunication() {
    socket.onText { [unowned self] socket, text in
      let message = RemoteProtocol.deserializeMessage(text)
      print("client received message", message)
      handle(message as! RemoteProtocolServerMessage)
    }
    send(RemoteProtocol.ClientHandshakeMessage(clientState: .Ok))
  }

  public func send<M: RemoteProtocolClientMessage>(_ message: M) {
    socket.send(message.serialize())
  }

  public func handle(_ message: RemoteProtocolServerMessage) {
    print("handle", message)
    switch message {
    case let message as RemoteProtocol.ServerGPIOStatesMessage:
      store.commit(.SetGPIOStates(message.states))
    case let message as RemoteProtocol.ServerGPIOHeadersMessage:
      store.commit(.SetGPIOHeaders(message.headers))
    case let message as RemoteProtocol.ServerCameraInfoMessage:
      store.commit(.SetCameras(message.cameras))
    default:
      print("Client received message type that was not handled! \(message)")
    }
  }

  public func endCommunication() {}

  deinit {
    print("deinitialized RemoteProtocolClientImpl")
  }
}