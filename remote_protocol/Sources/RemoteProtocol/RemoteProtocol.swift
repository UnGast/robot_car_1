public protocol RemoteProtocolMessage: Codable {

}

public protocol RemoteProtocolServerMessage: RemoteProtocolMessage {

}

public protocol RemoteProtocolClientMessage: RemoteProtocolMessage {

}

public enum RemoteProtocol {
    public struct ServerHandshakeMessage: RemoteProtocolServerMessage {
        public var serverState: ServerState

        public init(serverState: ServerState) {
            self.serverState = serverState
        }
    }

    public struct ClientHandshakeMessage: RemoteProtocolClientMessage {
        public var clientState: ClientState

        public init(clientState: ClientState) {
            self.clientState = clientState
        }
    }
}