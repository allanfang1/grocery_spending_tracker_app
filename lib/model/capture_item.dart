import 'package:flutter/cupertino.dart';

class Item with ChangeNotifier {
  String itemKey;
  String itemDesc;
  double price;
  bool taxed;
  bool deleted = false;

  // create item
  Item(this.itemKey, this.itemDesc, this.price, this.taxed);

  // update item
  updateItem(String? updatedKey, String? updatedDesc, double? updatedPrice,
      bool? updatedTaxed, bool? updateDeleted) {
    if (updatedKey != null && updatedKey.isNotEmpty && updatedKey != itemKey) {
      itemKey = updatedKey;
    }
    if (updatedDesc != null &&
        updatedDesc.isNotEmpty &&
        updatedDesc != itemDesc) itemDesc = updatedDesc;
    if (updatedPrice != null && updatedPrice != price) price = updatedPrice;
    if (updatedTaxed != null && updatedTaxed != taxed) taxed = updatedTaxed;
    if (updateDeleted != null && updateDeleted != deleted) deleted = updateDeleted;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'item_key': itemKey,
      'item_desc': itemDesc,
      'price': price,
      'taxed': taxed
    };
  }
}
