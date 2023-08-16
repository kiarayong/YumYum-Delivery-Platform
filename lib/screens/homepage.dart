

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:l1_213544z_yongle_project/blocs/HomeBloc.dart';
import 'package:l1_213544z_yongle_project/resourese/firebaseauth_service.dart';
import 'package:l1_213544z_yongle_project/screens/AboutUs.dart';
import 'package:l1_213544z_yongle_project/screens/CartPage.dart';
import 'package:l1_213544z_yongle_project/screens/MyOrderPage.dart';
import 'package:l1_213544z_yongle_project/screens/Profile.dart';
import 'package:l1_213544z_yongle_project/screens/SearchPage.dart';
import 'package:l1_213544z_yongle_project/widgets/foodTitleWidget.dart';
import 'package:l1_213544z_yongle_project/models/Food.dart';

import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageBloc(),
      child: HomePageContent()
    );
  }
}

class HomePageContent extends StatefulWidget {

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {

  HomePageBloc homePageBloc;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      homePageBloc.getCurrentUser();
      homePageBloc.getRecommendedFoodList();
      homePageBloc.fetchPopularFoods();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    homePageBloc = Provider.of<HomePageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        elevation: 0.0,
        title: Text("Home", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 30.0),),
      ),
      drawer: createDrawer(),
      body: SingleChildScrollView(
          child: Container(
          //padding: EdgeInsets.symmetric(horizontal:20.0,vertical:10.0),
          width: MediaQuery.of(context).size.width,
          color:Colors.white,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
            createSearchBar(),
 SizedBox(height: 10.0,),
            createBanner(),
            SizedBox(height: 10.0,),
            createPopularFoodList(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:18.0),
              child: Text("For You",style: TextStyle(color: Colors.black45,fontSize: 20.0,fontWeight: FontWeight.bold,),),
            ),
            createForYou(),
          ],)
        ),
      ),
    );
  }
  List<String> imgList = [
  'https://firebasestorage.googleapis.com/v0/b/project-45295.appspot.com/o/homepage1.jpg?alt=media&token=40b157d5-ae25-4921-bf26-b46a8a52df9b',
  'https://firebasestorage.googleapis.com/v0/b/project-45295.appspot.com/o/homepage2.jpg?alt=media&token=807c3cee-e525-429f-b7f4-0c301add36a2',
  'https://firebasestorage.googleapis.com/v0/b/project-45295.appspot.com/o/homepage3.jpg?alt=media&token=cafebfdd-ffc6-4a84-94b7-97b7c04eaa7b',
  // Add more image URLs as needed
];

createBanner() {
  return CarouselSlider(
    options: CarouselOptions(
      height: 200.0,
      autoPlay: true,
      enlargeCenterPage: true,
    ),
    items: imgList.map((imageUrl) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    }).toList(),
  );
}

  createDrawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          DrawerHeader(
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.white,),
              accountName:Text("Welcome Back!") ,
              accountEmail: Text(homePageBloc.mFirebaseUser?.email?? ""),

              ),
   
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios,),
            leading: Icon(Icons.home,color: Colors.orangeAccent,),
            title: Text('Home',),
            onTap: () {
              Navigator.pop(context);
            },
          ),
                    ListTile(
            trailing: Icon(Icons.arrow_forward_ios,),
            leading: Icon(Icons.person,color: Colors.orangeAccent,),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
            },
          ),
           ListTile(
            trailing: Icon(Icons.arrow_forward_ios,),
            leading: Icon(Icons.info,color: Colors.orangeAccent,),
            title: Text('About Us'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUs()));
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios,),
            leading: Icon(Icons.shopping_basket,color: Colors.orangeAccent,),
            title: Text('Cart'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage()));
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios,),
            leading: Icon(Icons.fastfood,color: Colors.orangeAccent,),
            title: Text('My Order'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOrderPage()));
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios,),
            leading: Icon(Icons.clear,color: Colors.orangeAccent,),
            title: Text('Logout'),
            onTap: () async {
          await FirebaseAuthService().signOut();
          Navigator.of(context).pushNamed('/login');
        },
          ),
        ],
      ),
    );
  }

  createPopularFoodList() {
    return Container(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              "Popular Food ",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          Container(
            height: 200.0,
            child: FutureBuilder<List<Food>>(
              future: homePageBloc.fetchPopularFoods(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  List<Food> popularFoods = snapshot.data;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: popularFoods.length,
                    itemBuilder: (_, index) {
                      return FoodTitleWidget(popularFoods[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  
  createSearchBar(){
    return  Container(
      height: MediaQuery.of(context).size.height*0.08,
      child: Stack(
        children: <Widget>[
          // Replace this container with your Map widget
          Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomRight:Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 15,
            left: 15,
            child: GestureDetector(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage())),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left:18.0),
                        child: Text("Search",style: TextStyle(color: Colors.black45),),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(icon: Icon(Icons.search,color: Colors.orange,), onPressed: null)
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


void updateAllFoodRatings(double newRating) {
    setState(() {
      for (int i = 0; i < homePageBloc.foodList.length; i++) {
        homePageBloc.foodList[i].foodRating = newRating.toString();
      }
    });
  }

  createForYou(){
    return Container(
      height:MediaQuery.of(context).size.height*0.5,
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: homePageBloc.foodList.length==0 ? Center(child: CircularProgressIndicator())
          : ListView.builder(
          itemCount: homePageBloc.foodList.length,
          itemBuilder: (_,index){
            return FoodTitleWidget(homePageBloc.foodList[index]);
          }
      ),
    );
  }
}
