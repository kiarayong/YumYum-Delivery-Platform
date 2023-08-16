import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:l1_213544z_yongle_project/blocs/FoodDetailBloc.dart';
import 'package:l1_213544z_yongle_project/models/Food.dart';
import 'package:l1_213544z_yongle_project/utils/universal_variables.dart';
import 'package:l1_213544z_yongle_project/widgets/foodTitleWidget.dart';
import 'package:provider/provider.dart';

class FoodDetailPage extends StatelessWidget {
  final Food food;
  final Function(double) onRatingUpdated;
  final GlobalKey<ScaffoldState> scaffoldKey;

  FoodDetailPage({this.food, this.onRatingUpdated, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FoodDetailPageBloc(scaffoldKey: scaffoldKey),
      child: FoodDetailPageContent(
        food,
        scaffoldKey: scaffoldKey,
      ),
    );
  }
}

class FoodDetailPageContent extends StatefulWidget {
  final Food food;

  FoodDetailPageContent(this.food, {GlobalKey<ScaffoldState> scaffoldKey});

  @override
  _FoodDetailPageContentState createState() => _FoodDetailPageContentState();
}

class _FoodDetailPageContentState extends State<FoodDetailPageContent> {
  FoodDetailPageBloc foodDetailPageBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await foodDetailPageBloc.getPopularFoodList();
      await fetchRatingFromFirestore();
    });
  }
  

  Future<void> fetchRatingFromFirestore() async {
    try {
      final foodRef =
          FirebaseFirestore.instance.collection('Foods').doc(widget.food.keys);
      final docSnapshot = await foodRef.get();
      final foodData = docSnapshot.data();
      if (foodData != null && foodData.containsKey('foodRating')) {
        final rating = double.tryParse(foodData['foodRating']) ?? 0.0;
        foodDetailPageBloc.updateRating(rating.toString());
      }
    } catch (e) {
      print('Error fetching food rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    foodDetailPageBloc = Provider.of<FoodDetailPageBloc>(context);
    foodDetailPageBloc.context = context;
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: UniversalVariables.whiteColor,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Hero(
                tag: "food_avatar_${widget.food.keys}",
                child: Container(
                  padding: EdgeInsets.all(0.0),
                  child: Stack(
                    children: [
                      Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(80.0),
                          ),
                          gradient: LinearGradient(
                            colors: [Colors.black45, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            "${foodDetailPageBloc.rating.toStringAsFixed(1)} ★",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: UniversalVariables.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.bottomLeft,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(80.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(widget.food.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              createdetails(),
              createPopularFoodList(),
            ],
          ),
        ),
      ),
    );
  }

  createdetails() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
            widget.food.name,
            style: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
              color: UniversalVariables.orangeColor,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 18.0,
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: Text(
                  "\$" + widget.food.price,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: UniversalVariables.orangeColor,
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                margin: EdgeInsets.only(right: 18.0),
                decoration: BoxDecoration(
                  color: UniversalVariables.orangeColor,
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                child: Row(
                  children: <Widget>[
                    foodDetailPageBloc.mItemCount != 1
                        ? new IconButton(
                            icon: new Icon(
                              Icons.remove,
                              color: UniversalVariables.whiteColor,
                              size: 30.0,
                            ),
                            onPressed: () =>
                                foodDetailPageBloc.decreamentItems(),
                          )
                        : new IconButton(
                            icon: new Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onPressed: () => null,
                          ),
                    new Text(
                      foodDetailPageBloc.mItemCount.toString(),
                      style: TextStyle(
                        color: UniversalVariables.whiteColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new IconButton(
                      icon: new Icon(
                        Icons.add,
                        color: UniversalVariables.whiteColor,
                        size: 30.0,
                      ),
                      onPressed: () => foodDetailPageBloc.increamentItems(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(UniversalVariables.orangeColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              onPressed: () => Provider.of<FoodDetailPageBloc>(context, listen: false).addToCart(widget.food),

              child: Text(
                "Add To Cart",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                  color: UniversalVariables.whiteColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
  

  createPopularFoodList() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Popular Food ",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 200.0,
            child: foodDetailPageBloc.foodList.length == 0
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: foodDetailPageBloc.foodList.length,
                    itemBuilder: (_, index) {
                      return FoodTitleWidget(
                        foodDetailPageBloc.foodList[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
