import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class MyDynamicLink {
  Future<String> generateDynamicLink({String? postID, postUser}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
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
