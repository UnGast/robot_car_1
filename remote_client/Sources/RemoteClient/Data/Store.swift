import SwiftGUI
import Dispatch
import Combine
import BaseGPIO

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

    case let .SetGPIOHeaders(headers):
      newState.gpioHeaders = headers
    }

    return newState
  }
}

public struct StoreState {
  public var connection: Connection? = nil

  public var gpioHeaders: [GPIOHeader]? = nil
}

public class StoreGetters: ReduxGetters<StoreState> {

}

public enum StoreAction {
  case Connect(host: String, port: UInt)
  case SetConnection(connection: Connection)
  case Disconnect

  case SetGPIOHeaders(_ headers: [GPIOHeader])
}