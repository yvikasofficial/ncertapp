import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const kThemeColor = Colors.white;
const kPrimaryColor = Color(0xFF7F00FF);

kReplaceRoute(Widget widget, BuildContext context) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

kRoute(Widget widget, BuildContext context) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => widget));
}

kShowCircularProgressIndicator() {
  return SpinKitHourGlass(color: kPrimaryColor);
}

kWrapChild(Widget child, String label) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            letterSpacing: 1.2,
            color: Colors.black,
            fontSize: 25,
          ),
        ),
        child,
      ],
    ),
  );
}

kQuestionsLeft(String label) {
  return Container(
    height: 40,
    width: 90,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      color: Colors.teal,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 2),
          blurRadius: 6,
        )
      ],
    ),
    child: Center(
      child: Text("$label",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
    ),
  );
}

hanldeShowDialogBox(String label, Function fun, BuildContext context) {
  return showDialog(
    context: context,
    child: SimpleDialog(children: [
      Container(
        margin: EdgeInsets.all(20),
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    fun();
                  },
                  child: Container(
                    height: 60,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 60,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "No",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ]),
  );
}

kInputField(lable, IconData icon, validate, isValid,
    {keyboard = TextInputType.text}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: TextField(
      onChanged: validate,
      textAlign: TextAlign.start,
      style: TextStyle(fontSize: 20, color: Colors.black87),
      decoration: InputDecoration(
        labelText: "$lable",
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
        hintText: "Enter your $lable",
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
        errorText: isValid ? null : "min length is 3",
        border: new OutlineInputBorder(),
        prefixIcon: Icon(
          icon,
          color: Colors.black,
        ),
      ),
      keyboardType: keyboard,
    ),
  );
}
