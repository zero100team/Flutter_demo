import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const String _name = "User132";
const _kakaoBackgroundColor = Color(0xffaec3d2);
const _kakaoColor = Color(0xfff8de00);

class SocketIO extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ActionBar(),
        Expanded(
          child: MessageList(),
        )
      ],
    );
  }
}

class ActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kakaoBackgroundColor,
      padding: const EdgeInsets.all(7),
      child: Row(
        children: <Widget>[
          _buildIcon(Icons.arrow_back),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 7),
              child: Text('그룹채팅',
                  style:
                      TextStyle(fontSize: 18.5, fontWeight: FontWeight.w600)),
            ),
          ),
          _buildIcon(Icons.search),
          _buildIcon(Icons.menu),
        ],
      ),
    );
  }

  Container _buildIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(9),
      child: Icon(icon, size: 25),
    );
  }
}

class MessageList extends StatefulWidget {
  final WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://15.164.167.20:4000/');
  MessageList({Key key}) : super(key: key);

  @override
  MessageListState createState() => MessageListState();
}

class MessageListState extends State<MessageList> {
  List<String> messages = List<String>();
  ScrollController _scrollController = new ScrollController();
  TextEditingController _textEditingController = new TextEditingController();
  bool isTextFieldEmpty = true;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(textFieldOnChange);
    widget.channel.stream.listen((data) {
      debugPrint("11111/DataReceived: " + data);
      setState(() {
        messages.add(data);
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    }, onDone: () {
      debugPrint("11111/Task Done");
    }, onError: (error) {
      debugPrint("11111/Some Error");
    });
  }

  void textFieldOnChange() {
    if (_textEditingController.text.length == 0 && !isTextFieldEmpty) {
      setState(() {
        isTextFieldEmpty = true;
      });
    } else if (_textEditingController.text.length != 0 && isTextFieldEmpty) {
      setState(() {
        isTextFieldEmpty = false;
      });
    }
  }

  void _sendMessage(String text) {
    widget.channel.sink.add(text);
    _textEditingController.clear();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: messages.length,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            //TODO Implement Message Widget
            return Text(messages[index], style: TextStyle(fontSize: 30),);
          },
        )),
        Row(
          children: <Widget>[
            _buildIcon(Icons.add_circle_outline),
            Expanded(
              child: TextField(
                cursorColor: Color(0xff2e5984),
                cursorWidth: 1,
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            _buildIcon(Icons.tag_faces),
            getSendIcon(),
          ],
        )
      ],
    );
  }

  Widget getSendIcon() {
    if (isTextFieldEmpty) {
      return _buildIcon(Icons.keyboard_voice);
    } else {
      return GestureDetector(
          onTap: () => _sendMessage(_textEditingController.text),
          child: Container(
            color: _kakaoColor,
            child: Container(
              padding: const EdgeInsets.all(11),
              child: Icon(
                Icons.send,
                size: 28,
                color: Colors.black,
              ),
            ),
          ),
      );
    }
  }

  Container _buildIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(11),
      child: Icon(
        icon,
        size: 28,
        color: Colors.black26,
      ),
    );
  }
}

/*
class SocketIO extends StatefulWidget {
  final WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://15.164.167.20:4000/');

  SocketIO({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SocketIO> {
  TextEditingController _controller = TextEditingController();

  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(snapshot.hasData ? '${snapshot.data}' : ''));
              }),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    widget.channel.sink.add(text);
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _sendMessage,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _sendMessage(_textController.text)),
              ),
            ],
          )),
    );
  }
}
*/
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(_name[0])),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_name),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
