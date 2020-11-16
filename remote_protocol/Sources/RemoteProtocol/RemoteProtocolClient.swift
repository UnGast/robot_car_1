public protocol RemoteProtocolClient: RemoteProtocolParticipant {
  func startCommunication()

  func send<M: RemoteProtocolClientMessage>(_ message: M)
}