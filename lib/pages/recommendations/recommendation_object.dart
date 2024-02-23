import 'package:flutter/material.dart';

class RecommendationObject extends StatefulWidget {
  final String productName;
  final String address;
  final double price;
  final String imageUrl;

  const RecommendationObject(
      {super.key,
      required this.productName,
      required this.address,
      required this.price,
      required this.imageUrl});

  @override
  State<RecommendationObject> createState() => _RecommendationObjectState();
}

class _RecommendationObjectState extends State<RecommendationObject> {
  late String productName;
  late String address;
  late double price;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    productName = widget.productName;
    address = widget.address;
    price = widget.price;
    imageUrl = widget.imageUrl;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Center(child: Text(productName)),
              subtitle:
                  Text('This product was purchased for \$$price at $address!'),
            ),
            Image.network(
              "https://fevesclark.ca/media/1055/clark-398ml-maple-style-en.png",
              scale: 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
