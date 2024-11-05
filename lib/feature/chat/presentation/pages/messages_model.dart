import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesModel {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  MessagesModel({
    required this.senderID,
    required this.receiverID,
    required this.message,
    required this.senderEmail,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': receiverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
