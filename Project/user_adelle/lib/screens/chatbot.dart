import 'package:flutter/material.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class Bot extends StatefulWidget {
//   const Bot({super.key});

//   @override
//   State<Bot> createState() => _BotState();
// }

// class _BotState extends State<Bot> {
//   final supabase = Supabase.instance.client;
//   List<Map<String, String>> faqList = [];
//   List<Map<String, String>> chatMessages = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchFaqData();
//   }

//   Future<void> fetchFaqData() async {
//     final response =
//         await supabase.from('tbl_faq').select('faq_question, faq_answer');
//     if (response != null) {
//       setState(() {
//         faqList = response
//             .map<Map<String, String>>((faq) => {
//                   "question": faq['faq_question'] as String,
//                   "answer": faq['faq_answer'] as String,
//                 })
//             .toList();
//       });
//     }
//   }

//   void sendMessage(String question) {
//     final answer = faqList.firstWhere((faq) => faq["question"] == question,
//         orElse: () =>
//             {"answer": "Sorry, I don't have an answer for that."})["answer"];
//     setState(() {
//       chatMessages.add({"sender": "user", "text": question});
//       chatMessages.add({"sender": "bot", "text": answer!});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Chatbot"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16.0),
//               itemCount: chatMessages.length,
//               itemBuilder: (context, index) {
//                 final message = chatMessages[index];
//                 final isUser = message["sender"] == "user";
//                 return Align(
//                   alignment:
//                       isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     margin: const EdgeInsets.symmetric(vertical: 5),
//                     decoration: BoxDecoration(
//                       color: isUser ? Colors.blue : Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       message["text"]!,
//                       style: TextStyle(
//                         color: isUser ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 2)],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "You may ask:",
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Wrap(
//                   spacing: 8.0,
//                   children: faqList.map((faq) {
//                     return ElevatedButton(
//                       onPressed: () => sendMessage(faq["question"]!),
//                       child: Text(faq["question"]!),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
