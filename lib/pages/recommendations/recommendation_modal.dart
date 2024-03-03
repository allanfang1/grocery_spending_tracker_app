import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/pages/recommendations/recommendation_object.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RecommendationModal extends StatefulWidget {
  const RecommendationModal({super.key});

  @override
  State<RecommendationModal> createState() => _RecommendationModalState();
}

class _RecommendationModalState extends State<RecommendationModal> {
  late PageController _pageController;
  late int _pageCount;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageCount = 3; // placeholder
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height - 450,
            child: PageView.builder(
                controller: _pageController,
                itemCount: _pageCount,
                itemBuilder: (BuildContext context, int index) {
                  return RecommendationObject(
                      productName: 'Beans $index',
                      address: '1579 Main Street West',
                      price: 5.23,
                      imageUrl: 'test');
                })),
        const SizedBox(height: 25),
        SmoothPageIndicator(
          controller: _pageController,
          count: _pageCount,
          effect: const WormEffect(activeDotColor: Colors.purple),
        )
      ],
    );
  }
}
