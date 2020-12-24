import SwiftGUI
import RemoteProtocol

public class MotionControlView: SingleChildWidget, GUIKeyEventConsumer {
  @Inject
  public var store: Store

  public init() {
    super.init()
    self.focusable = true
  }

  override public func buildChild() -> Widget {
    Padding(all: 16) {
      Column {
        Text("Baum")

        Button {
          Text("activate keyboard control")
        } onClick: { _ in
          self.requestFocus()
        }
      }
    }
  }

  public func consume(_ event: GUIKeyEvent) {
    var requestedMotionState = MotionState(leftWheel: 0, rightWheel: 0)
    if event.keyStates[.ArrowUp] {
      requestedMotionState.leftWheel = 1
      requestedMotionState.rightWheel = 1
    } else if event.keyStates[.ArrowRight] {
      requestedMotionState.rightWheel = 1
    } else if event.keyStates[.ArrowLeft] {
      requestedMotionState.leftWheel = 1
    } else if event.keyStates[.ArrowDown] {
      requestedMotionState.leftWheel = -1
      requestedMotionState.rightWheel = -1
    }
    store.dispatch(.RequestMotionUpdate(requestedMotionState))
  }
}