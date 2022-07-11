import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatWindow extends StatefulWidget {
  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final List<Message> _messages = <Message>[];

  late TextEditingController textEditingController;
  late ScrollController scrollController;

  bool enableButton = false;

  @override
  void initState() {
    // _messages = <String>[];

    textEditingController = TextEditingController();

    scrollController = ScrollController();

    super.initState();
  }
Future<void> getChatbotReply(String userReply) async {
    print("You: $userReply");
    textEditingController.clear();
    Message userQuery = Message(
      index: 1,
      text: userReply,
    );

    setState(() {
      _messages.insert(0, userQuery);
    });

    var response = await http.get(Uri.parse(
        "http://api.brainshop.ai/get?bid=167820&key=CMmAj5A9zkBWRiO4&uid=bhoomikadhaka&msg=userReply"));
    var data = jsonDecode(response.body);
    print(data.toString());
    // print(data["cnt"]);
    Message botResponse = Message(index: 2, text: data["cnt"]);

    setState(() {
      _messages.insert(0, botResponse);
    });

    // return data["cnt"];
  }

  // void handleSendMessage() {
  //   var text = textEditingController.value.text;
  //   textEditingController.clear();
  //   setState(() {
  //     _messages.add(text);
  //     enableButton = false;
  //   });

  //   Future.delayed(Duration(milliseconds: 100), () {
  //     scrollController.animateTo(scrollController.position.maxScrollExtent,
  //         // ignore: prefer_const_constructors
  //         curve: Curves.ease,
  //         duration: Duration(milliseconds: 500));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var textInput = Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  enableButton = text.isNotEmpty;
                });
              },
              autofocus: true,
              // ignore: prefer_const_constructors
              decoration: InputDecoration.collapsed(
                hintText: "Type a message",
              ),
              controller: textEditingController,
            ),
          ),
        ),
        enableButton
            ? IconButton(
                color: Theme.of(context).primaryColor,
                // ignore: prefer_const_constructors
                icon: Icon(
                  Icons.send,
                ),
                disabledColor: Colors.grey,
                onPressed: ()=> getChatbotReply(textEditingController.text),
              )
            // ignore: prefer_const_constructors
            : IconButton(
                color: Colors.blue,
                // ignore: prefer_const_constructors
                icon: Icon(
                  Icons.send,
                ),
                disabledColor: Colors.grey,
                onPressed: null,
              )
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text("Chat with Jarvis"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool reverse = false;

                if (index % 2 == 0) {
                  reverse = true;
                }

                // ignore: prefer_const_constructors
                var avatar = Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                  // ignore: prefer_const_constructors
               
                  child: CircleAvatar(
                     foregroundColor: index%2==0 ? Colors.black : Colors.white ,
                       backgroundColor: index%2==0 ? Colors.pink[100] : Colors.blue,
                    child: Text(index%2==0 ? "B" : "J" ),
                    
                  ),
                );

                var triangle = CustomPaint(
                  painter: Triangle(),
                );

                var messagebody = DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Flexible(
                      child: Padding(
                       
                        padding: const EdgeInsets.all(12.0),
                        // child: Text(_messages[index]),
                         child: RichText(
                          overflow : TextOverflow.ellipsis  ,
                          softWrap: true,
                          textDirection : TextDirection.ltr,
                          text:TextSpan(
                            
                            text: ( _messages[_messages.length-index-1].text))),
                            
                        //  Text(_messages[_messages.length-index-1].text),
                      ),
                    ),
                  ),
                );

                Widget message;

                if (reverse) {
                  message = Stack(
                    children: <Widget>[
                      messagebody,
                      Positioned(right: 0, bottom: 0, child: triangle),
                    ],
                  );
                } else {
                  message = Stack(
                    children: <Widget>[
                      Positioned(left: 0, bottom: 0, child: triangle),
                      messagebody,
                    ],
                  );
                }

                if (reverse) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: message,
                      ),
                      avatar,
                    ],
                  );
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      avatar,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: message,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Divider(height: 2.0),
          textInput
        ],
      ),
    );
  }
}

class Triangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.amber;

    var path = Path();
    path.lineTo(10, 0);
    path.lineTo(0, -10);
    path.lineTo(-10, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Message extends StatelessWidget {
  @override
  final int index;
  final String text;
  const Message({Key? key, required this.index, required this.text});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 10.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: index % 2 == 0 ? jarvisMessage(context) : myMessage(context),
  //     ),
  //   );
  // }
}
