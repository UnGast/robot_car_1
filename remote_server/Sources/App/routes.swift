import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "please connect over websocket"
    }

    app.webSocket("") { req, ws in
        let server = RemoteProtocolServerImpl(ws)
        RemoteProtocolServerManager.register(server)
        server.startCommunication()
    }
}
