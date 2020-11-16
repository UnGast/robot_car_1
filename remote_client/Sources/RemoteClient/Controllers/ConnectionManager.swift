import WebSocketKit
import NIO
import Combine
import Dispatch

public struct ConnectionManager {
  public static func setup(_ connection: Connection, onConnected: @escaping (Connection) -> ()) {
    let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    let socket = WebSocket.connect(to: "ws://\(connection.host):\(connection.port)", on: group) { ws in
      print("GOT SOCKET", ws)
      onConnected(connection)
      let client = RemoteProtocolClientImpl(ws)
      client.startCommunication()
    }
  }
}