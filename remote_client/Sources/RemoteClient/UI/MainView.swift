import WidgetGUI

public class MainView: SingleChildWidget {
  override public func buildChild() -> Widget {
    Column {
      ConnectionView()
      MotionControlView()
      //GPIOView()
      CameraView()
    }
  }
}