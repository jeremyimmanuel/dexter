import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about';

  const AboutPage({Key key}) : super(key: key);

  // No mail alert
  void _noMailAlert(BuildContext context) {
    const String text = 'No mail app found!';
    showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(text),
            actions: <Widget>[
              CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop()),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(
              text,
              style: Theme.of(context).textTheme.body1,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              )
            ],
          );
        }
      },
    );
  }

  // launch URL
  void _launchURL(BuildContext context, String text) async {
    String url;
    print(text);
    if (text == 'jeremy8@uw.edu') {
      final email = 'jeremy8@uw.edu';
      final cc = 'jeremytandjung@icloud.com';
      final subject = '[Dexter%20App]';
      url = 'mailto:$email?subject=$subject&cc=$cc&body=Hello%20there,';
    } else if (text == 'Linkedin') {
      url = 'https://www.linkedin.com/in/jeremytandjung';
    } else if (text == 'Github') {
      url = 'https://github.com/jeremyimmanuel';
    } else if (text == 'Resume') {
      url = 'https://1drv.ms/b/s!Am47sTvB9MiEgs9n6HfYRvQccznyYg?e=bbcPTX';
    } else {
      url = 'https://apple.com';
    }
    print('launch URL Tapped');

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _noMailAlert(context);
    }
  }

  /// Build Links for this about page
  Widget _buildLink(BuildContext context, String text) {
    return Card(
      child: ListTile(
        title: Text(
          text,
          style: Theme.of(context).textTheme.body1.copyWith(
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
        ),
        onTap: () async {
          _launchURL(context, text);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hello There!',
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: 'My name is ',
                style: Theme.of(context).textTheme.body1,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Jeremy Tandjung',
                    style: Theme.of(context).textTheme.body1.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                        ),
                  ),
                  TextSpan(
                    text:
                        ', and this is my first time publishing an app to the App Store and Play Store\n\n',
                  ),
                  TextSpan(
                    text:
                        'If there\'s some bugs, feel free to reach out to me!\n\n',
                  ),
                  TextSpan(
                    text:
                        'I am currently looking for a job, so if you like this app and have an opening for an entry level software engineer/developer position, do let me know! :)\n\n',
                  ),
                  TextSpan(text: 'You can reach me at (Click the links):\n\t'),
                ],
              ),
            ),
            // _buildLink(context, 'Resume'),
            _buildLink(context, 'jeremy8@uw.edu'),
            _buildLink(context, 'Linkedin'),
            _buildLink(context, 'Github'),
          ],
        ),
      ),
    );
  }
}
