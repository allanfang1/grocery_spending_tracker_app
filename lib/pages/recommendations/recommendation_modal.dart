import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/resize_image.dart';

class RecommendationModal extends ConsumerWidget {
  const RecommendationModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // api call here
    final List<String> recommendations = [
      "Product 1",
      "Product 2",
      "Product 3",
      "Product 4",
      "Product 5",
      "Product 5",
      "Product 5"
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: recommendations.isNotEmpty
          ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 14),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ExpansionTile(
                  leading: FutureBuilder<ByteBuffer?>(
                    future: resizeImage(
                        'https://fevesclark.ca/media/1055/clark-398ml-maple-style-en.png'),
                    builder: (BuildContext context,
                        AsyncSnapshot<ByteBuffer?> snapshot) {
                      if (snapshot.hasData) {
                        return Image.memory(snapshot.data!.asUint8List());
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  title: Text(recommendations[index]),
                  subtitle: const Text('Purchased for {price}'),
                  children: const <Widget>[
                    Text('Purchase Date:'),
                    Text('Purchase Location:')
                  ],
                ));
              },
            )
          : const Text(
              'You don\'t have any recommendations yet.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
    );
  }
}
