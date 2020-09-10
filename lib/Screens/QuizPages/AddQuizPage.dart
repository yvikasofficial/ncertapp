import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Widgets/AddImageWidget.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class AddQuizPage extends StatefulWidget {
  final String url;
  AddQuizPage({this.url});
  @override
  _AddNewPlayListPageState createState() => _AddNewPlayListPageState();
}

class _AddNewPlayListPageState extends State<AddQuizPage> {
  String quiz;
  bool isLoading = false;
  String uid = Uuid().v4();

  handleUploadPlaylist() async {
    setState(() {
      isLoading = true;
    });
    String path = "${widget.url}/data";

    await Firestore.instance.collection(path).document(uid).setData({
      "quiz": quiz,
      "timestamp": Timestamp.now(),
      "url": "${widget.url}/data/$uid",
    });

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
    Toast.show("Quiz Added!", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      color: Colors.black,
      progressIndicator: SpinKitPouringHourglass(color: kPrimaryColor),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add New Quiz!"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  hintText: "Enter Quiz name",
                ),
                onChanged: (value) {
                  quiz = value;
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => handleUploadPlaylist(),
                child: Container(
                  height: 60,
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: kPrimaryColor,
                  ),
                  child: Center(
                    child: Text(
                      "Upload",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
