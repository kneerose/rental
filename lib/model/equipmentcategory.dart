class Equipmentcategory {
int id;
String equipment;
String type;
int priceperday;
Equipmentcategory({
  required this.id,
  required this.equipment,
  required this.type,
  required this.priceperday
});
factory Equipmentcategory.tojson(Map<String,dynamic> tojson)
{
  return Equipmentcategory(
    id: int.parse(tojson["id"]),
    equipment: tojson["equipment"],
    type: tojson["type"],
    priceperday: int.parse(tojson["price_per_day"]),
  );
}
Map<String,dynamic> tomap()=> {
  "id":id,
  "equipment":equipment,
  "type":type,
  "price_per_day":priceperday,
};
}