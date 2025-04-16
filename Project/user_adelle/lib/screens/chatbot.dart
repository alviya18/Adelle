import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  List<Map<String, String>> queryList = [];
  List<Map<String, String>> answerMessages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchFaqData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchFaqData() async {
    final response = await supabase
        .from('tbl_chatBot')
        .select('chatBot_query, chatBot_response');

    setState(() {
      queryList = response
          .map<Map<String, String>>((query) => {
                "question": query['chatBot_query'] as String,
                "answer": query['chatBot_response'] as String,
              })
          .toList();
    });
  }

  void sendMessage(String question) {
    // Check if the question already exists in the answerMessages list
    final existingIndex = answerMessages.indexWhere(
      (message) => message["sender"] == "user" && message["text"] == question,
    );

    if (existingIndex != -1) {
      // If the question exists, scroll to its position
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent +
              existingIndex * 60.0, // Approximate height of each message
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
      return;
    }

    // If the question doesn't exist, add it and its answer
    final answer = queryList.firstWhere(
      (query) => query["question"] == question,
      orElse: () => {"answer": "Sorry, I don't have an answer for that."},
    )["answer"];

    setState(() {
      answerMessages.add({"sender": "user", "text": question});
      answerMessages.add({"sender": "bot", "text": answer!});
    });

    // Scroll to the bottom after adding a new message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(206, 251, 240, 240),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(81, 220, 1, 16),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        "ChatBot",
                        style: GoogleFonts.sortsMillGoudy().copyWith(
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 5,
          ),
          // Chat Messages Section
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: answerMessages.length,
              itemBuilder: (context, index) {
                final message = answerMessages[index];
                final isUser = message["sender"] == "user";
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: isUser ? Color(0xFFDC010E) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      message["text"]!,
                      style: GoogleFonts.sortsMillGoudy().copyWith(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Suggested Questions Section
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 5,
                      children: queryList.map((query) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(12),
                              side: BorderSide(color: Color(0xFFDC010E)),
                              surfaceTintColor: Colors.white,
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              overlayColor: Color(0xFFDC010E),
                              shadowColor: Colors.white),
                          onPressed: () => sendMessage(query["question"]!),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(query["question"]!),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
