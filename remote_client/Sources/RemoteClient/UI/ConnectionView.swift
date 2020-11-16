import WidgetGUI

public class ConnectionView: SingleChildWidget {
  @Inject
  private var store: Store

  @MutableProperty
  private var rawHost: String = ""

  @MutableProperty
  private var rawPort: String = ""

  @ComputedProperty
  private var connection: Connection?

  public init() {
    super.init()
    _ = onDependenciesInjected(initInputs)
    _ = onDependenciesInjected(setupStoreMappings)
  }

  private func initInputs() {
    rawHost = store.state.connection?.host ?? ""
    rawPort = String(store.state.connection?.port ?? AppConstants.defaultPort)
  }

  private func setupStoreMappings() {
    _connection = ComputedProperty([store.$state.any]) { [unowned self] in
      store.state.connection
    }
    _ = onDestroy(_connection.onChanged { [unowned self] in
      if let connection = $0 {
        rawHost = connection.host
        rawPort = String(connection.port)
      }
    })
  }

  override public func buildChild() -> Widget {
    Row(crossAlignment: .Center) { [unowned self] in
      Text("host:")

      TextField(bind: $rawHost.binding)

      Text("port:")

      TextField(bind: $rawPort.binding)

      Button {
        ObservingBuilder($connection) {
          if connection == nil {
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
    store.dispatch(.Connect(host: "localhost", port: 8080))
  }
}