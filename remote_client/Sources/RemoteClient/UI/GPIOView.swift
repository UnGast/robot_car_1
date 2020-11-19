import SwiftGUI
import BaseGPIO

public class GPIOView: SingleChildWidget {
  @Inject
  private var store: Store

  @ComputedProperty
  private var gpioHeaders: [GPIOHeader]?
  @ComputedProperty
  private var gpioStates: [UInt: GPIOPinState]?
  @ComputedProperty
  private var gpioConfigurationAllowed: Bool

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
    _gpioConfigurationAllowed = ComputedProperty([store.$state.any]) { [unowned self] in
      store.state.gpioConfigurationAllowed
    }
  }

  override public func buildChild() -> Widget {
    ObservingBuilder($gpioHeaders, $gpioStates, $gpioConfigurationAllowed) { [unowned self] in
      if let headers = gpioHeaders {
        Column {
          Row {
            Text("allow configuration:")

            ToggleButton(
              leftValue: true,
              rightValue: false,
              bind: MutableComputedProperty([store.$state.any], compute: {
                store.state.gpioConfigurationAllowed
              }, apply: {
                store.dispatch(.SetGPIOConfigurationAllowed($0))
              }).binding)
          }

          buildGPIOHeaders(headers)
        }
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
                  return Column {
                    Text("GPIO \(gpioId)")

                    Row {
                      ToggleButton(
                        leftValue: GPIOPinDirection.input,
                        rightValue: GPIOPinDirection.output,
                        bind: MutableComputedProperty([store.$state.any], compute: {
                            store.state.gpioStates?[gpioId]?.direction ?? .input
                          }, apply: {
                            store.dispatch(.SetGPIODirection(gpioId: gpioId, direction: $0))
                          }).binding)

                      if let state = gpioStates?[gpioId] {
                        if state.direction == .output {
                          ToggleButton(
                            leftValue: GPIOPinValue.low,
                            rightValue: GPIOPinValue.high,
                            bind: MutableComputedProperty([store.$state.any], compute: {
                                store.state.gpioStates?[gpioId]?.value ?? .low
                              }, apply: {
                                store.dispatch(.SetGPIOValue(gpioId: gpioId, value: $0))
                              }).binding,
                            leftChild: { Text("off") },
                            rightChild: { Text("on") })
                        } else {
                          Text("value: \(state.value)")
                        }
                      }
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