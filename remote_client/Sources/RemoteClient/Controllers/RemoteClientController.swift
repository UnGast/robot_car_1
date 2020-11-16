import WebSocketKit

public class RemoteClientController {
  private let ws: WebSocket

  public init(_ websocket: WebSocket) {
    self.ws = websocket
  }
}