import 'package:flutter/material.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile Demo',
      home: const MyHomePage(),
    );
  }
}     

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController identityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  List<String> imageUrls = [];

  CleverTapPlugin _clevertapPlugin = CleverTapPlugin();

  @override
  void initState() {
    super.initState();
    CleverTapPlugin.createNotificationChannel(
        "LogInTest", "Game Of Thrones", "Game Of Thrones", 3, true);
    CleverTapPlugin.setDebugLevel(3);
    _clevertapPlugin.setCleverTapDisplayUnitsLoadedHandler(onDisplayUnitsLoaded);
    _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(pushClickedPayloadReceived);
  }

  void pushClickedPayloadReceived(Map<String, dynamic> notificationPayload) {
    print("pushClickedPayloadReceived called with notification payload: " +
        notificationPayload.toString());
    // You may perform UI operation like redirecting the user to a specific page based on custom key-value pairs
    // passed in the notificationPayload. You may also perform non UI operation such as HTTP requests, IO with local storage etc.
    handleNotificationClick(notificationPayload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: identityController,
              decoration: const InputDecoration(labelText: 'Identity'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            TextField(
              controller: dobController,
              decoration: const InputDecoration(labelText: 'Date of Birth'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onUserLogin();
                  },
                  child: const Text('OnUserLogin'),
                ),
                ElevatedButton(
                  onPressed: () {
                    pushProfile();
                  },
                  child: const Text('PushProfile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    nativeDisplay();
                  },
                  child: const Text('Native Display'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (imageUrls.isNotEmpty)
              CarouselSlider(
                items: imageUrls.map((imageUrl) {
                  return Image.network(imageUrl);
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onUserLogin() {
    var profile = {
      'Name': nameController.text,
      'Identity': identityController.text,
      'Email': emailController.text,
      'Phone': phoneController.text,
    };
    print('OnUserLogin: $profile');
    CleverTapPlugin.onUserLogin(profile);
  }

  void pushProfile() {
    var profile = {
      'Name': nameController.text,
      'Identity': identityController.text,
      'Email': emailController.text,
      'Phone': phoneController.text,
    };
    print('PushProfile: $profile');
    CleverTapPlugin.profileSet(profile);
  }

  void nativeDisplay() {
    CleverTapPlugin.recordEvent("Native Display", {});
  }

  void onDisplayUnitsLoaded(List<dynamic>? displayUnits) {
    setState(() {
      displayUnits?.forEach((element) {
        print(element.toString());
        var img1 = element["content"][0]["icon"]["url"];
        var img2 = element["content"][0]["media"]["url"];
        setState(() {
          imageUrls.add(img1.toString());
          imageUrls.add(img2.toString());
        });
      });
    });
  }
}

void handleNotificationClick(Map<String, dynamic> notificationPayload) {
  // Implement your custom handling logic here
}
