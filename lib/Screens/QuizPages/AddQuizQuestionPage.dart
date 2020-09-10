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

class AddQuizQuestionPage extends StatefulWidget {
  final String url;
  AddQuizQuestionPage({this.url});
  @override
  _AddNewPlayListPageState createState() => _AddNewPlayListPageState();
}

class _AddNewPlayListPageState extends State<AddQuizQuestionPage> {
  String question = "";
  String op1 = "";
  String op2 = "";
  String op3 = "";
  String op4 = "";
  String op = "";
  String type = "text";
  bool isLoading = false;
  File file;

  String uid = Uuid().v4();

  hanldeUploadImage() async {
    if (file == null) return;
    StorageUploadTask uploadTask =
        FirebaseStorage.instance.ref().child("$uid.jpg").putFile(file);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    return await storageSnap.ref.getDownloadURL();
  }

  handleChooseFromGallary(context) async {
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 960, maxHeight: 675);
    if (file == null) return;
    setState(() {
      this.file = file;
    });
  }

  handleUploadPlaylist() async {
    setState(() {
      isLoading = true;
    });
    String path = "${widget.url}/ques";
    String url;
    if (type == "image") url = await hanldeUploadImage();
    await Firestore.instance.collection(path).document(uid).setData({
      "question": question,
      "op": op,
      "op1": op1,
      "op2": op2,
      "op3": op3,
      "op4": op4,
      "imageUrl": url,
      "timestamp": Timestamp.now(),
      "url": "${widget.url}/ques/$uid",
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
          title: Text("Add Question"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 40),
                DropdownButton<String>(
                  value: type,
                  items: <String>["text", "image"].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      type = value;
                    });
                  },
                ),
                type != "text"
                    ? GestureDetector(
                        onTap: () => handleChooseFromGallary(context),
                        child: AddImageWiget(
                          file: file,
                          onClose: () {
                            setState(() {
                              file = null;
                            });
                          },
                        ),
                      )
                    : Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              hintText: "Enter the question",
                            ),
                            maxLines: 5,
                            onChanged: (value) {
                              question = value;
                            },
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              hintText: "Option 1",
                            ),
                            onChanged: (value) {
                              op1 = value;
                            },
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              hintText: "Option 2",
                            ),
                            onChanged: (value) {
                              op2 = value;
                            },
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              hintText: "Option 3",
                            ),
                            onChanged: (value) {
                              op3 = value;
                            },
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              hintText: "Option 4",
                            ),
                            onChanged: (value) {
                              op4 = value;
                            },
                          ),
                        ],
                      ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    hintText: "Correct Option(Number)",
                  ),
                  onChanged: (value) {
                    op = value;
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
      ),
    );
  }
}
