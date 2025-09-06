// ChatUserListScreen.dart
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';
import 'ChatDetailScreen.dart';

class ChatUserListScreen extends StatefulWidget {
  const ChatUserListScreen({super.key});

  @override
  State<ChatUserListScreen> createState() => _ChatUserListScreenState();
}

class _ChatUserListScreenState extends State<ChatUserListScreen> {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  String _searchQuery = '';
  String _currentUserRole = 'USER';
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      _currentUserId = authUser.userId;

      final userInfo = await Amplify.API.query(
        request: GraphQLRequest<String>(
          document: '''query GetUser(\$id: ID!) {
            getUser(id: \$id) {
              id
              role
            }
          }''',
          variables: {'id': _currentUserId},
        ),
      ).response;

      final decodedUser = jsonDecode(userInfo.data ?? '{}');
      final role = (decodedUser['getUser']?['role'] ?? 'USER').toString().toUpperCase();
      print('🔍 Current user role: $role');
      setState(() => _currentUserRole = role);

      final roleToQuery = (role == 'ADMIN') ? 'USER' : 'ADMIN';
      print('📥 Role to query: $roleToQuery');

      final userList = await Amplify.API.query(
        request: GraphQLRequest<String>(
          document: '''query ListUsersByRole {
            listUsers(filter: { role: { eq: "$roleToQuery" } }) {
              items {
                id
                name
                email
                profile
                role
              }
            }
          }''',
        ),
      ).response;

      final decodedList = jsonDecode(userList.data ?? '{}');
      final items = decodedList['listUsers']?['items'] ?? [];
      print('📦 Found ${items.length} users with role $roleToQuery');

      setState(() {
        _users = List<Map<String, dynamic>>.from(items);
        _filteredUsers = _users;
      });
    } catch (e) {
      print('❌ Error loading users: $e');
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredUsers = _users.where((u) {
        final name = u['name']?.toLowerCase() ?? '';
        final email = u['email']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Users')),
      body: Column(
        children: [
          if (_currentUserRole == 'ADMIN')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search user...',
                  border: OutlineInputBorder(),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(child: Text('No users available'))
                : ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['profile'] ?? ''),
                  ),
                  title: Text(user['name'] ?? 'Unknown'),
                  subtitle: Text(user['email'] ?? ''),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatDetailScreen(
                        receiverId: user['id'],
                        receiverName: user['name'] ?? 'Unknown',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}