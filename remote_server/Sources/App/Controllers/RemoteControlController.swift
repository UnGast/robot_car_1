import Vapor

public class RemoteControlController {
  private let socket: WebSocket

  public init(_ websocket: WebSocket) {
    self.socket = websocket
  }

  public func startCommunication() {
    self.socket.onText { socket, text in
      print("Received Text", text)
    }
    self.socket.send("Test Text")
  }
}