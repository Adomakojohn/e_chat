import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../presentation/pages/messages_model.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<Map<String, String>>> getUsersTexted(String currentUserId) async {
    // Get chat rooms where the current user is a member
    QuerySnapshot chatRoomsSnapshot = await _firestore
        .collection('chat_rooms')
        .where('members', arrayContains: currentUserId)
        .get();

    Set<String> userIds = {}; // Use a set to avoid duplicates

    // Loop through the chat rooms and collect other user IDs
    for (var doc in chatRoomsSnapshot.docs) {
      List<dynamic> members = doc['members'];
      for (var member in members) {
        if (member != currentUserId) {
          userIds.add(member as String);
        }
      }
    }

    List<Map<String, String>> usersTexted = [];

    // For each user that has been texted, get their details from the 'Users' collection
    for (String userId in userIds) {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        String email =
            userSnapshot['email'] ?? 'Unknown Use'; // Handle missing email

        // Add the user to the list of users texted
        usersTexted.add({
          'uid': userId,
          'email': email,
        });
      }
    }

    return usersTexted;
  }

  // Send a message and update last message data for chat sorting
  Future<void> sendMessage(String receiverID, String message) async {
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

    // Update last message and timestamp for ordering chats
    await _firestore.collection("chat_rooms").doc(chatRoomID).set({
      'lastMessageTime': timestamp,
      'lastMessage': message,
      'lastSender': currentUserID,
      'members': ids,
    }, SetOptions(merge: true));
  }

  // Stream messages in a chat room
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // Stream for the last message in a specific chat
  Stream<Map<String, dynamic>> getLastMessageStream(
      String currentUserId, String otherUserId) {
    String chatRoomId = currentUserId.compareTo(otherUserId) < 0
        ? '$currentUserId-$otherUserId'
        : '$otherUserId-$currentUserId';

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return {
          'message': 'No messages yet',
          'senderId': 'Unknown',
          'receiverId': 'Unknown',
        };
      }
      var lastMessageDoc = snapshot.docs.first;
      return {
        'message': lastMessageDoc['message'] ?? 'No message',
        'senderId': lastMessageDoc['senderId'] ?? 'Unknown',
        'receiverId': lastMessageDoc['receiverId'] ?? 'Unknown',
      };
    });
  }

  // Stream for getting recent chats ordered by the last message timestamp
  Stream<List<Map<String, dynamic>>> getRecentChats(String currentUserId) {
    return _firestore
        .collection('chat_rooms')
        .where('members', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> recentChats = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        data['chatRoomId'] = doc.id;

        List<String> memberIds = List<String>.from(data['members']);

        // Fetch email for each member except the current user
        List<Map<String, String>> memberEmails = await Future.wait(
          memberIds.where((id) => id != currentUserId).map((userId) async {
            DocumentSnapshot userSnapshot =
                await _firestore.collection('Users').doc(userId).get();
            String email =
                userSnapshot.exists ? userSnapshot['email'] : 'Unknown User';
            return {'uid': userId, 'email': email};
          }).toList(),
        );

        // Add member emails to the chat room data
        data['membersEmails'] = memberEmails;
        recentChats.add(data);
      }

      return recentChats;
    });
  }
}
