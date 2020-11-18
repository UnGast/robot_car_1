import Foundation
import BaseGPIO

public protocol RemoteProtocolMessage: Codable {
    var typeName: String { get }
}

extension RemoteProtocolMessage {
    public var typeName: String {
        String(describing: Swift.type(of: self))
    }

    public func serialize() -> String {
        "\(typeName):\(String(data: try! JSONEncoder().encode(self), encoding: .utf8)!)"
    }

    public static func deserialize(_ data: String) -> Self {
        return try! JSONDecoder().decode(Self.self, from: data.data(using: .utf8)!)
    }
}

public protocol RemoteProtocolServerMessage: RemoteProtocolMessage {

}

public protocol RemoteProtocolClientMessage: RemoteProtocolMessage {
    
}

extension RemoteProtocolClientMessage {
    public func serialize() -> String {
        "\(typeName):\(String(data: try! JSONEncoder().encode(self), encoding: .utf8)!)"
    }
}

public enum RemoteProtocol {
    public struct ServerHandshakeMessage: RemoteProtocolServerMessage {
        public var serverState: ServerState

        public init(serverState: ServerState) {
            self.serverState = serverState
        }
    }

    public struct ServerGPIOStateMessage: RemoteProtocolServerMessage {
        public var headers: [GPIOHeader]

        public init(headers: [GPIOHeader]) {
            self.headers = headers
        }
    }

    public struct ClientHandshakeMessage: RemoteProtocolClientMessage {
        public var clientState: ClientState

        public init(clientState: ClientState) {
            self.clientState = clientState
        }
    }

    public static let messageTypes: [String: RemoteProtocolMessage.Type] = [
        "ServerHandshakeMessage": ServerHandshakeMessage.self,
        "ServerGPIOStateMessage": ServerGPIOStateMessage.self,
        "ClientHandshakeMessage": ClientHandshakeMessage.self
    ]

    public static func deserializeMessage(_ data: String) -> RemoteProtocolMessage {
        let separator = data.firstIndex(of: ":")!
        let typeName = String(data.prefix(upTo: separator))
        let type = RemoteProtocol.messageTypes[typeName]!
        return type.deserialize(String(data[data.index(after: separator)...]))
    }
}