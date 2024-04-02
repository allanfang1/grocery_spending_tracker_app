import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;

/* Takes a URL to a web image and resizes it to a 100px by 100px image.
* This is used for the images on recommendations. */
Future<ByteBuffer?> resizeImage(String url) async {
  var imageUrl = Uri.parse(url);
  http.Response response = await http.get(imageUrl);
  Uint8List original = response.bodyBytes;

  var codec = await instantiateImageCodec(original,
      targetHeight: 100, targetWidth: 100);
  var frameInfo = await codec.getNextFrame();
  Image resized = frameInfo.image;

  ByteData? resizedData = await resized.toByteData(format: ImageByteFormat.png);

  return resizedData?.buffer;
}
