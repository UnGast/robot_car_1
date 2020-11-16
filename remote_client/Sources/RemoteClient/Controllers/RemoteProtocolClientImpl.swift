import WebSocketKit
import RemoteProtocol
import Foundation

public class RemoteProtocolClientImpl: RemoteProtocolClient {
  private let socket: WebSocket

  public init(_ socket: WebSocket) {
    self.socket = socket
  }

  public func startCommunication() {
    socket.onText { socket, text in
      print("client received message", text)
    }
    send(RemoteProtocol.ClientHandshakeMessage(clientState: .Ok))
  }

  public func send<M: RemoteProtocolClientMessage>(_ message: M) {
    socket.send(String(data: try! JSONEncoder().encode(message), encoding: .utf8)!)
  }

  public func handle<M: RemoteProtocolServerMessage>(_ message: M) {

  }
}