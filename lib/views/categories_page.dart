import 'dart:io';

import 'package:ecommerce_admin_app/containers/additional_confirm.dart';
import 'package:ecommerce_admin_app/controllers/cloudinary_service.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/categories_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:ecommerce_admin_app/widgets/modern_button.dart';
import 'package:ecommerce_admin_app/widgets/modern_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Categories"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                _showAddCategoryModal(context);
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
                  Color(0xFF8B5CF6),
                  Color(0xFF06B6D4),
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
                    Icons.category,
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
                        "Manage Categories",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Organize your products with categories",
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
            child: Consumer<AdminProvider>(
              builder: (context, value, child) {
                List<CategoriesModel> categories = CategoriesModel.fromJsonList(
                  value.categories,
                );

                if (categories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.category_outlined,
                            size: 48,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "No Categories Yet",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Create your first category to organize products",
                          style: TextStyle(
                            color: Color(0xFF64748B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showAddCategoryModal(context);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Create Category"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
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
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

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
                        child: Row(
                          children: [
                            // Category Image
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF8B5CF6).withOpacity(0.1),
                                    const Color(0xFF06B6D4).withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: category.image.isEmpty
                                    ? const Icon(
                                        Icons.category_outlined,
                                        color: Color(0xFF8B5CF6),
                                        size: 32,
                                      )
                                    : Image.network(
                                        category.image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.category_outlined,
                                            color: Color(0xFF8B5CF6),
                                            size: 32,
                                          );
                                        },
                                      ),
                              ),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            // Category Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.name.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E293B),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.priority_high,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Priority ${category.priority}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
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
                            
                            // Actions Menu
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Color(0xFF64748B),
                              ),
                              onSelected: (option) {
                                if (option == 'edit') {
                                  _showAddCategoryModal(context, category: category);
                                } else if (option == 'delete') {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AdditionalConfirm(
                                      contentText:
                                          "Are you sure you want to delete this category?",
                                      onYes: () async {
                                        await DbService().deleteCategories(
                                          docId: category.id,
                                        );
                                        Navigator.pop(context);
                                      },
                                      onNo: () => Navigator.pop(context),
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
                                      Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 12),
                                      Text('Delete', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddCategoryModal(context);
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Category"),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showAddCategoryModal(BuildContext context, {CategoriesModel? category}) {
    showDialog(
      context: context,
      builder: (context) => AddCategoryModal(category: category),
    );
  }
}

class AddCategoryModal extends StatefulWidget {
  final CategoriesModel? category;
  
  const AddCategoryModal({super.key, this.category});

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  
  late TextEditingController nameController;
  late TextEditingController imageController;
  late TextEditingController priorityController;
  
  XFile? selectedImage;
  bool _isUploading = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category?.name ?? '');
    imageController = TextEditingController(text: widget.category?.image ?? '');
    priorityController = TextEditingController(
      text: widget.category?.priority.toString() ?? '1'
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    imageController.dispose();
    priorityController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    selectedImage = await picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _isUploading = true;
      });
      
      String? imageUrl = await uploadToCloudinary(selectedImage);
      
      setState(() {
        _isUploading = false;
        if (imageUrl != null) {
          imageController.text = imageUrl;
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

  Future<void> _handleSubmit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final data = {
          "name": nameController.text.toLowerCase().trim(),
          "image": imageController.text.trim(),
          "priority": int.parse(priorityController.text),
        };

        if (widget.category != null) {
          // Update existing category
          await DbService().updateCategories(
            docId: widget.category!.id,
            data: data,
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text("Category updated successfully!"),
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
        } else {
          // Create new category
          await DbService().createCategories(data: data);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text("Category created successfully!"),
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

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 12),
                  Text("Error: ${e.toString()}"),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
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
                    colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
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
                        Icons.category,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isEditing ? "Edit Category" : "Create Category",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isEditing 
                          ? "Update category information"
                          : "Add a new product category",
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
                      // Info Banner
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
                                "Category names will be automatically converted to lowercase",
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
                        controller: nameController,
                        label: "Category Name",
                        hint: "Enter category name (e.g., Electronics)",
                        prefixIcon: Icons.category_outlined,
                        validator: (v) => v!.isEmpty ? "Category name cannot be empty" : null,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      ModernTextField(
                        controller: priorityController,
                        label: "Priority",
                        hint: "Enter priority number (higher = shown first)",
                        prefixIcon: Icons.priority_high,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v!.isEmpty) return "Priority cannot be empty";
                          if (int.tryParse(v) == null) return "Please enter a valid number";
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Image Section
                      const Text(
                        "Category Image",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Image Preview
                      if (selectedImage != null || imageController.text.isNotEmpty)
                        Container(
                          width: double.infinity,
                          height: 150,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: selectedImage != null
                                ? Image.file(
                                    File(selectedImage!.path),
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
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF8B5CF6).withOpacity(0.3),
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF8B5CF6).withOpacity(0.05),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isUploading ? null : _pickAndUploadImage,
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isUploading)
                                  const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                                  )
                                else
                                  const Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 28,
                                    color: Color(0xFF8B5CF6),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  _isUploading ? "Uploading..." : "Tap to upload image",
                                  style: const TextStyle(
                                    color: Color(0xFF8B5CF6),
                                    fontWeight: FontWeight.w500,
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
                      
                      const SizedBox(height: 24),
                      
                      // Action Buttons
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
                              text: isEditing ? "Update Category" : "Create Category",
                              onPressed: _handleSubmit,
                              isLoading: _isSubmitting,
                              backgroundColor: const Color(0xFF8B5CF6),
                              icon: isEditing ? Icons.update : Icons.add,
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
}