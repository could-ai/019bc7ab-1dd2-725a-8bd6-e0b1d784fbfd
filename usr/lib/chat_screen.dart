import 'package:flutter/material.dart';
import 'models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    Message(
      id: '1',
      text: 'Welcome to the Chat App! 👋',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.insert(0, Message(
        id: DateTime.now().toString(),
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
      ));
    });

    // Simulate a bot response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.insert(0, Message(
            id: DateTime.now().toString(),
            text: "I received: $text",
            isMe: false,
            timestamp: DateTime.now(),
          ));
        });
      }
    });
  }

  Widget _buildMessage(Message message) {
    final align = message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = message.isMe ? Theme.of(context).colorScheme.primary : Colors.grey[300];
    final textColor = message.isMe ? Theme.of(context).colorScheme.onPrimary : Colors.black87;
    final borderRadius = message.isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          )
        : const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius,
            ),
            child: Text(
              message.text,
              style: TextStyle(color: textColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0, right: 4.0, left: 4.0),
            child: Text(
              "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              reverse: true, // Start from the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.primary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
