class Item {
  String itemKey;
  String itemDesc;
  double price;
  bool taxed;

  // create item
  Item(this.itemKey, this.itemDesc, this.price, this.taxed);

  // update item
  updateItem(String updatedKey, updatedDesc, updatedPrice, updatedTaxed) {
    if (updatedKey != itemKey) itemKey = updatedKey;
    if (updatedDesc != updatedDesc) itemDesc = updatedDesc;
    if (updatedPrice != updatedPrice) price = updatedPrice;
    if (updatedTaxed != updatedTaxed) taxed = updatedTaxed;
  }
}