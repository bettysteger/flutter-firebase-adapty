import 'package:flutter/material.dart';
import 'package:somegame/theme.dart';

class Imprint extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text('Information in accordance with Section 5 TMG', style: Body1BoldTextStyle),
        Text('Somecompany\nAddress\n\n'),
        Text('Contact Information', style: Body1BoldTextStyle),
        Text('Email: test@example.com\nInternet address:\nhttps://github.com/sponsors/bettysteger\n\n'),
        Text('Disclaimer', style: Body1BoldTextStyle),
        Text('Accountability for content\nThe contents of our pages have been created with the utmost care. However, we cannot guarantee the contents\' accuracy, completeness or topicality. According to statutory provisions, we are furthermore responsible for our own content on these web pages. In this matter, please note that we are not obliged to monitor the transmitted or saved information of third parties, or investigate circumstances pointing to illegal activity. Our obligations to remove or block the use of information under generally applicable laws remain unaffected by this as per §§ 8 to 10 of the Telemedia Act (TMG).\n\nAccountability for links\nResponsibility for the content of external links (to web pages of third parties) lies solely with the operators of the linked pages. No violations were evident to us at the time of linking. Should any legal infringement become known to us, we will remove the respective link immediately.\n\nCopyright\nOur web pages and their contents are subject to German copyright law. Unless expressly permitted by law, every form of utilizing, reproducing or processing works subject to copyright protection on our web pages requires the prior consent of the respective owner of the rights. Individual reproductions of a work are only allowed for private use. The materials from these pages are copyrighted and any unauthorized use may violate copyright laws.')
      ],
    );
  }
}
