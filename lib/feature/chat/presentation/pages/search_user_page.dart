import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_page.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  // Fetch users based on search input, excluding the current user
  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    String currentUserId = _auth.currentUser!.uid;

    QuerySnapshot snapshot = await _firestore
        .collection('Users')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email',
            isLessThanOrEqualTo: '$query\uf8ff') // For partial matches
        .get();

    setState(() {
      _searchResults = snapshot.docs
          .where((doc) => doc.id != currentUserId) // Exclude current user
          .map((doc) => {
                'uid': doc.id,
                'email': doc['email'],
              })
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by email...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _searchUsers,
            ),
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      return ListTile(
                        title: Text(user['email'] ?? 'No email'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                receiverID: user['uid'],
                                recieverEmail: user['email'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
