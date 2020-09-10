import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Widgets/AddImageWidget.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class CreateNewPdfPage extends StatefulWidget {
  final String url;
  CreateNewPdfPage({this.url});
  @override
  _AddNewPlayListPageState createState() => _AddNewPlayListPageState();
}

class _AddNewPlayListPageState extends State<CreateNewPdfPage> {
  File file;
  String pdfName;
  bool isLoading = false;
  String uid = Uuid().v4();

  Future savePdf(List<int> asset, String uid) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(uid);
    StorageUploadTask uploadTask = reference.putData(asset);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    return url;
  }

  handleChooseFromGallary(context) async {
    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (file == null) return;
    this.file = file;
    setState(() {});
  }

  handleUploadPlaylist() async {
    setState(() {
      isLoading = true;
    });
    final url = await savePdf(file.readAsBytesSync(), uid);
    await Firestore.instance.collection(widget.url).document(uid).setData({
      "pdfName": pdfName,
      "timestamp": Timestamp.now(),
      "uid": uid,
      "pdfUrl": url,
    });

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
    Toast.show("Pdf Uploaded", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  _pdfSelected() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.greenAccent.withOpacity(0.8),
      ),
      child: Center(
        child: Text(
          "PDF Selected",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _noPdfWidget() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No PDF Selected",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Tap to select!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      color: Colors.black,
      progressIndicator: SpinKitPouringHourglass(color: kPrimaryColor),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add New PDF"),
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
                  hintText: "Enter PDF Name",
                ),
                onChanged: (value) {
                  pdfName = value;
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => handleChooseFromGallary(context),
                child: file == null ? _noPdfWidget() : _pdfSelected(),
              ),
              SizedBox(height: 30),
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
