import 'package:audiobook/Picker/pickdocuments.dart';
import'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();
  FlutterTts tts = FlutterTts();
  void speak(String? text) async{
    await tts.speak(text!);
  }

  void stop() async{
    await tts.stop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read Aloud'),
        actions: [
          IconButton(onPressed: () {
            controller.clear();
          }, icon: Icon(Icons.delete)),
          IconButton(onPressed: () {
            stop();
          }, icon: Icon(Icons.stop)),
          IconButton(onPressed: () {
            if(controller.text.isNotEmpty) {
              speak(controller.text.trim());
            }
            else{
              print('ERROR');
            }
          }, icon: Icon(Icons.mic)),

        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: TextFormField(
          controller: controller,
          maxLines: MediaQuery.of(context).size.height.toInt(),
          decoration: InputDecoration(
            border: InputBorder.none,
            label: Text("Enter text.....")
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
        pickDocument().then((value) async{
          if(value!=''){
            PDFDoc doc = await PDFDoc.fromPath(value);
            final text = await doc.text;
            controller.text = text;
          }
        });
      },
          label:  Text("pick pdf File")),
    );
  }
}
