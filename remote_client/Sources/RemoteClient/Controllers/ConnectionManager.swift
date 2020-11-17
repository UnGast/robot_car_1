import WebSocketKit
import NIO
import Combine
import Dispatch

public class ConnectionManager {
  private static var clients = [RemoteProtocolClientImpl]()

  public static func setup(_ connection: Connection, _ store: Store, onConnected: @escaping (Connection) -> ()) {
    let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    let socket = WebSocket.connect(to: "ws://\(connection.host):\(connection.port)", on: group) { ws in
      print("GOT SOCKET", ws)
      onConnected(connection)
      let client = RemoteProtocolClientImpl(store, ws)
      clients.append(client)
      client.startCommunication()
    }
  }
}