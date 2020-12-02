import 'package:flutter/cupertino.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AllProvider extends ChangeNotifier {
  String _itemName = '';
  int _count = 0;

  List<Asset> _sellerImage = [];

  String get itemName => _itemName;
  int get count => _count;
  List<Asset> get sellerImage => _sellerImage;

  void updateItemName(String code) {
    _itemName = code;
    notifyListeners();
  }

  void updateCount(int code) {
    _count = code;
    notifyListeners();
  }

  void updateSellerImage(List<Asset> img) {
    _sellerImage = img;
    notifyListeners();
  }

  void clearAll() {
    _itemName = '';
    _sellerImage = [];
    notifyListeners();
  }
}
