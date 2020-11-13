import SwiftGUI

public class Store: ReduxStore<StoreState, StoreGetters, StoreAction> {
  public init() {
    super.init(initialState: State())
  }

  override public func reduce(_ action: Action, next: (@escaping () -> ()) -> ()) -> State {
    var newState = state

    switch action {
    case .Disconnect:
      newState.connection = nil
    }

    return newState
  }
}

public struct StoreState {
  public var connection: Connection? = nil
}

public class StoreGetters: ReduxGetters<StoreState> {

}

public enum StoreAction {
  case Disconnect
}