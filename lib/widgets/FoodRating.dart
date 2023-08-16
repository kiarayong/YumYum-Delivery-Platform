import 'package:flutter/material.dart';

class FoodRating extends StatefulWidget {
  final double initialRating;
  final Function(double) onRatingChanged;
  final bool allowInteraction;

  FoodRating({
    this.initialRating = 0.0,
    this.onRatingChanged,
    this.allowInteraction = true,
  });

  @override
  _FoodRatingState createState() => _FoodRatingState();
}

class _FoodRatingState extends State<FoodRating> {
  double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: widget.allowInteraction
              ? () {
                  setState(() {
                    _rating = index + 1.0;
                    if (widget.onRatingChanged != null) {
                      widget.onRatingChanged(_rating);
                    }
                  });
                }
              : null,
          child: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.orange,
          ),
        );
      }),
    );
  }
}
