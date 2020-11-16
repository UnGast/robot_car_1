import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "please connect over websocket"
    }

    app.webSocket("") { req, ws in
        let controller = RemoteProtocolServerImpl(ws)
        controller.startCommunication()
    }
}
