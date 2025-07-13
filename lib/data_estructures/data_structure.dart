abstract class DataStructure {
  String get id;
  String get name;
  void add(int? value);
  void remove();
  void clearAll();
  List<dynamic> get items;
}
