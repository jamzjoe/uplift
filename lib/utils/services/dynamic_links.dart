import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class MyDynamicLink {
  Future<String> generateDynamicLink(
      {String? postID, postUser, String? title, String? description}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
          title: title,
          description: description,
          imageUrl: Uri.parse(
              "https://firebasestorage.googleapis.com/v0/b/uplift-2316e.appspot.com/o/logo%2Flogo-uplift.png?alt=media&token=2a525179-e294-4ee8-9298-6238e66e449a")),
      uriPrefix: 'https://godesq.page.link',
      link: Uri.parse('https://uplift.com/share/$postID/$postUser'),
      androidParameters: const AndroidParameters(
        packageName: 'com.godesq.uplift',
      ),
      // Additional platform-specific parameters if needed
      // ...
    );

    final FirebaseDynamicLinks shortLink = FirebaseDynamicLinks.instance;
    final refLink = await shortLink.buildShortLink(parameters);
    log(refLink.shortUrl.toString());
    log(refLink.previewLink.toString());
    return refLink.shortUrl.toString();
  }

  Future<String> generateDynamicLinkForProfile({String? userID}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://godesq.page.link',
      link: Uri.parse('https://uplift.com/profile/$userID'),
      androidParameters: const AndroidParameters(
        packageName: 'com.godesq.uplift',
      ),
      // Additional platform-specific parameters if needed
      // ...
    );

    final FirebaseDynamicLinks shortLink = FirebaseDynamicLinks.instance;
    final refLink = await shortLink.buildShortLink(parameters);
    log(refLink.shortUrl.toString());
    log(refLink.previewLink.toString());
    return refLink.shortUrl.toString();
  }
}
