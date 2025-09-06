
// ChatDetailScreen.dart
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';

class ChatDetailScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatDetailScreen({super.key, required this.receiverId, required this.receiverName});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  String _currentUserId = '';
  String _currentUserName = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final authUser = await Amplify.Auth.getCurrentUser();
    _currentUserId = authUser.userId;

    final userInfo = await Amplify.API.query(
      request: GraphQLRequest<String>(
        document: '''query GetUser(\$id: ID!) {
          getUser(id: \$id) {
            name
          }
        }''',
        variables: {'id': _currentUserId},
      ),
    ).response;

    final decoded = jsonDecode(userInfo.data ?? '{}');
    _currentUserName = decoded['getUser']?['name'] ?? 'User';

    await _loadMessages();
  }

  Future<void> _loadMessages() async {
    final query = await Amplify.API.query(
      request: GraphQLRequest<String>(
        document: '''query ListMessages {
          listChatMessages(filter: {
            or: [
              { senderId: { eq: "$_currentUserId" }, receiverId: { eq: "${widget.receiverId}" } },
              { senderId: { eq: "${widget.receiverId}" }, receiverId: { eq: "$_currentUserId" } }
            ]
          }) {
            items {
              id
              message
              senderId
              isFromUser
              createdAt
            }
          }
        }''',
      ),
    ).response;

    final items = jsonDecode(query.data ?? '{}')['listChatMessages']?['items'] ?? [];
    setState(() {
      _messages = List<Map<String, dynamic>>.from(items)..sort((a, b) => a['createdAt'].compareTo(b['createdAt']));
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    await Amplify.API.mutate(
      request: GraphQLRequest<String>(
        document: '''mutation CreateMessage {
          createChatMessage(input: {
            senderId: "$_currentUserId",
            senderName: "$_currentUserName",
            receiverId: "${widget.receiverId}",
            message: "$text",
            isFromUser: true
          }) {
            id
          }
        }''',
      ),
    ).response;

    _messageController.clear();
    await _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['senderId'] == _currentUserId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['message'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
