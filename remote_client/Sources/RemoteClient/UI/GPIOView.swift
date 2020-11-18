import SwiftGUI
import BaseGPIO

public class GPIOView: SingleChildWidget {
  @Inject
  private var store: Store

  @ComputedProperty
  private var gpioHeaders: [GPIOHeader]?

  public init() {
    super.init()
    _ = self.onDependenciesInjected(setupStoreBindings)
  }

  private func setupStoreBindings() {
    _gpioHeaders = ComputedProperty([store.$state.any]) { [unowned self] in
      store.state.gpioHeaders
    }
  }

  override public func buildChild() -> Widget {
    ObservingBuilder($gpioHeaders) { [unowned self] in
      if let headers = gpioHeaders {
        buildGPIOHeaders(headers)
      } else {
        Text("no GPIO data available")
      }
    }
  }

  @WidgetBuilder private func buildGPIOHeaders(_ headers: [GPIOHeader]) -> Widget {
    Column { [unowned self] in
      headers.map { buildGPIOHeaderLayout($0.layout) }
    }
  }

  @WidgetBuilder private func buildGPIOHeaderLayout(_ layout: GPIOHeaderLayout) -> Widget {
    switch layout {
    case let .pin(id):
      buildPin(id)
    case let .row(children):
      Row { [unowned self] in
        children.map {buildGPIOHeaderLayout($0) }
      }
    case let .column(children):
      Column { [unowned self] in
        children.map {buildGPIOHeaderLayout($0) }
      }
    }
  }

  private func buildPin(_ pinId: UInt) -> Widget {
    let roles = gpioHeaders!.flatMap { $0.pinRoles[pinId] }.flatMap { $0 }
    return Border(all: 1, color: .Grey) {
      Background(fill: .White) {
        Padding(all: 16) {
          Row {
            { () -> Widget in
              for role in roles {
                switch role {
                case let .gpio(gpioId):
                  return Text("GPIO \(gpioId)")
                case let .voltage(level):
                  return Text("\(level) V")
                case .gnd:
                  return Text("GND")
                default:
                  return Space(.zero)
                }
              }

              return Space(.zero)
            }()

            Text("PIN \(pinId)")
          }
        }
      }
    }
  }
}