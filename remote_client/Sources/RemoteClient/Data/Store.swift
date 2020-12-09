import SwiftGUI
import Dispatch
import BaseGPIO
import RemoteProtocol

public class Store: ReduxStore<StoreState, StoreGetters, StoreMutation, StoreAction> {
  public init() {
    super.init(initialState: State())
  }

  override public func performMutation(_ state: inout State, _ mutation: Mutation) {
    switch mutation {
    case let .SetConnection(connection):
      state.connection = connection

    case let .SetGPIOConfigurationAllowed(allowed):
      state.gpioConfigurationAllowed = allowed
    case let .SetGPIOHeaders(headers):
      state.gpioHeaders = headers
    case let .SetGPIOStates(states):
      state.gpioStates = states

    case let .SetCameras(cameras):
      state.cameras = cameras
    }
  }

  override public func performAction(_ action: Action) {
    switch action {
    case let .Connect(host, port):
      ConnectionManager.setup(Connection(host: host, port: port), self) { [unowned self] in
        commit(.SetConnection($0))
      }

    case .Disconnect:
      commit(.SetConnection(nil))

    case let .SetGPIODirection(gpioId, direction):
      if state.gpioConfigurationAllowed {
        ConnectionManager.getClient(for: state.connection!)
          .send(RemoteProtocol.ClientSetGPIODirectionMessage(gpioId: gpioId, direction: direction))
      } else {
        print("warn: tried to set gpio direction when configuration is not allowed")
      }
    case let .SetGPIOValue(gpioId, value):
      if state.gpioConfigurationAllowed {
        ConnectionManager.getClient(for: state.connection!)
          .send(RemoteProtocol.ClientSetGPIOValueMessage(gpioId: gpioId, value: value))
      } else {
        print("warn: tried to set gpio value when configuration is not allowed")
      }

    case let .RequestCameraStream(cameraId):
      ConnectionManager.getClient(for: state.connection!)
        .send(RemoteProtocol.ClientRequestCameraStreamMessage(cameraId: cameraId))
    }
  }
}

public struct StoreState {
  public var connection: Connection? = nil

  public var gpioConfigurationAllowed: Bool = false
  public var gpioHeaders: [GPIOHeader]? = nil
  public var gpioStates: [UInt: GPIOPinState]? = nil

  public var cameras: [CameraInfo] = []
}

public class StoreGetters: ReduxGetters<StoreState> {

}

public enum StoreMutation {
  case SetConnection(_ connection: Connection?)

  case SetGPIOConfigurationAllowed(_ allowed: Bool)
  case SetGPIOHeaders(_ headers: [GPIOHeader])
  case SetGPIOStates(_ states: [UInt: GPIOPinState])

  case SetCameras(_ cameras: [CameraInfo])
}

public enum StoreAction {
  case Connect(host: String, port: Int)
  case Disconnect

  case SetGPIODirection(gpioId: UInt, direction: GPIOPinDirection)
  case SetGPIOValue(gpioId: UInt, value: GPIOPinValue)

  case RequestCameraStream(cameraId: String)
}