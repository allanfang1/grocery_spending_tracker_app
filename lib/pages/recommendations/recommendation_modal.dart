import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/resize_image.dart';
import 'package:grocery_spending_tracker_app/controller/recommendations_controller.dart';
import 'package:grocery_spending_tracker_app/model/recommendation.dart';

class RecommendationModal extends ConsumerWidget {
  const RecommendationModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(recommendationsControllerProvider);

    return recommendationsAsync.when(data: (void data) {
      final List<Recommendation> recommendations = ref
          .watch(recommendationsControllerProvider.notifier)
          .getRecommendations();
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: recommendations.isNotEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 14),
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  Recommendation rec = recommendations[index];
                  return Card(
                      child: ExpansionTile(
                    leading: FutureBuilder<ByteBuffer?>(
                      future: resizeImage(rec.imageUrl),
                      builder: (BuildContext context,
                          AsyncSnapshot<ByteBuffer?> snapshot) {
                        if (snapshot.hasData) {
                          return Image.memory(snapshot.data!.asUint8List());
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    title: Text(
                      rec.itemName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Purchased for \$${rec.price}'),
                    children: <Widget>[
                      const SizedBox(height: 10),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                            const TextSpan(text: 'Product purchased at '),
                            TextSpan(
                                text: rec.location,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const TextSpan(text: ' on '),
                            TextSpan(
                                text: '${rec.dateTime}.',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ])),
                      const SizedBox(height: 10),
                    ],
                  ));
                },
              )
            : const Text(
                'You don\'t have any recommendations yet.',
                style:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
      );
    }, error: (Object error, StackTrace stackTrace) {
      return Text('Error: $error');
    }, loading: () {
      return Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
        child: const SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    });
  }
}
