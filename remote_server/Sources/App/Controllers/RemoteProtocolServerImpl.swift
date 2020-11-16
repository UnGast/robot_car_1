import Vapor
import RemoteProtocol

public class RemoteProtocolServerImpl: RemoteProtocolServer {
  private let socket: WebSocket

  public init(_ socket: WebSocket) {
    self.socket = socket
  }

  public func startCommunication() {
    socket.onText { socket, text in
      print("server received message", text)
    }
    send(RemoteProtocol.ServerHandshakeMessage(serverState: .Ok))
  }

  public func send<M: RemoteProtocolServerMessage>(_ message: M) {
    socket.send(String(data: try! JSONEncoder().encode(message), encoding: .utf8)!)
  }

  public func handle<M: RemoteProtocolClientMessage>(_ message: M) {
    
  }
}