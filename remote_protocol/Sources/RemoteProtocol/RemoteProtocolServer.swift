public protocol RemoteProtocolServer: RemoteProtocolParticipant {
  func startCommunication()

  func send<M: RemoteProtocolServerMessage>(_ message: M)
}