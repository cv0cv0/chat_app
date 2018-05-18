import 'package:chat_app/const/const.dart';
import 'package:chat_app/style/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Chat Application',
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? iosTheme
            : androidTheme,
        home: Chat(),
      );
}

class Chat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  final message = <Msg>[];
  final textController = TextEditingController();
  bool isWriting = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Chat Application'),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemBuilder: (_, index) => message[index],
                itemCount: message.length,
                reverse: true,
                padding: EdgeInsets.all(6.0),
              ),
            ),
            Divider(height: 1.0),
            Container(
              child: buildComposer(),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    for (var msg in message) {
      msg.animationController.dispose();
    }
    super.dispose();
  }

  buildComposer() => IconTheme(
        data: IconThemeData(
          color: Theme.of(context).accentColor,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: textController,
                  onChanged: (text) => setState(() {
                        isWriting = text.length > 0;
                      }),
                  // onSubmitted: submitMsg,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter some text to send a message',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 3.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text('Submit'),
                        onPressed: isWriting
                            ? () => submitMsg(textController.text)
                            : null,
                      )
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: isWriting
                            ? () => submitMsg(textController.text)
                            : null,
                      ),
              ),
            ],
          ),
          // decoration: Theme.of(context).platform == TargetPlatform.iOS
          //     ? BoxDecoration(
          //         border: Border(
          //           top: BorderSide(color: Colors.grey, width: 0.6),
          //         ),
          //       )
          //     : null,
        ),
      );

  submitMsg(String text) {
    var msg = Msg(
      text: text,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
    );

    textController.clear();
    setState(() {
      isWriting = false;
      message.insert(0, msg);
    });
    msg.animationController.forward();
  }
}

class Msg extends StatelessWidget {
  Msg({this.text, this.animationController});

  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) => SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
        axisAlignment: 0.0,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 18.0),
                child: CircleAvatar(
                  child: Text(defaultUsername[0]),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      defaultUsername,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 6.0),
                      child: Text(text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
