import SwiftGUI
import GStreamer

public class RemoteClientApp: WidgetsApp<SDL2OpenGL3NanoVGSystem, SDL2OpenGL3NanoVGWindow, SDL2OpenGL3NanoVGRenderer> {
  public init() {
    super.init(system: try! SDL2OpenGL3NanoVGSystem())

    let store = Store()
    store.dispatch(.Connect(host: "localhost", port: 8080))

    let guiRoot = Root(rootWidget: DependencyProvider(
      provide: [Dependency(store)]) {
        MainView()
    })

    _ = createWindow(guiRoot: guiRoot, options: Window.Options(title: AppConstants.title), immediate: true)
  }
  
  override public func createRenderer(for window: Window) -> Renderer {
    SDL2OpenGL3NanoVGRenderer(for: window)
  }
}

let app = RemoteClientApp()

do {
  GStreamer.initialize()
  try app.start()
} catch {
  print("an error occurred when starting the app: \(error)")
}