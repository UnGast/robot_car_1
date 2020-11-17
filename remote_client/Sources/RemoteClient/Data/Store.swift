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

    case let .SetGPIOPinLayout(layout):
      newState.gpioPinLayout = layout
    }

    return newState
  }
}

public struct StoreState {
  public var connection: Connection? = nil

  public var gpioPinLayout: GPIOPinLayout? = nil
}

public class StoreGetters: ReduxGetters<StoreState> {

}

public enum StoreAction {
  case Connect(host: String, port: UInt)
  case SetConnection(connection: Connection)
  case Disconnect

  case SetGPIOPinLayout(_ layout: GPIOPinLayout)
}