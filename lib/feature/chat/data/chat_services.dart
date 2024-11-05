import 'package:chat_app/feature/chat/presentation/pages/messages_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final user = doc.data();
          return user;
        }).toList();
      },
    );
  }

  //send messages
  Future<void> sendMessage(String receiverID, message) async {
    //getting user info
    final String currentUserID = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    MessagesModel newMessage = MessagesModel(
      senderID: currentUserID,
      receiverID: receiverID,
      message: message,
      senderEmail: currentUserEmail,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy(
          "timestamp",
          descending: false,
        )
        .snapshots();
  }

  Stream<QuerySnapshot> getLastMessageStream(
      String currentUserId, String otherUserId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(currentUserId)
        .collection('messages')
        .where('receiverId', isEqualTo: otherUserId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }
}
