class Addlist {
  final int id;
  final int ownerid;
  final int categoryid;
 final  String  brand;
  final  String filepath;
 final  String description;
 final  String quantity;
 final String location;
 final String contactnumber;
  Addlist({
     required this.id,
     required this.ownerid,
     required this.categoryid,
    required this.brand,
    required this.filepath,
    required this.description,
    required this.quantity,
    required this.location,
    required this.contactnumber,
  });
  factory Addlist.tojson(Map<String,dynamic> map){
    return Addlist(
      id: int.parse(map["id"]),
      ownerid: int.parse(map["owner_id"]),
      categoryid: int.parse(map["category_id"]),
       brand: map["brand"],
        quantity: map["available_quantity"],
      description: map["Description"],
        location: map["location"],
      filepath: map["image"],
      contactnumber: map["contactnumber"]
    
      
    );
  }
   Map<String, dynamic> toMap() => {
        "id": id,
        "owner_id":ownerid,
        "category_id":categoryid,
        "brand": brand,
        "image": filepath,
        "description": description,
        "quantity": quantity,
        "location":location,
        "contactnumber":contactnumber,
      };
}