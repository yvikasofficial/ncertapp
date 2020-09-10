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

class AddNewPlayListPage extends StatefulWidget {
  final String url;
  AddNewPlayListPage({this.url});
  @override
  _AddNewPlayListPageState createState() => _AddNewPlayListPageState();
}

class _AddNewPlayListPageState extends State<AddNewPlayListPage> {
  File file;
  String apiUrl;
  String playlistName;
  bool isLoading = false;
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
    final url = await hanldeUploadImage();
    await Firestore.instance.collection(widget.url).document(uid).setData({
      "playlistName": playlistName,
      "url": apiUrl,
      "timestamp": Timestamp.now(),
      "uid": uid,
      "imageUrl": url,
    });

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
    Toast.show("Playlist Added!", context,
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
          title: Text("Create New Playlist"),
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
                  hintText: "Enter the API url",
                ),
                onChanged: (value) {
                  apiUrl = value;
                },
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  playlistName = value;
                },
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  hintText: "Enter the Playlist Name",
                ),
              ),
              GestureDetector(
                onTap: () => handleChooseFromGallary(context),
                child: AddImageWiget(
                  file: file,
                  onClose: () {
                    setState(() {
                      file = null;
                    });
                  },
                ),
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
