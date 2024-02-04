import 'package:flutter/cupertino.dart';

class Item with ChangeNotifier {
  String itemKey;
  String itemDesc;
  double price;
  bool taxed;

  // create item
  Item(this.itemKey, this.itemDesc, this.price, this.taxed);

  // update item
  updateItem(String? updatedKey, String? updatedDesc, double? updatedPrice,
      bool? updatedTaxed) {
    if (updatedKey != null && updatedKey.isNotEmpty && updatedKey != itemKey) {
      itemKey = updatedKey;
    }
    if (updatedDesc != null &&
        updatedDesc.isNotEmpty &&
        updatedDesc != itemDesc) itemDesc = updatedDesc;
    if (updatedPrice != null && updatedPrice != price) price = updatedPrice;
    if (updatedTaxed != null && updatedTaxed != taxed) taxed = updatedTaxed;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'itemKey': itemKey,
      'itemDesc': itemDesc,
      'price': price,
      'taxed': taxed
    };
  }
}
