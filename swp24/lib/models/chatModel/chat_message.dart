/// Author: Sergi Koniashvili
///
/// The `ChatMessage` class represents a single chat message in the application.
/// This class encapsulates all the necessary information for a chat message,
/// including the message content, the sender, and the timestamp of when the
/// message was sent.
class ChatMessage {
  /// The content of the chat message.
  /// This field holds the text message sent by the sender.
  final String text;
  /// The identifier of the sender.
  /// This field represents who sent the message, e.g., a user or bot name.
  final String sender; 
  /// The timestamp of when the message was sent.
  /// This field captures the exact date and time the message was created.
  final DateTime timestamp;

  /// Constructor for creating a `ChatMessage` instance.
  ///
  /// All fields are required to ensure a valid chat message.
  ///
  /// - [text]: The content of the message (non-null).
  /// - [sender]: The sender of the message (non-null).
  /// - [timestamp]: The time when the message was sent (non-null).
  ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
  });
}
