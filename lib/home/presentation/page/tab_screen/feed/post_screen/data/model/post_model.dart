import 'package:uplift/authentication/data/model/user_model.dart';

import 'prayer_request_model.dart';

class PostModel {
  final UserModel userModel;
  final PrayerRequestPostModel prayerRequestPostModel;

  PostModel(this.userModel, this.prayerRequestPostModel);
}
