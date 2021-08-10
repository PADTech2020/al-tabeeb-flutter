import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRatingBar extends StatelessWidget {
  final double rate;
  final Function onRatingUpdateHandler;
  final bool allowHalfRating;
  final double itemSize;
  final int itemCount;

  CustomRatingBar(this.rate, this.onRatingUpdateHandler, {this.itemCount = 5, this.itemSize = 25, this.allowHalfRating = false});
  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: rate,
      itemSize: itemSize,
      itemCount: itemCount,
      allowHalfRating: allowHalfRating,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rate) => onRatingUpdateHandler(rate, context),
    );
  }
}
