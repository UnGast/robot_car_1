import SwiftGUI
import Dispatch
import Combine
import BaseGPIO
import RemoteProtocol

public class Store: ReduxStore<StoreState, StoreGetters, StoreAction> {
  public init() {
    super.init(initialState: State())
  }

  override public func reduce(_ action: Action, next: (@escaping () -> ()) -> ()) -> State {
    var newState = state

    switch action {
    case let .Connect(host, port):
      ConnectionManager.setup(Connection(host: host, port: port), self) { [unowned self] in
        dispatch(.SetConnection(connection: $0))
      }
    case let .SetConnection(connection):
      newState.connection = connection
    case .Disconnect:
      newState.connection = nil

    case let .SetGPIOConfigurationAllowed(allowed):
      newState.gpioConfigurationAllowed = allowed
    case let .SetGPIOHeaders(headers):
      newState.gpioHeaders = headers
    case let .SetGPIOStates(states):
      newState.gpioStates = states
    case let .SetGPIODirection(gpioId, direction):
      if newState.gpioConfigurationAllowed {
        ConnectionManager.getClient(for: state.connection!)
          .send(RemoteProtocol.ClientSetGPIODirectionMessage(gpioId: gpioId, direction: direction))
      } else {
        print("warn: tried to set gpio direction when configuration is not allowed")
      }
    case let .SetGPIOValue(gpioId, value):
      if newState.gpioConfigurationAllowed {
        ConnectionManager.getClient(for: state.connection!)
          .send(RemoteProtocol.ClientSetGPIOValueMessage(gpioId: gpioId, value: value))
      } else {
        print("warn: tried to set gpio value when configuration is not allowed")
      }
    }

    return newState
  }
}

public struct StoreState {
  public var connection: Connection? = nil

  public var gpioConfigurationAllowed: Bool = false
  public var gpioHeaders: [GPIOHeader]? = nil
  public var gpioStates: [UInt: GPIOPinState]? = nil
}

public class StoreGetters: ReduxGetters<StoreState> {

}


public enum StoreAction {
  case Connect(host: String, port: UInt)
  case SetConnection(connection: Connection)
  case Disconnect

  case SetGPIOConfigurationAllowed(_ allowed: Bool)
  case SetGPIOHeaders(_ headers: [GPIOHeader])
  case SetGPIOStates(_ states: [UInt: GPIOPinState])
  case SetGPIODirection(gpioId: UInt, direction: GPIOPinDirection)
  case SetGPIOValue(gpioId: UInt, value: GPIOPinValue)
}