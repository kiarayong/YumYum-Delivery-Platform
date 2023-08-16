import 'package:flutter/material.dart';
import 'package:l1_213544z_yongle_project/blocs/CartBloc.dart';
import 'package:l1_213544z_yongle_project/utils/universal_variables.dart';
import 'package:l1_213544z_yongle_project/widgets/cartitemswidget.dart';
import 'package:l1_213544z_yongle_project/models/Food.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartPageBloc(),
      child: Consumer<CartPageBloc>(
        builder: (context, cartPageBloc, child) {
         
          return CartPageContent(cartPageBloc: cartPageBloc);
        },
      ),
    );
  }
}

class CartPageContent extends StatefulWidget {
  final CartPageBloc cartPageBloc;

  CartPageContent({this.cartPageBloc});

  @override
  _CartPageContentState createState() => _CartPageContentState();
}

class _CartPageContentState extends State<CartPageContent> {
  TextEditingController nametextcontroller = TextEditingController();
  TextEditingController addresstextcontroller = TextEditingController();
  CartPageBloc cartPageBloc;

  @override
  void initState() {
    super.initState();

    // Pass the context to the CartPageBloc
    widget.cartPageBloc.context = context;

    // Initialize the CartPageBloc here to avoid null errors
    widget.cartPageBloc.getDatabaseValue();

     widget.cartPageBloc.loadCartItems();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0, backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 30.0, top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Order",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 35.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Divider(thickness: 2.0),
              ),
              createListCart(),
              createTotalPriceWidget(),
            ],
          ),
        ),
      ),
    );
  }

  createTotalPriceWidget() {
    return Container(
      color: Colors.white30,
      padding: EdgeInsets.only(right: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total :",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 25.0,
                ),
              ),
              Text(
                "\$${widget.cartPageBloc.totalPrice.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
          Divider(thickness: 2.0),
          SizedBox(height: 20.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.14,
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    UniversalVariables.orangeColor,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () => _showDialog(),
                child: Text(
                  "Place Order",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: UniversalVariables.whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  createListCart() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 400,
      child: widget.cartPageBloc.cartItems.length == 0 // Use cartItems from the bloc
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.cartPageBloc.cartItems.length, // Use cartItems from the bloc
              itemBuilder: (_, index) {
                Food foodItem = widget.cartPageBloc.cartItems[index]; // Use cartItems from the bloc
                return CartItems(foodItem);
              },
            ),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return handleOrderPlacement();
      },
    );
  }

  handleOrderPlacement() {
    // check if card is empty
    if (widget.cartPageBloc.totalPrice == 0) {
      print("not order");
      return AlertDialog(
        title: Text('No Order'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Card Is Empty !'),
              Text('Add Some Product on Card First'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text('Please fill in your detials'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Fill Details'),
              TextField(
                controller: nametextcontroller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'eg. Akshay',
                ),
              ),
              TextField(
                controller: addresstextcontroller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'eg. st road west chembur',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Order'),
            onPressed: () {
              print('Order button pressed');
              widget.cartPageBloc.orderPlaceToFirebase(
                nametextcontroller.text,
                addresstextcontroller.text,
              );
            },
          ),
        ],
      );
    }
  }
}
