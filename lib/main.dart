import 'package:ecommerce_admin_app/containers/additional_confirm.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/coupon_model.dart';
import 'package:ecommerce_admin_app/widgets/modern_button.dart';
import 'package:ecommerce_admin_app/widgets/modern_text_field.dart';
import 'package:flutter/material.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Discount Coupons"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const ModifyCoupon(
                    id: "",
                    code: "",
                    desc: "",
                    discount: 0,
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                foregroundColor: const Color(0xFF6366F1),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEC4899),
                  Color(0xFFF97316),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.confirmation_number,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Manage Coupons",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Create discount codes to boost customer engagement",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: StreamBuilder(
              stream: DbService().readCouponCode(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<CouponModel> coupons =
                      CouponModel.fromJsonList(snapshot.data!.docs)
                          as List<CouponModel>;

                  if (coupons.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEC4899).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.confirmation_number_outlined,
                              size: 48,
                              color: Color(0xFFEC4899),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "No Coupons Yet",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Create discount coupons to attract more customers",
                            style: TextStyle(
                              color: Color(0xFF64748B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const ModifyCoupon(
                                  id: "",
                                  code: "",
                                  desc: "",
                                  discount: 0,
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Create Coupon"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEC4899),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: coupons.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
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
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Coupon Code Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFEC4899), Color(0xFFF97316)],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      coupons[index].code,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  // Discount Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF059669).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.percent,
                                          size: 16,
                                          color: Color(0xFF059669),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${coupons[index].discount}% OFF",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF059669),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Color(0xFF64748B),
                                    ),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        showDialog(
                                          context: context,
                                          builder: (context) => ModifyCoupon(
                                            id: coupons[index].id,
                                            code: coupons[index].code,
                                            desc: coupons[index].desc,
                                            discount: coupons[index].discount,
                                          ),
                                        );
                                      } else if (value == 'delete') {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AdditionalConfirm(
                                            contentText: "Are you sure you want to delete this coupon?",
                                            onNo: () {
                                              Navigator.pop(context);
                                            },
                                            onYes: () {
                                              DbService().deleteCouponCode(
                                                docId: coupons[index].id,
                                              );
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit_outlined, size: 20),
                                            SizedBox(width: 12),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete_outline, 
                                                 size: 20, color: Colors.red),
                                            SizedBox(width: 12),
                                            Text('Delete', 
                                                 style: TextStyle(color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                coupons[index].desc,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEC4899)),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const ModifyCoupon(
              id: "",
              code: "",
              desc: "",
              discount: 0,
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Coupon"),
        backgroundColor: const Color(0xFFEC4899),
        foregroundColor: Colors.white,
      ),
    );
  }
}

class ModifyCoupon extends StatefulWidget {
  final String id, code, desc;
  final int discount;
  const ModifyCoupon({
    super.key,
    required this.id,
    required this.code,
    required this.desc,
    required this.discount,
  });

  @override
  State<ModifyCoupon> createState() => _ModifyCouponState();
}

class _ModifyCouponState extends State<ModifyCoupon> {
  final formKey = GlobalKey<FormState>();
  TextEditingController descController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController disPercentController = TextEditingController();

  @override
  void initState() {
    descController.text = widget.desc;
    codeController.text = widget.code;
    disPercentController.text = widget.discount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEC4899), Color(0xFFF97316)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.confirmation_number,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.id.isNotEmpty ? "Edit Coupon" : "Create Coupon",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.id.isNotEmpty 
                          ? "Update coupon details"
                          : "Create a new discount coupon",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Form Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFF59E0B)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Color(0xFFF59E0B), size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Coupon codes will be automatically converted to uppercase",
                                style: TextStyle(
                                  color: Color(0xFF92400E),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      ModernTextField(
                        controller: codeController,
                        label: "Coupon Code",
                        hint: "Enter coupon code (e.g., SAVE20)",
                        prefixIcon: Icons.confirmation_number_outlined,
                        validator: (v) => v!.isEmpty ? "Coupon code cannot be empty" : null,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      ModernTextField(
                        controller: descController,
                        label: "Description",
                        hint: "Describe what this coupon offers",
                        prefixIcon: Icons.description_outlined,
                        maxLines: 3,
                        validator: (v) => v!.isEmpty ? "Description cannot be empty" : null,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      ModernTextField(
                        controller: disPercentController,
                        label: "Discount Percentage",
                        hint: "Enter discount percentage (1-100)",
                        prefixIcon: Icons.percent,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v!.isEmpty) return "Discount percentage cannot be empty";
                          final discount = int.tryParse(v);
                          if (discount == null || discount < 1 || discount > 100) {
                            return "Please enter a valid percentage (1-100)";
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ModernButton(
                              text: widget.id.isNotEmpty ? "Update Coupon" : "Create Coupon",
                              onPressed: _handleSubmit,
                              backgroundColor: const Color(0xFFEC4899),
                              icon: widget.id.isNotEmpty ? Icons.update : Icons.add,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (formKey.currentState!.validate()) {
      var data = {
        "code": codeController.text.toUpperCase(),
        "desc": descController.text,
        "discount": int.parse(disPercentController.text),
      };

      if (widget.id.isNotEmpty) {
        DbService().updateCouponCode(docId: widget.id, data: data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text("Coupon updated successfully!"),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } else {
        DbService().createCouponCode(data: data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text("Coupon created successfully!"),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
      Navigator.pop(context);
    }
  }
}