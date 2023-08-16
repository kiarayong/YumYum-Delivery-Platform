
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:l1_213544z_yongle_project/models/Request.dart';
import 'package:l1_213544z_yongle_project/resourese/auth_methods.dart';
import 'package:l1_213544z_yongle_project/resourese/firebase_helper.dart';
import 'package:l1_213544z_yongle_project/utils/universal_variables.dart';
import 'package:l1_213544z_yongle_project/widgets/orderwidget.dart';

class MyOrderPage extends StatefulWidget {
  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  List<Request> requestList = [];
  AuthMethods authMethods = AuthMethods();
  FirebaseHelper mFirebaseHelper = FirebaseHelper();
  User currentUser;

 @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      currentUser = await authMethods.getCurrentUser();
      fetchOrders();
    });
  }

  // Fetch orders from Firestore
  void fetchOrders() async {
    try {
      List<Request> orders = await mFirebaseHelper.fetchOrders(currentUser);
      setState(() {
        requestList = orders;
      });
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, left: 18.0),
              child: Text(
                "My Orders",
                style: TextStyle(
                  color: UniversalVariables.orangeAccentColor,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0.0,left: 20.0),
              child: createListOfOrder(),
            ),
          ],
        ),
      ),
    );
  }

  createListOfOrder() {
    return requestList.length == -1
      ? Center(child: CircularProgressIndicator())
      : ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: requestList.length,
          itemBuilder: (_, index) {
            return OrderWidget(
              requestList[index],
            );
          },
        );
  }
}
