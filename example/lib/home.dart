import 'package:flutter/material.dart';
import 'package:notifications_package/notifications_package.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://images.pexels.com/photos/13845237/pexels-photo-13845237.jpeg'))),
              ),
              Center(
                child: ElevatedButton(
                  key: const Key('showNotificationButton'),
                  onPressed: () {
                    NotificationWidget.showNotification(
                        context: context,
                        width: 300,
                        title: const Text('Title',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        message: const Text(
                            textAlign: TextAlign.justify,
                            maxLines: 4,
                            'Example message'),
                        tooltip: 'Close',
                        //padding: EdgeInsets.all(20),
                        cardWithBlur: true,
                        cardOpacity: 0.8,
                        alignment: Alignment.bottomRight);
                  },
                  child: const Text('Show notification'),
                ),
              ),
            ],
          )),
    );
  }
}
