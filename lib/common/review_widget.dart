import 'package:flutter/material.dart';

class Review {
  String review;
  String author;
  Review(review, author) {
    this.review = review;
    this.author = author;
  }
}

List<Review> reviews = [
  Review(
      'I cannot say enough about Nanny McTea and the fantastic caregivers here! We have someone that we trust who loves our kiddo, takes care in planning fun activities, provides guidance for listening skills, and is available on date nights as well.',
      '~Morales Family'),
  Review(
      'We loved Nanny McTea! We had just moved to the area and were in a pinch. She came prepared! She had felt books for my 1 year old and made slime with my 3.5 year old! I love how she focuses on learning and activities rather than screen time! That was only my 2nd time my kids have had a sitter other than family and and they loved her even my emotional 1 year old! Would recommend to anyone!',
      '~Cady  Family'),
  Review(
      'Love how easy it is to book and set up a caregiver with set prices for a set time.  Very Easy to work with, great caregivers!',
      '~Eavenson Family'),
];

class ReviewWidget extends StatelessWidget {
  final String review;
  final String author;
  final double height;

  const ReviewWidget({Key key, @required this.review, @required this.author, @required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        height: height,
        width: double.infinity,
        // color: Colors.yellow,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade200, Colors.red.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 1],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                '\"${review}\"',
                style: TextStyle(fontSize: 18),
              ),
              Divider(),
              Text(author)
            ],
          ),
        ),
      ),
    );
  }
}
