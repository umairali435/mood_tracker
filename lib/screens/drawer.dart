import 'package:flutter/material.dart';
import 'package:mood_tracker/utils/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    void launchURL(String url) async {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }

    void launchWebsite() {
      const url = 'https://taskbookapp.blogspot.com/2024/08/task-book-privacy-policy.html';
      launchURL(url);
    }

    void launchAppStore() {
      Share.share("""You can find Task BookKit https://apps.apple.com/store/apps/details?id=com.adeel.todolist""");
    }

    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width / 1.5,
      child: SafeArea(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                "assets/app_splash_logo.png",
                width: 50.0,
                height: 50.0,
              ),
            ),
            const Text(
              "Moods Tracker",
              style: TextStyle(
                fontSize: 24.0,
                color: AppColors.bgOrange,
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(),
            ListTile(
              onTap: () {
                launchWebsite();
              },
              leading: const Icon(
                Icons.privacy_tip,
                color: AppColors.bgOrange,
              ),
              title: const Text("Privacy Policy"),
            ),
            ListTile(
              onTap: () {
                launchAppStore();
              },
              leading: const Icon(
                Icons.share,
                color: AppColors.bgOrange,
              ),
              title: const Text("Share App"),
            ),
          ],
        ),
      ),
    );
  }
}
