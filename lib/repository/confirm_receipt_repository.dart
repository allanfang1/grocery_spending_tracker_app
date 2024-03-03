import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'confirm_receipt_repository.g.dart';

class ConfirmReceiptRepository {
  ConfirmReceiptRepository(this.profileRepository);
  final ProfileRepository profileRepository;
  http.Client client = http.Client();

  Future<int> submitTrip(String trip) async {
    final response = await client.post(
      Uri.parse(dotenv.env['BASE_URL']! + Constants.SUBMIT_TRIP_PATH),
      headers: {
        'Content-Type': 'application/json',
        'auth': profileRepository.user.token!
      },
      body: trip,
    );

    return response.statusCode;
  }
}

@Riverpod(keepAlive: true)
ConfirmReceiptRepository confirmReceiptRepository(
    ConfirmReceiptRepositoryRef ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return ConfirmReceiptRepository(profileRepository);
}
