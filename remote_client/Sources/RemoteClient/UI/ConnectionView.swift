import WidgetGUI

public class ConnectionView: SingleChildWidget {
  @Inject
  private var store: Store

  @MutableProperty
  private var rawHost: String = ""

  @MutableProperty
  private var rawPort: String = ""

  public init() {
    super.init()
    _ = onDependenciesInjected(initInputs)
  }

  private func initInputs() {
    rawHost = store.state.connection?.host ?? ""
    rawPort = String(store.state.connection?.port ?? AppConstants.defaultPort)
  }

  override public func buildChild() -> Widget {
    Row(crossAlignment: .Center) { [unowned self] in
      Text("host:")

      TextField(bind: $rawHost.binding)

      Text("port:")

      TextField(bind: $rawPort.binding)

      Button {
        ObservingBuilder(store.$state) {
          if store.state.connection == nil {
            Text("connect")
          } else {
            Text("disconnect")
          }
        }
      } onClick: { _ in
        if store.state.connection == nil {
          checkConnect()
        } else {
          store.dispatch(.Disconnect)
        }
      }
    }
  }

  private func checkConnect() {
    
  }
}