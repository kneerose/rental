class Addlist {
  final int? id;
 final  String  title;
  final  String filepath;
  final String type;
 final  String description;
 final  String quantity;
 final String location;
 final String price;
  Addlist({
     this.id,
    required this.title,
    required this.filepath,
    required this.type,
    required this.description,
    required this.quantity,
    required this.location,
    required this.price,
  });
  factory Addlist.tojson(Map<String,dynamic> map){
    return Addlist(
      id: int.parse(map["id"]),
      description: map["description"],
      filepath: map["image"],
      type: map["type"],
      title: map["title"],
      quantity: map["quantity"],
      location: map["location"],
      price: map["price_per_day"],
    );
  }
   Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "image": filepath,
        "type": type,
        "description": description,
        "quantity": quantity,
        "price_per_day":price
      };
}