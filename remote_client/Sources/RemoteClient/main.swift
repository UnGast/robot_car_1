import SwiftGUI
import GStreamer

public class RemoteClientApp: WidgetsApp {
  public init() {
    super.init(baseApp: SDL2OpenGL3NanoVGVisualApp())
  }

  override open func setup() {
    let store = Store()
    store.dispatch(.Connect(host: "localhost", port: 8080))

    let guiRoot = Root(rootWidget: DependencyProvider(
      provide: [Dependency(store)]) {
        MainView()
      })

    _ = createWindow(guiRoot: guiRoot, options: Window.Options(title: AppConstants.title, initialSize: DSize2(1000, 1000)), immediate: true)
  }
}

GStreamer.initialize()

let app = RemoteClientApp()

do {
  try app.start()
} catch {
  print("an error occurred when starting the app: \(error)")
}