import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  // CATEGORIES
  Stream<QuerySnapshot> readCategories() {
    return FirebaseFirestore.instance
        .collection("shop_categories")
        .orderBy("priority", descending: true)
        .snapshots();
  }

  Future createCategories({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("shop_categories").add(data);
  }

  Future updateCategories({
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFirestore.instance
        .collection("shop_categories")
        .doc(docId)
        .update(data);
  }

  Future deleteCategories({required String docId}) async {
    await FirebaseFirestore.instance
        .collection("shop_categories")
        .doc(docId)
        .delete();
  }

  // PRODUCTS
  Stream<QuerySnapshot> readProducts() {
    return FirebaseFirestore.instance
        .collection("shop_products")
        .orderBy("category", descending: true)
        .snapshots();
  }

  Future createProduct({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("shop_products").add(data);
  }

  Future updateProduct({
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFirestore.instance
        .collection("shop_products")
        .doc(docId)
        .update(data);
  }

  Future deleteProduct({required String docId}) async {
    await FirebaseFirestore.instance
        .collection("shop_products")
        .doc(docId)
        .delete();
  }

  // PROMOS & BANNERS
  Stream<QuerySnapshot> readPromos(bool isPromo) {
    print("reading $isPromo");
    return FirebaseFirestore.instance
        .collection(isPromo ? "shop_promos" : "shop_banners")
        .snapshots();
  }

  Future createPromos({
    required Map<String, dynamic> data,
    required bool isPromo,
  }) async {
    await FirebaseFirestore.instance
        .collection(isPromo ? "shop_promos" : "shop_banners")
        .add(data);
  }

  Future updatePromos({
    required Map<String, dynamic> data,
    required bool isPromo,
    required String id,
  }) async {
    await FirebaseFirestore.instance
        .collection(isPromo ? "shop_promos" : "shop_banners")
        .doc(id)
        .update(data);
  }

  Future deletePromos({required bool isPromo, required String id}) async {
    await FirebaseFirestore.instance
        .collection(isPromo ? "shop_promos" : "shop_banners")
        .doc(id)
        .delete();
  }

  // DISCOUNT AND COUPON CODE
  Stream<QuerySnapshot> readCouponCode() {
    return FirebaseFirestore.instance.collection("shop_coupons").snapshots();
  }

  Future createCouponCode({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("shop_coupons").add(data);
  }

  Future updateCouponCode({
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFirestore.instance
        .collection("shop_coupons")
        .doc(docId)
        .update(data);
  }

  Future deleteCouponCode({required String docId}) async {
    await FirebaseFirestore.instance
        .collection("shop_coupons")
        .doc(docId)
        .delete();
  }

  // ORDERS
  Stream<QuerySnapshot> readOrders() {
    return FirebaseFirestore.instance
        .collection("shop_orders")
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  Future updateOrderStatus({
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFirestore.instance
        .collection("shop_orders")
        .doc(docId)
        .update(data);
  }
}
