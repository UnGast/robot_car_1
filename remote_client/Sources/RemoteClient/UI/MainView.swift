import WidgetGUI

public class MainView: SingleChildWidget {
  override public func buildChild() -> Widget {
    Column {
      ConnectionView()
      Row {
        GPIOView()
        CameraView()
      }
    }
  }
}