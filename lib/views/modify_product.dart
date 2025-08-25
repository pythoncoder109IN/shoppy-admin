import 'dart:io';

import 'package:ecommerce_admin_app/controllers/cloudinary_service.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/controllers/storage_service.dart';
import 'package:ecommerce_admin_app/models/products_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:ecommerce_admin_app/widgets/modern_button.dart';
import 'package:ecommerce_admin_app/widgets/modern_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ModifyProduct extends StatefulWidget {
  const ModifyProduct({super.key});

  @override
  State<ModifyProduct> createState() => _ModifyProductState();
}

class _ModifyProductState extends State<ModifyProduct> {
  late String productId = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;
  bool _isUploading = false;

  // NEW : upload to cloudinary
  void _pickImageAndCloudinaryUpload() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _isUploading = true;
      });
      
      String? res = await uploadToCloudinary(image);
      setState(() {
        _isUploading = false;
        if (res != null) {
          imageController.text = res;
          print("set image url ${res} : ${imageController.text}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text("Image uploaded successfully!"),
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
      });
    }
  }

  // OLD : upload to firebase
  // function to pick image using image picker
  // Future<void> pickImage() async {
  //   image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     String? res = await StorageService().uploadImage(image!.path, context);
  //     setState(() {
  //       if (res != null) {
  //         imageController.text = res;
  //         print("set image url ${res} : ${imageController.text}");
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text("Image uploaded successfully")));
  //       }
  //     });
  //   }
  // }

  // set the data from arguments
  setData(ProductsModel data) {
    productId = data.id;
    nameController.text = data.name;
    oldPriceController.text = data.old_price.toString();
    newPriceController.text = data.new_price.toString();
    quantityController.text = data.maxQuantity.toString();
    categoryController.text = data.category;
    descController.text = data.description;
    imageController.text = data.image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is ProductsModel) {
      setData(arguments);
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(productId.isNotEmpty ? "Edit Product" : "Add New Product"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.inventory_2,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productId.isNotEmpty ? "Edit Product" : "Add New Product",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                productId.isNotEmpty 
                                    ? "Update product information and details"
                                    : "Create a new product for your store",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Basic Information Section
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Basic Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    ModernTextField(
                      controller: nameController,
                      label: "Product Name",
                      hint: "Enter product name",
                      prefixIcon: Icons.shopping_bag_outlined,
                      validator: (v) => v!.isEmpty ? "Product name cannot be empty" : null,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    ModernTextField(
                      controller: descController,
                      label: "Description",
                      hint: "Describe your product",
                      prefixIcon: Icons.description_outlined,
                      maxLines: 4,
                      validator: (v) => v!.isEmpty ? "Description cannot be empty" : null,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    ModernTextField(
                      controller: categoryController,
                      label: "Category",
                      hint: "Select category",
                      prefixIcon: Icons.category_outlined,
                      readOnly: true,
                      validator: (v) => v!.isEmpty ? "Category cannot be empty" : null,
                      onTap: () {
                        _showCategorySelector();
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Pricing & Inventory Section
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pricing & Inventory",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ModernTextField(
                            controller: oldPriceController,
                            label: "Original Price",
                            hint: "₹0",
                            prefixIcon: Icons.currency_rupee,
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? "Original price cannot be empty" : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ModernTextField(
                            controller: newPriceController,
                            label: "Selling Price",
                            hint: "₹0",
                            prefixIcon: Icons.sell_outlined,
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? "Selling price cannot be empty" : null,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    ModernTextField(
                      controller: quantityController,
                      label: "Stock Quantity",
                      hint: "Available quantity",
                      prefixIcon: Icons.inventory_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? "Quantity cannot be empty" : null,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Image Section
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Product Image",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Image Preview
                    if (image != null || imageController.text.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 200,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: image != null
                              ? Image.file(
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  imageController.text,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[100],
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    
                    // Upload Button
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFF6366F1).withOpacity(0.05),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _isUploading ? null : _pickImageAndCloudinaryUpload,
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isUploading)
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                                )
                              else
                                const Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 32,
                                  color: Color(0xFF6366F1),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                _isUploading ? "Uploading..." : "Tap to upload image",
                                style: const TextStyle(
                                  color: Color(0xFF6366F1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "JPG, PNG up to 10MB",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    ModernTextField(
                      controller: imageController,
                      label: "Image URL",
                      hint: "Or paste image URL directly",
                      prefixIcon: Icons.link,
                      validator: (v) => v!.isEmpty ? "Image URL cannot be empty" : null,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Action Button
              ModernButton(
                text: productId.isNotEmpty ? "Update Product" : "Add Product",
                width: double.infinity,
                height: 56,
                onPressed: _handleSubmit,
                icon: productId.isNotEmpty ? Icons.update : Icons.add,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    "Select Category",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<AdminProvider>(
                builder: (context, value, child) => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: value.categories.length,
                  itemBuilder: (context, index) {
                    final category = value.categories[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () {
                          categoryController.text = category["name"];
                          setState(() {});
                          Navigator.pop(context);
                        },
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.category_outlined,
                            color: Color(0xFF6366F1),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          category["name"].toString().toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        "name": nameController.text,
        "old_price": int.parse(oldPriceController.text),
        "new_price": int.parse(newPriceController.text),
        "quantity": int.parse(quantityController.text),
        "category": categoryController.text,
        "desc": descController.text,
        "image": imageController.text,
      };

      if (productId.isNotEmpty) {
        DbService().updateProduct(
          docId: productId,
          data: data,
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text("Product updated successfully!"),
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
        DbService().createProduct(data: data);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text("Product added successfully!"),
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