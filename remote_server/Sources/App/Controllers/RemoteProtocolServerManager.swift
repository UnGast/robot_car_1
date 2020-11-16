public class RemoteProtocolServerManager {
  private static var servers = [RemoteProtocolServerImpl]()

  public class func register(_ server: RemoteProtocolServerImpl) {
    servers.append(server)
  }
}