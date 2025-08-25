import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:ecommerce_admin_app/firebase_options.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:ecommerce_admin_app/views/admin_home.dart';
import 'package:ecommerce_admin_app/views/categories_page.dart';
import 'package:ecommerce_admin_app/views/coupons.dart';
import 'package:ecommerce_admin_app/views/intro_screen.dart';
import 'package:ecommerce_admin_app/views/login.dart';
import 'package:ecommerce_admin_app/views/modify_product.dart';
import 'package:ecommerce_admin_app/views/modify_promo.dart';
import 'package:ecommerce_admin_app/views/orders_page.dart';
import 'package:ecommerce_admin_app/views/products_page.dart';
import 'package:ecommerce_admin_app/views/promo_banners_page.dart';
import 'package:ecommerce_admin_app/views/signup.dart';
import 'package:ecommerce_admin_app/views/splash_screen.dart';
import 'package:ecommerce_admin_app/views/view_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminProvider(),
      builder: (context, child) => MaterialApp(
        title: 'Shoppy Admin App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'SF Pro Display',
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black87,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          cardTheme: CardTheme(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => const SplashScreen(),
          "/intro": (context) => const IntroScreen(),
          "/login": (context) => LoginPage(),
          "/signup": (context) => SingupPage(),
          "/home": (context) => AdminHome(),
          "/category": (context) => CategoriesPage(),
          "/products": (context) => ProductsPage(),
          "/add_product": (context) => ModifyProduct(),
          "/view_product": (context) => ViewProduct(),
          "/promos": (context) => PromoBannersPage(),
          "/update_promo": (context) => ModifyPromo(),
          "/coupons": (context) => CouponsPage(),
          "/orders": (context) => OrdersPage(),
          "/view_order": (context) => ViewOrder(),
        },
      ),
    );
  }
}
