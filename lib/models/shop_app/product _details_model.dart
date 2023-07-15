class ProductDetails
{
dynamic status;
Data? data;

ProductDetails.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    data =  Data.fromJson(json['data']);
  }
}

class Data {
  dynamic id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  String? description;
  dynamic inFavorites;
  dynamic inCart;

  Data.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }

}
