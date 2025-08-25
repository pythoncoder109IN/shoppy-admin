import 'dart:io';

import 'package:ecommerce_admin_app/containers/additional_confirm.dart';
import 'package:ecommerce_admin_app/controllers/cloudinary_service.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/controllers/storage_service.dart';
import 'package:ecommerce_admin_app/models/categories_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
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
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<CategoriesModel> categories = CategoriesModel.fromJsonList(
            value.categories,
          );

          if (value.categories.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: Color(0xFF94A3B8),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No Categories Found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Add your first category to get started",
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: value.categories.length,
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
                  leading: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFF1F5F9),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        categories[index].image.isEmpty
                            ? "https://demofree.sirv.com/nope-not-here.jpg"
                            : categories[index].image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.category_outlined,
                            color: Color(0xFF94A3B8),
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(
                    categories[index].name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Priority: ${categories[index].priority}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Color(0xFF64748B)),
                    onSelected: (value) {
                      if (value == 'edit') {
                        showDialog(
                          context: context,
                          builder: (context) => ModifyCategory(
                            isUpdating: true,
                            categoryId: categories[index].id,
                            priority: categories[index].priority,
                            image: categories[index].image,
                            name: categories[index].name,
                          ),
                        );
                      } else if (value == 'delete') {
                        showDialog(
                          context: context,
                          builder: (context) => AdditionalConfirm(
                            contentText: "Are you sure you want to delete this category?",
                            onYes: () {
                              DbService().deleteCategories(
                                docId: categories[index].id,
                              );
                              Navigator.pop(context);
                            },
                            onNo: () {
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
                            Icon(Icons.delete_outline, size: 20, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                ModifyCategory(isUpdating: false, categoryId: "", priority: 0),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ModifyCategory extends StatefulWidget {
  final bool isUpdating;
  final String? name;
  final String categoryId;
  final String? image;
  final int priority;
  const ModifyCategory({
    super.key,
    required this.isUpdating,
    this.name,
    required this.categoryId,
    this.image,
    required this.priority,
  });

  @override
  State<ModifyCategory> createState() => _ModifyCategoryState();
}

class _ModifyCategoryState extends State<ModifyCategory> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdating && widget.name != null) {
      categoryController.text = widget.name!;
      imageController.text = widget.image!;
      priorityController.text = widget.priority.toString();
    }
    super.initState();
  }

  // NEW : upload to cloudinary
  void _pickImageAndCloudinaryUpload() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? res = await uploadToCloudinary(image);
      setState(() {
        if (res != null) {
          imageController.text = res;
          print("set image url ${res} : ${imageController.text}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image uploaded successfully")),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isUpdating ? "Update Category" : "Add Category"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("All will be converted to lowercase"),
              SizedBox(height: 10),
              TextFormField(
                controller: categoryController,
                validator: (v) => v!.isEmpty ? "This cant be empty." : null,
                decoration: InputDecoration(
                  hintText: "Category Name",
                  label: Text("Category Name"),
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              ),
              SizedBox(height: 10),
              Text("This will be used in ordering categories"),
              SizedBox(height: 10),
              TextFormField(
                controller: priorityController,
                validator: (v) => v!.isEmpty ? "This cant be empty." : null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Priority",
                  label: Text("Priority"),
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              ),
              SizedBox(height: 10),
              image == null
                  ? imageController.text.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.all(20),
                            height: 100,
                            width: double.infinity,
                            color: Colors.deepPurple.shade50,
                            child: Image.network(
                              imageController.text,
                              fit: BoxFit.contain,
                            ),
                          )
                        : SizedBox()
                  : Container(
                      margin: EdgeInsets.all(20),
                      height: 200,
                      width: double.infinity,
                      color: Colors.deepPurple.shade50,
                      child: Image.file(File(image!.path), fit: BoxFit.contain),
                    ),
              ElevatedButton(
                onPressed: () {
                  // OLD one for firebase storage upload
                  // pickImage();
                  // NEW for cloudinary Upload
                  _pickImageAndCloudinaryUpload();
                },
                child: Text("Pick Image"),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: imageController,
                validator: (v) => v!.isEmpty ? "This cant be empty." : null,
                decoration: InputDecoration(
                  hintText: "Image Link",
                  label: Text("Image Link"),
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              if (widget.isUpdating) {
                await DbService().updateCategories(
                  docId: widget.categoryId,
                  data: {
                    "name": categoryController.text.toLowerCase(),
                    "image": imageController.text,
                    "priority": int.parse(priorityController.text),
                  },
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Category Updated")));
              } else {
                await DbService().createCategories(
                  data: {
                    "name": categoryController.text.toLowerCase(),
                    "image": imageController.text,
                    "priority": int.parse(priorityController.text),
                  },
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Category Added")));
              }
              Navigator.pop(context);
            }
          },
          child: Text(widget.isUpdating ? "Update" : "Add"),
        ),
      ],
    );
  }
}
