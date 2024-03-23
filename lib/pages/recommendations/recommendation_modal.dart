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
        child: recommendations.isNotEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  Recommendation rec = recommendations[index];
                  return Card(
                    color: Theme.of(context).colorScheme.surface,
                    margin: EdgeInsets.zero,
                    shape: Border(
                        bottom: BorderSide(
                            width: 1,
                            color:
                                Theme.of(context).colorScheme.outlineVariant)),
                    elevation: 0,
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
                          text: TextSpan(children: [
                            TextSpan(
                                text: rec.location,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                            TextSpan(
                                text: '\n${rec.dateTime}',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface))
                          ]),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
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
