import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/coupon_model.dart';
import 'package:ecommerce_admin_app/widgets/modern_button.dart';
import 'package:ecommerce_admin_app/widgets/modern_text_field.dart';
import 'package:flutter/material.dart';

class ModifyCoupon extends StatefulWidget {
  const ModifyCoupon({super.key});

  @override
  State<ModifyCoupon> createState() => _ModifyCouponState();
}

class _ModifyCouponState extends State<ModifyCoupon> {
  final formKey = GlobalKey<FormState>();
  TextEditingController descController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController disPercentController = TextEditingController();
  
  String couponId = "";
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null && arguments is CouponModel) {
        setData(arguments);
      }
    });
  }

  void setData(CouponModel coupon) {
    couponId = coupon.id;
    isUpdating = true;
    codeController.text = coupon.code;
    descController.text = coupon.desc;
    disPercentController.text = coupon.discount.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(isUpdating ? "Edit Coupon" : "Create New Coupon"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFEC4899), Color(0xFFF97316)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEC4899).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.confirmation_number,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isUpdating ? "Edit Coupon" : "Create New Coupon",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isUpdating 
                          ? "Update coupon details and discount settings"
                          : "Create discount coupons to boost customer engagement and sales",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Coupon Details Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEC4899).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.edit_note,
                            color: Color(0xFFEC4899),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Coupon Information",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF59E0B)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFFF59E0B), size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Coupon codes will be automatically converted to uppercase for consistency",
                              style: TextStyle(
                                color: Color(0xFF92400E),
                                fontSize: 14,
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
                      hint: "Enter coupon code (e.g., SAVE20, WELCOME10)",
                      prefixIcon: Icons.confirmation_number_outlined,
                      validator: (v) => v!.isEmpty ? "Coupon code cannot be empty" : null,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    ModernTextField(
                      controller: descController,
                      label: "Description",
                      hint: "Describe what this coupon offers to customers",
                      prefixIcon: Icons.description_outlined,
                      maxLines: 4,
                      validator: (v) => v!.isEmpty ? "Description cannot be empty" : null,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Discount Settings Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.percent,
                            color: Color(0xFF059669),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Discount Settings",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFDF7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF059669)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.trending_down, color: Color(0xFF059669), size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Set the discount percentage that customers will receive when using this coupon",
                              style: TextStyle(
                                color: Color(0xFF065F46),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
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
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Action Button
              ModernButton(
                text: isUpdating ? "Update Coupon" : "Create Coupon",
                width: double.infinity,
                height: 56,
                onPressed: _handleSubmit,
                backgroundColor: const Color(0xFFEC4899),
                icon: isUpdating ? Icons.update : Icons.add,
              ),
              
              const SizedBox(height: 20),
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

      if (isUpdating) {
        DbService().updateCouponCode(docId: couponId, data: data);
        Navigator.pop(context);
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
        Navigator.pop(context);
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
    }
  }
}