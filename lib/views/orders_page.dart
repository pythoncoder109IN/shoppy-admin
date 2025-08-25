import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/orders_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  totalQuantityCalculator(List<OrderProductModel> products) {
    int qty = 0;
    products.map((e) => qty += e.quantity).toList();
    return qty;
  }

  Widget statusIcon(String status) {
    Color bgColor;
    Color textColor;
    IconData icon;
    String displayText;

    switch (status) {
      case "PAID":
        bgColor = const Color(0xFF059669);
        textColor = Colors.white;
        icon = Icons.payment;
        displayText = "PAID";
        break;
      case "ON_THE_WAY":
        bgColor = const Color(0xFFF59E0B);
        textColor = Colors.white;
        icon = Icons.local_shipping;
        displayText = "SHIPPED";
        break;
      case "DELIVERED":
        bgColor = const Color(0xFF10B981);
        textColor = Colors.white;
        icon = Icons.check_circle;
        displayText = "DELIVERED";
        break;
      default:
        bgColor = const Color(0xFFEF4444);
        textColor = Colors.white;
        icon = Icons.cancel;
        displayText = "CANCELLED";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            displayText,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Orders"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<OrdersModel> orders =
              OrdersModel.fromJsonList(value.orders) as List<OrdersModel>;

          if (orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Color(0xFF94A3B8),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No Orders Found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Orders will appear here once customers start purchasing",
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/view_order",
                        arguments: orders[index],
                      );
                    },
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    title: Text(
                      "Order by ${orders[index].name}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          "₹${orders[index].total}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateTime.fromMillisecondsSinceEpoch(orders[index].created_at)
                              .toString()
                              .split('.')[0],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    trailing: statusIcon(orders[index].status),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ViewOrder extends StatefulWidget {
  const ViewOrder({super.key});

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrdersModel;
    return Scaffold(
      appBar: AppBar(title: Text("Order Summary")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Delivery Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                color: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order Id : ${args.id}"),
                    Text(
                      "Order On : ${DateTime.fromMillisecondsSinceEpoch(args.created_at).toString()}",
                    ),
                    Text("Order by : ${args.name}"),
                    Text("Phone no : ${args.phone}"),
                    Text("Delivery Address : ${args.address}"),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: args.products
                    .map(
                      (e) => Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(e.image),
                                ),
                                SizedBox(width: 10),
                                Expanded(child: Text(e.name)),
                              ],
                            ),
                            Text(
                              "₹${e.single_price.toString()} x ${e.quantity.toString()} quantity",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹${e.total_price.toString()}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Discount : ₹${args.discount}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Total : ₹${args.total}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Status : ${args.status}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),

              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  child: Text("Modify Order"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ModifyOrder(order: args),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModifyOrder extends StatefulWidget {
  final OrdersModel order;
  const ModifyOrder({super.key, required this.order});

  @override
  State<ModifyOrder> createState() => _ModifyOrderState();
}

class _ModifyOrderState extends State<ModifyOrder> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Modify this order"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("Chosse want you want set"),
          ),
          TextButton(
            onPressed: () async {
              await DbService().updateOrderStatus(
                docId: widget.order.id,
                data: {"status": "PAID"},
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Order Paid by user"),
          ),
          TextButton(
            onPressed: () async {
              await DbService().updateOrderStatus(
                docId: widget.order.id,
                data: {"status": "ON_THE_WAY"},
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Order Shipped"),
          ),
          TextButton(
            onPressed: () async {
              await DbService().updateOrderStatus(
                docId: widget.order.id,
                data: {"status": "DELIVERED"},
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Order Delivered"),
          ),
          TextButton(
            onPressed: () async {
              await DbService().updateOrderStatus(
                docId: widget.order.id,
                data: {"status": "CANCELLED"},
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Cancel Order"),
          ),
        ],
      ),
    );
  }
}
