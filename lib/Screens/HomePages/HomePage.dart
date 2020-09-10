import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Models/NestedChildern.dart';
import 'package:ncrtapp/Screens/LeaderBoard/LeaderBoardPagg.dart';
import 'package:ncrtapp/Screens/Notifications/NotificationPage.dart';
import 'package:ncrtapp/Screens/QuizPages/QuizChild1Page.dart';
import 'package:ncrtapp/Widgets/HomeScreenWidgetItem.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  AdmobBannerSize bannerSize;

  @override
  void initState() {
    super.initState();
    bannerSize = AdmobBannerSize.LARGE_BANNER;
  }

  _launchURL(String url) async {
    url = Uri.encodeFull(url);
    if (true) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              "NCERT Book\n& Solutions",
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 24,
              ),
            ),
            SizedBox(height: 50),
            Divider(
              height: 10,
              thickness: 1,
            ),
            ListTile(
              leading: Image.asset(
                'images/mail.png',
                height: 30,
              ),
              title: Text(
                "Feedback & improvement",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                'images/share.png',
                height: 30,
              ),
              title: Text(
                "Share This App",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              onTap: () =>
                  _launchURL("https://www.examonline.org/privacy-policy.php"),
              leading: Image.asset(
                'images/sec.png',
                height: 30,
              ),
              title: Text(
                "Privacy Policy",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                'images/rate.png',
                height: 30,
              ),
              title: Text(
                "Rate it! It motivates us",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Divider(
              height: 10,
              thickness: 1,
            ),
            SizedBox(height: 10),
            Text(
              "Our other apps",
              style: TextStyle(
                color: Colors.black.withOpacity(0.9),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              onTap: () => _launchURL(
                  "https://play.google.com/store/apps/details?id=com.lms.exam"),
              leading: Icon(Icons.apps),
              title: Text(
                "Free online class",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              onTap: () => _launchURL(
                  "https://play.google.com/store/apps/details?id=org.examonline.playerb"),
              leading: Icon(Icons.apps),
              title: Text(
                "Free offline class",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            }),
        title: Text("Ncert Books & Solutions"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notification_important_outlined,
              color: Colors.white.withOpacity(0.8),
            ),
            onPressed: () {
              kRoute(NotificationPage(), context);
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                childAspectRatio: 1.3,
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: [
                  HomeScreenWidgetItem(
                    imageUrl: 'images/books.png',
                    label: "NCERT Books\n(English Medium)",
                    list: english,
                  ),
                  HomeScreenWidgetItem(
                    imageUrl: 'images/books2.png',
                    label: "NCERT Books\n(Hindi Medium)",
                    list: hindi,
                  ),
                  HomeScreenWidgetItem(
                    imageUrl: 'images/sol.png',
                    label: "NCERT Solutions",
                    list: solutions,
                  ),
                  HomeScreenWidgetItem(
                    imageUrl: 'images/test.png',
                    label: "NCERT Notes",
                    list: notes,
                  ),
                  HomeScreenWidgetItem(
                    imageUrl: 'images/video.png',
                    label: "NCERT Videos",
                    list: vedios,
                  ),
                  HomeScreenWidgetItem(
                    imageUrl: 'images/test1.png',
                    label: "CBSE Papers",
                    list: papers,
                  ),
                  HomeScreenWidgetItem(
                    imageUrl: 'images/quiz.png',
                    label: "Quiz",
                    list: quiz,
                  ),
                  HomeScreenWidgetItem(
                    imageUrl: 'images/rank.png',
                    label: "Leader Board",
                    widget: LeaderBoardPage(),
                  ),
                ],
              ),
            ),
            Container(
              child: AdmobBanner(
                adUnitId: "ca-app-pub-3940256099942544/6300978111",
                adSize: bannerSize,
                listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  canLaunch(String url) {}
}
