import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:image_picker/image_picker.dart";
import '../Utility/Constants.dart';
import 'ChatModel.dart';
import 'package:http/http.dart' as http;

import 'ChatBox.dart';

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

  @override
  void initState() {
    super.initState();
    apiKey = dotenv.env['GEMINI_API'] ?? 'No API Key';
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

    final geminiModel = await sendRequestToGemini(model);

    chatList.insert(0, geminiModel);
    image = null;
    controller.text = '';
    setState(() {});
  }

  void selectImage() async {
    final picker = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.gallery);

    if (picker != null) {
      image = File(picker.path);
    }
  }

  Future<ChatModel> sendRequestToGemini(ChatModel model) async {
    String url = "";
    Map<String, dynamic> body = {};

    if (model.base64EncodedImage == null) {
      url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=${apiKey}";

      body = {
        "contents": [
          {
            "parts": [
              {"text": ChatModel.instructions + model.message},
            ],
          },
        ],
      };
    } else {
      url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=${apiKey}";

      body = {
        "contents": [
          {
            "parts": [
              {"text": ChatModel.instructions + model.message},
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
    }

    Uri uri = Uri.parse(url);

    final result = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    print(result.statusCode);
    print(result.body);

    final decodedJson = json.decode(result.body);

    String message =
        decodedJson['candidates'][0]['content']['parts'][0]['text'];

    ChatModel geminiModel = ChatModel(isMe: false, message: message);

    return geminiModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: kAppBarTitle,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: kBackArrow,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: ListView.builder(
              reverse: true,
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatList[index].isMe ? "Me" : "Assistant"),
                  subtitle: chatList[index].base64EncodedImage != null
                      ? Column(
                          children: [
                            Image.memory(
                              base64Decode(chatList[index].base64EncodedImage!),
                              height: 300,
                              width: double.infinity,
                            ),
                            Text(chatList[index].message),
                          ],
                        )
                      : Text(chatList[index].message),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: ChatBox(
                  controller: controller,
                  filePressed: selectImage,
                ),
              ),
              IconButton(
                onPressed: () {
                  onSendMessage();
                },
                icon: const Icon(
                  Icons.send,
                  color: kSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
