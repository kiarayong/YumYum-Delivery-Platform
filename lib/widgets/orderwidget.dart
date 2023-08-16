import 'package:flutter/material.dart';
import 'package:l1_213544z_yongle_project/models/Food.dart';
import 'package:l1_213544z_yongle_project/models/Request.dart';
import 'package:l1_213544z_yongle_project/utils/universal_variables.dart';

import 'foodTitleWidget.dart';

class OrderWidget extends StatefulWidget {
  final Request request;
  OrderWidget(this.request);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  List<Step> steps = [
    Step(
      content: Text('Placed'),
      title: Text('Placed'),
      isActive: true,
    ),
    Step(
      title: Text('On The Way'),
      content: Text('On The Way'),
      isActive: true,
    ),
    Step(
      content: Text('Completed'),
      title: Text('Completed'),
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(widget.request.name,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold,),),
            subtitle:Text(widget.request.address,style: TextStyle(color: Colors.black38,fontWeight: FontWeight.normal,),) ,
            leading: CircleAvatar(backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/project-45295.appspot.com/o/circleavatar.png?alt=media&token=95d9810a-31bf-44f1-958a-287326dc5688"),),
            trailing:Text("\$"+widget.request.total,style: TextStyle(color: UniversalVariables.orangeColor,fontSize: 20.0, fontWeight: FontWeight.bold,),) ,
          ),

          createSatusBar(),
          Container(
            padding: EdgeInsets.only(left: 20.0,top: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your Food",style: TextStyle(color: Colors.black45,fontSize: 16.0,fontWeight: FontWeight.bold,),),
                createListOfFood(),
              ],
            ),
          )
        ],
      ),
    );
  }

  createSatusBar(){
    return Container(
      height: 100.0,
      child: Stepper(
        currentStep: int.parse(widget.request.status),
        steps: steps,
        type: StepperType.horizontal,
        physics: NeverScrollableScrollPhysics(),
        controlsBuilder: (BuildContext context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
            Container(height: 0.0,),
      ),
    );
  }

createListOfFood() {
  List<Food> foodList = [];
  widget.request.foodList.forEach((value) {
    Food food = Food(
      name: value["name"],
      image: value["image"],
      keys: value["keys"],
      price: value["price"],
      description: value["description"],
      menuId: value["menuId"],
      discount: value["discount"],
    );
    foodList.add(food);
  });

  // Rest of the code...



    return Container(
      height:200.0,
      child: foodList.length==-1 ? Center(child: CircularProgressIndicator())
          : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: foodList.length,
          itemBuilder: (_,index){
            return FoodTitleWidget(
              foodList[index],
            );
          }
      ),
    );
  }
}