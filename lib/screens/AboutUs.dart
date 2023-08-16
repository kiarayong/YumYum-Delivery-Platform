import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      color: Colors.orange[100],
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Yum Yum Food Delivery',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Text(
                  'Food Delivery at Your Fingertips!',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget btnSection = Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(18),
              ),
              child: IconButton(
                onPressed: () async {
                  String telephoneNumber = '+6581234567';
                  String callUrl = "tel:$telephoneNumber";
                  if (await canLaunch(callUrl)) {
                    await launch(callUrl);
                  } else {
                    throw "Error occured trying to call this number.";
                  }
                },
                icon: Icon(
                  Icons.call,
                  color: Colors.deepOrange[800],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: IconButton(
                onPressed: () async {
                  String email = 'this.is.tijani@gmail.com';
                  String subject = 'Please enter your subject';
                  String body = 'This isemail body';
                  String emailUrl = "mailto:$email?subject=$subject&body=$body";

                  if (await canLaunch(emailUrl)) {
                    await launch(emailUrl);
                  } else {
                    throw "Error occured sending an email";
                  }
                },
                icon: Icon(
                  Icons.mail,
                  color: Colors.deepOrange[800],
                ),
              ),
            ),
          )
        ],
      ),
    );

    Widget textSection = Padding(
      padding: EdgeInsets.all(0),
      child: Container(
          height: 188,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.orange[50],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 40),
            child: Text(
              'YumYum Food Delivery: Bringing Culinary Delights to Your Doorstep. Explore a diverse menu, place orders, and enjoy your favorite meals delivered promptly. Elevate your dining journey with convenience, flavor, and satisfaction. Experience culinary delight, delivered.',
              style: TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.justify,
              softWrap: true,
            ),
          )),
    );

    return MaterialApp(
  title: 'Flutter layout demo',
  home: Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.orange[50],
      leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
      ),
    ),
    body: ListView(
      children: [
        Image.network(
          'https://firebasestorage.googleapis.com/v0/b/project-45295.appspot.com/o/profilepage.jpg?alt=media&token=ca100fad-7017-4cf1-8270-d04b2af5e699',
          width: 600,
          height: 240,
          fit: BoxFit.cover,
        ),
        titleSection,
        textSection,
        btnSection,
      ],
    ),
  ),
);
  }
}

