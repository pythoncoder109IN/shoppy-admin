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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminProvider(),
      builder: (context, child) => MaterialApp(
        title: 'Shoppy Admin App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(0xFFFFFFFE),
            foregroundColor: Color(0xFF1E293B),
            surfaceTintColor: Colors.transparent,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.05),
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF6366F1),
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          listTileTheme: const ListTileThemeData(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
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
