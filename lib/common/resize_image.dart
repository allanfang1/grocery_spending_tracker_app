import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;

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
