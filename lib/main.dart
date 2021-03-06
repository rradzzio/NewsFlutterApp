import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/app/pages/admin_home.dart';
import 'package:news_app/app/pages/auth/sign_in_page.dart';
import 'package:news_app/app/pages/auth_widget.dart';
import 'package:news_app/app/pages/no_internet_page.dart';
import 'package:news_app/app/pages/user/user_home.dart';
import 'package:news_app/app/providers.dart';
import 'package:news_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: ref.watch(connectivityNotifierProvider).connected ? AuthWidget(
        adminPanelBuilder: (context) => const AdminHome(),
        nonSignedInBuilder: (context) => const SignInPage(),
        signedInBuilder: (context) => const UserHome(),
      ) : const NoInternetPage()
    );
  }
}
