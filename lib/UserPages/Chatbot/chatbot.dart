import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:image_picker/image_picker.dart";
import '../../Utility/Appbar.dart';
import '../../Utility/Constants.dart';
import 'ChatModel.dart';
import 'package:http/http.dart' as http;
import 'ChatBox.dart';
import 'TypingAnimation.dart';

class ChatBot extends StatefulWidget {
  static const String id = 'Chatbot';
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  late String apiKey;
  List<ChatModel> chatList = [];
  final TextEditingController controller = TextEditingController();
  File? image;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: kPrimaryColor),
    );
    apiKey = dotenv.env['GEMINI_API'] ?? 'No API Key found';
  }

  void onSendMessage() async {
    late ChatModel model;

    if (image == null) {
      model = ChatModel(isMe: true, message: controller.text);
    } else {
      final imageBytes = await image!.readAsBytes();
      String base64EncodedImage = base64Encode(imageBytes);
      model = ChatModel(
        isMe: true,
        message: controller.text,
        base64EncodedImage: base64EncodedImage,
      );
    }

    chatList.insert(0, model);
    setState(() {});
    controller.text = '';
    image = null;

    // Show typing animation
    setState(() {
      isTyping = true;
    });

    final geminiModel = await sendRequestToGemini(model);

    // Remove typing animation and add response
    setState(() {
      isTyping = false;
      chatList.insert(0, geminiModel);
    });
  }

  void selectImage() async {
    // ignore: invalid_use_of_visible_for_testing_member
    final picker = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.gallery);
    if (picker != null) {
      image = File(picker.path);
    }
  }

  Future<ChatModel> sendRequestToGemini(ChatModel model) async {
    String url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=${apiKey}";

    Map<String, dynamic> body = {
      "contents": [
        {
          "parts": [
            {"text": ChatModel.instructions + model.message},
            if (model.base64EncodedImage != null)
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": model.base64EncodedImage,
                }
              }
          ],
        },
      ],
    };

    Uri uri = Uri.parse(url);
    final result = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    if (result.statusCode >= 500 && result.statusCode <= 599) {
      return ChatModel(
          isMe: false, message: 'Currently Chatbot is down try again later...');
    } else {
      final decodedJson = json.decode(result.body);
      String message =
          decodedJson['candidates'][0]['content']['parts'][0]['text'];
      return ChatModel(isMe: false, message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Appbar(
        title: 'AI Assistant',
        isBackButton: true,
        displayUserProfile: true,
      ),
        body: Column(
          children: [
            Expanded(
              flex: 10,
              child: ListView.builder(
                reverse: true,
                itemCount: chatList.length + (isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isTyping && index == 0) {
                    return ListTile(
                      title: const Text("Assistant",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const TypingAnimation(),
                    );
                  }

                  final chatIndex = isTyping ? index - 1 : index;
                  return ListTile(
                    title: Text(chatList[chatIndex].isMe ? "Me" : "Assistant",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: chatList[chatIndex].base64EncodedImage != null
                        ? Column(
                            children: [
                              Image.memory(
                                base64Decode(
                                    chatList[chatIndex].base64EncodedImage!),
                                height: 300,
                                width: double.infinity,
                              ),
                              Text(chatList[chatIndex].message),
                            ],
                          )
                        : Text(chatList[chatIndex].message),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ChatBox(
                    controller: controller,
                    filePressed: selectImage,
                  ),
                ),
                IconButton(
                  onPressed: () => onSendMessage(),
                  icon: const Icon(Icons.send, color: kSecondaryColor),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      
    );
  }
}
