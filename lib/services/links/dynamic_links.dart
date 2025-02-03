import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinks {

  Future<Uri> generateDynamicLink() async{
    var dynamicLinkParams = await FirebaseDynamicLinks.instance.buildShortLink(
      DynamicLinkParameters(
        link: Uri.parse("https://communicates.page.link"),
        uriPrefix: "https://communicates.page.link",
        androidParameters: const AndroidParameters(
          packageName: "com.communicates.conversations",
        ),
      ),
    );

    return dynamicLinkParams.shortUrl;
  }
}
