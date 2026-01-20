
import 'package:flutter/material.dart';
import '../../models/chat_message.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/input_bar.dart';
import '../../services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final ScrollController scrollController = ScrollController();

  void addMessage(String text, bool isUser) {
    setState(() {
      messages.add(ChatMessage(
        text: text,
        isUserMessage: isUser,
        timestamp: DateTime.now(),
      ));
    });
    scrollToBottom();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          0.0, // Since your ListView is reversed, 0.0 is the bottom
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void handleSend(String text) {
    addMessage(text, true);

    // AI Response Simulation
    Future.delayed(Duration(milliseconds: 800), () {
      addMessage('AI: Thanks for your message! 🌸', false);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Applying Pink Theme locally to this screen
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink, primary: Colors.pink),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat UI ✅', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink,
          centerTitle: true,
        ),
        body: Container(
          color: Colors.pink.shade50, // Light pink background
          child: Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? Center(child: Text('Send message to start!',
                    style: TextStyle(color: Colors.pink.shade300)))
                    : ListView.builder(
                  controller: scrollController,
                  reverse: true, // Newest messages at bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    // With reverse: true, index 0 is the last message added
                    return MessageBubble(
                      message: messages[messages.length - 1 - index],
                    );
                  },
                ),
              ),
              InputBar(onSendMessage: handleSend),
            ],
          ),
        ),
      ),
    );
  }
}
