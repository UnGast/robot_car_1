import SwiftGUI
import BaseGPIO

public class GPIOView: SingleChildWidget {
  @Inject
  private var store: Store

  @ComputedProperty
  private var gpioHeaders: [GPIOHeader]?

  @ComputedProperty
  private var gpioStates: [UInt: GPIOPinState]?

  public init() {
    super.init()
    _ = self.onDependenciesInjected(setupStoreBindings)
  }

  private func setupStoreBindings() {
    _gpioHeaders = ComputedProperty([store.$state.any]) { [unowned self] in
      store.state.gpioHeaders
    }
    _gpioStates = ComputedProperty([store.$state.any]) { [unowned self] in
      store.state.gpioStates
    }
  }

  override public func buildChild() -> Widget {
    ObservingBuilder($gpioHeaders, $gpioStates) { [unowned self] in
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
    return Border(all: 1, color: .Grey) { [unowned self] in
      Background(fill: .White) {
        Padding(all: 16) {
          Row {
            { () -> Widget in
              for role in roles {
                switch role {
                case let .gpio(gpioId):
                  return MouseArea {
                    Column {
                      Text("GPIO \(gpioId)")

                      Row {
                        Button {
                          Text("input")
                        }
                        Button {
                          Text("output")
                        } onClick: { _ in
                          store.dispatch(.SetGPIODirection(gpioId: gpioId, direction: .output))
                        }

                        if let state = gpioStates?[gpioId] {
                          if state.direction == .output {
                            Button {
                              Text("value: 1")
                            }

                            Button {
                              Text("value: 0")
                            }
                          } else {
                            Text("value: \(state.value)")
                          }
                        }
                      }
                    }
                  } onClick: { _ in
                    if let state = gpioStates?[gpioId], state.direction == .output {
                      print("OUTPUT CLICK")
                    } else {
                      print("INPUT CLICK")
                    }
                  }
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