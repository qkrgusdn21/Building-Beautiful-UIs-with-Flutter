import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';                        //new
import 'package:flutter/cupertino.dart';                      //new

void main() {
  runApp(new FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendlychat",
      theme: defaultTargetPlatform == TargetPlatform.iOS         //new
        ? kIOSTheme                                              //new
        : kDefaultTheme,      
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {                     //modified
  @override                                                        //new
  State createState() => new ChatScreenState();                    //new
} 

// Add the ChatScreenState class definition in main.dart.

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{
  bool _isComposing = false;  
  @override
  void dispose() {                                                   //new
    for (ChatMessage message in _messages)                           //new
      message.animationController.dispose();                         //new
    super.dispose();                                                 //new
  }               
  final List<ChatMessage> _messages = <ChatMessage>[];  
  final TextEditingController _textController = new TextEditingController();
  @override                                                        //new
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Friendlychat"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
      body: new Container(                                             //modified
          child: new Column(                                           //modified
            children: <Widget>[
              new Flexible(
                child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration: new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS //new
              ? new BoxDecoration(                                     //new
                  border: new Border(                                  //new
                    top: new BorderSide(color: Colors.grey[200]),      //new
                  ),                                                   //new
                )                                                      //new
              : null),                                                 //modified
    );
  }
  Widget _buildTextComposer() {
    return new IconTheme(                                            //new
      data: new IconThemeData(color: Theme.of(context).accentColor), //new
      child: new Container(                                     //modified
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {          //new
                  setState(() {                     //new
                    _isComposing = text.length > 0; //new
                  });                               //new
                },
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                  hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS ?  //modified
              new CupertinoButton(                                       //new
                child: new Text("Send"),                                 //new
                onPressed: _isComposing                                  //new
                    ? () =>  _handleSubmitted(_textController.text)      //new
                    : null,) :                                           //new
              new IconButton(       
                icon: new Icon(Icons.send),
                onPressed: _isComposing ?
                  () =>  _handleSubmitted(_textController.text) : null,
                )
            ),
          ],
        ),
      ),                                                             //new
    );
  }
  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {                                                    //new
      _isComposing = false;                                          //new
    }); 
    ChatMessage message = new ChatMessage(                         //new
      text: text,
      animationController: new AnimationController(                  //new
        duration: new Duration(milliseconds: 700),                   //new
        vsync: this,                                                 //new
      ),                                                             //new
    );                                                                   //new
    setState(() {                                                  //new
      _messages.insert(0, message);                                //new
    });
    message.animationController.forward(); 
  }
}
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(                                    //new
    sizeFactor: new CurvedAnimation(                              //new
        parent: animationController, curve: Curves.easeOut),      //new
    axisAlignment: 0.0,
    child: new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text(_name[0])),
          ),
          new Expanded(  
            child : new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_name, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                ),
              ],
            ),
          )
        ],
      ),
    )
    );
  }
}

const String _name = "Hyun Woo";

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);