import 'package:ecommerce_admin_app/containers/dashboard_text.dart';
import 'package:ecommerce_admin_app/containers/home_button.dart';
import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () async {
                Provider.of<AdminProvider>(
                  context,
                  listen: false,
                ).cancelProvider();
                await AuthService().logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login",
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF1F5F9),
                foregroundColor: const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome back!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Here's what's happening with your store today",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats Section
            const Text(
              "Overview",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Consumer<AdminProvider>(
                builder: (context, value, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardText(
                      keyword: "Total Categories",
                      value: "${value.categories.length}",
                    ),
                    DashboardText(
                      keyword: "Total Products",
                      value: "${value.products.length}",
                    ),
                    DashboardText(
                      keyword: "Total Orders",
                      value: "${value.totalOrders}",
                    ),
                    DashboardText(
                      keyword: "Pending Orders",
                      value: "${value.orderPendingProcess}",
                    ),
                    DashboardText(
                      keyword: "Orders Shipped",
                      value: "${value.ordersOnTheWay}",
                    ),
                    DashboardText(
                      keyword: "Orders Delivered",
                      value: "${value.ordersDelivered}",
                    ),
                    DashboardText(
                      keyword: "Orders Cancelled",
                      value: "${value.ordersCancelled}",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HomeButton(
                  onTap: () {
                    Navigator.pushNamed(context, "/orders");
                  },
                  name: "Orders",
                ),
                HomeButton(
                  onTap: () {
                    Navigator.pushNamed(context, "/products");
                  },
                  name: "Products",
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HomeButton(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/promos",
                      arguments: {"promo": true},
                    );
                  },
                  name: "Promos",
                ),
                HomeButton(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/promos",
                      arguments: {"promo": false},
                    );
                  },
                  name: "Banners",
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HomeButton(
                  onTap: () {
                    Navigator.pushNamed(context, "/category");
                  },
                  name: "Categories",
                ),
                HomeButton(
                  onTap: () {
                    Navigator.pushNamed(context, "/coupons");
                  },
                  name: "Coupons",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
