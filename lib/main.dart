import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gp1_flutter/firebase_notification/local_notification.dart';
import 'package:gp1_flutter/screens/CreateBusinessScreen/create_business_screen.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/screens/BillingScreen/billing_screen.dart';
import 'package:gp1_flutter/screens/ChangePassword/change_password_screen.dart';
import 'package:gp1_flutter/screens/HomeScreen/home_screen.dart';
import 'package:gp1_flutter/screens/MyAccount/my_account_screen.dart';
import 'package:gp1_flutter/screens/MyOffersScreen/my_offers_screen.dart';
import 'package:gp1_flutter/screens/MySongScreen/my_song_screen.dart';
import 'package:gp1_flutter/screens/Notification/notification_screen.dart';
import 'package:gp1_flutter/screens/Services/services_screen.dart';
import 'package:gp1_flutter/screens/UpdateProfile/update_account_screen.dart';
import 'screens/BillingScreen/add_credit_card.dart';
import 'screens/CreateOffer/create_offer_screen.dart';
import 'screens/CreatePost/create_post_screen.dart';
import 'screens/Forgetpassword/forget_password.dart';
import 'screens/Login/get_started_screen.dart';
import 'screens/Login/login_screen.dart';
import 'screens/Profile/profile_screen.dart';
import 'screens/SignUp/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

Map<int, Color> color = {
  50: const Color.fromRGBO(136, 14, 79, .1),
  100: const Color.fromRGBO(136, 14, 79, .2),
  200: const Color.fromRGBO(136, 14, 79, .3),
  300: const Color.fromRGBO(136, 14, 79, .4),
  400: const Color.fromRGBO(136, 14, 79, .5),
  500: const Color.fromRGBO(136, 14, 79, .6),
  600: const Color.fromRGBO(136, 14, 79, .7),
  700: const Color.fromRGBO(136, 14, 79, .8),
  800: const Color.fromRGBO(136, 14, 79, .9),
  900: const Color.fromRGBO(136, 14, 79, 1),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalNotification.initialize();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        FlutterLocalNotificationsPlugin().cancelAll();
        LocalNotification.showNotification(message);
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        FlutterLocalNotificationsPlugin().cancelAll();
        LocalNotification.showNotification(message);
      },
    );
    requestPermission();
    return MaterialApp(
      routes: {
        '/': (context) => const GetStarted(),
        '/Login': (context) => const Login_page(),
        '/SignUp': (context) => const SignUPScreen(),
        '/Home': (context) => const HomeScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/services': (context) => const ServicesScreen(),
        '/updateAccount': (context) => const UpdateProfileScreen(),
        '/billingDetails': (context) => const BillingScreen(),
        '/addCard': (context) => const AddCreditCard(),
        '/myAccount': (context) => const MyAccountScreen(),
        '/changePassword': (context) => const ChangePasswordScreen(),
        '/ProfileScreen': (context) => const ProfileScreen(),
        '/CreateBusinessScreen': (context) => const CreateBusinessScreen(),
        '/NotificationScreen': (context) => const NotificationScreen(),
        '/createPost': (context) => const CreatePost(),
        '/createOffer': (context) => const CreateOffer(),
        '/myOffers': (context) => const MyOffersScreen(),
        '/mySong': (context) => const MySongScreen(),
        '/ForgetPassword': (context) => const ForgetPassword(),
      },
      initialRoute: '/',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Party Planner',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFFD784F, color),
        colorScheme:
            const ColorScheme.light().copyWith(primary: Color(0xFFFD784F)),
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          displayMedium: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
