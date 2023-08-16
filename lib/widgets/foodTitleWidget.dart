import 'package:flutter/material.dart';
import 'package:l1_213544z_yongle_project/models/Food.dart';
import 'package:l1_213544z_yongle_project/screens/FoodDetailPage.dart';
import 'package:l1_213544z_yongle_project/utils/universal_variables.dart';

class FoodTitleWidget extends StatefulWidget {
  final Food food;

  FoodTitleWidget(this.food);

  @override
  _FoodTitleWidgetState createState() => _FoodTitleWidgetState();
}

class _FoodTitleWidgetState extends State<FoodTitleWidget> {
  double _rating;

 @override
  void initState() {
    super.initState();
    // Initialize the rating to the food's current rating
    _rating = double.parse(widget.food.foodRating ?? '0');
  }

  @override
  Widget build(BuildContext context) {

    

    return GestureDetector(
      onTap: () => gotoFoodDetails(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            Container(
              height: 120.0,
              width: 120.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
               child: Image.network(
                  widget.food.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Wrap(
              spacing: 20.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              direction: Axis.vertical,
              children: [
                Text(
                  "${widget.food.name}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(height: 10.0),
               
                    Text(
                      _rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: UniversalVariables.orangeAccentColor,
                      ),
                    ),
                    SizedBox(width: 5.0),
                     Row(
                  children: List.generate(5, (index) {
                    bool isFilled = index < _rating.floor();
                    return GestureDetector(
                      onTap: () {
                        // Update the rating when the user taps on a star
                        setState(() {
                          _rating = index + 1.0;
                        });
                        // Update the food rating in Firestore
                        widget.food.updateRating(_rating);
                      },
                      child: Icon(
                        isFilled ? Icons.star : Icons.star_border,
                        color: UniversalVariables.orangeAccentColor,
                      ),
                    );
                  }),
                ),
                  ],
                ),
                Text(
                  "\$${widget.food.price}",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),

               
              ],
            )
          ],
        ),
      ),
    );
  }
  gotoFoodDetails() {
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>FoodDetailPage(fooddata)));
      Navigator.push(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => FoodDetailPage(food: widget.food)));
    }
}
