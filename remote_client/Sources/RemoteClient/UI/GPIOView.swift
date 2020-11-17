import SwiftGUI
import BaseGPIO

public class GPIOView: SingleChildWidget {
  @Inject
  private var store: Store

  @ComputedProperty
  private var gpioPinLayout: GPIOPinLayout?

  public init() {
    super.init()
    _ = self.onDependenciesInjected(setupStoreBindings)
  }

  private func setupStoreBindings() {
    _gpioPinLayout = ComputedProperty([store.$state.any]) { [unowned self] in
      store.state.gpioPinLayout
    }
  }

  override public func buildChild() -> Widget {
    ObservingBuilder($gpioPinLayout) { [unowned self] in
      if let layout = gpioPinLayout {
        buildGPIOPinLayout(layout)
      } else {
        Text("no GPIO data available")
      }
    }
  }

  @WidgetBuilder private func buildGPIOPinLayout(_ layout: GPIOPinLayout) -> Widget {
    switch layout {
    case let .pin(id):
      Text("PIN " + id.description)
    case let .row(children):
      Row { [unowned self] in
        children.map { buildGPIOPinLayout($0) }
      }
    case let .column(children):
      Column { [unowned self] in
        children.map { buildGPIOPinLayout($0) }
      }
    }
  }
}