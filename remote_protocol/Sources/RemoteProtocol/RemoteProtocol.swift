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

    public struct ServerGPIOHeadersMessage: RemoteProtocolServerMessage {
        public var headers: [GPIOHeader]

        public init(headers: [GPIOHeader]) {
            self.headers = headers
        }
    }

    public struct ServerGPIOStatesMessage: RemoteProtocolServerMessage {
        public var states: [Int: GPIOPinState]

        public init(states: [Int: GPIOPinState]) {
            self.states = states
        }
    }

    public struct ServerCameraInfoMessage: RemoteProtocolServerMessage {
        public var cameras: [CameraInfo]

        public init(cameras: [CameraInfo]) {
            self.cameras = cameras
        }
    }

    public struct ClientHandshakeMessage: RemoteProtocolClientMessage {
        public var clientState: ClientState

        public init(clientState: ClientState) {
            self.clientState = clientState
        }
    }

    public struct ClientSetGPIODirectionMessage: RemoteProtocolClientMessage {
        public var gpioId: Int
        public var direction: GPIOPinDirection

        public init(gpioId: Int, direction: GPIOPinDirection) {
            self.gpioId = gpioId
            self.direction = direction
        }
    }

    public struct ClientSetGPIOValueMessage: RemoteProtocolClientMessage {
        public var gpioId: Int
        public var value: GPIOPinValue

        public init(gpioId: Int, value: GPIOPinValue) {
            self.gpioId = gpioId
            self.value = value 
        }
    }

    public struct ClientRequestCameraStreamMessage: RemoteProtocolClientMessage {
        public var cameraId: String

        public init(cameraId: String) {
            self.cameraId = cameraId
        }
    }

    public struct ClientRequestMotionUpdateMessage: RemoteProtocolClientMessage {
        public var requestedMotionState: MotionState

        public init(requestedMotionState: MotionState) {
            self.requestedMotionState = requestedMotionState
        }
    }

    public static let messageTypes: [String: RemoteProtocolMessage.Type] = [
        "ServerHandshakeMessage": ServerHandshakeMessage.self,
        "ServerGPIOStatesMessage": ServerGPIOStatesMessage.self,
        "ServerGPIOHeadersMessage": ServerGPIOHeadersMessage.self,
        "ServerCameraInfoMessage": ServerCameraInfoMessage.self,
        "ClientHandshakeMessage": ClientHandshakeMessage.self,
        "ClientSetGPIODirectionMessage": ClientSetGPIODirectionMessage.self,
        "ClientSetGPIOValueMessage": ClientSetGPIOValueMessage.self,
        "ClientRequestCameraStreamMessage": ClientRequestCameraStreamMessage.self,
        "ClientRequestMotionUpdateMessage": ClientRequestMotionUpdateMessage.self
    ]

    public static func deserializeMessage(_ data: String) -> RemoteProtocolMessage {
        let separator = data.firstIndex(of: ":")!
        let typeName = String(data.prefix(upTo: separator))
        let type = RemoteProtocol.messageTypes[typeName]!
        return type.deserialize(String(data[data.index(after: separator)...]))
    }
}