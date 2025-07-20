import 'package:estruturas_de_dados/enums/tree_node_position.dart';
import 'package:estruturas_de_dados/models/tree_node_model.dart';

abstract class DataStructure {
  String get id;
  String get name;
  void add(int? value);
  void addNode(int? value, {TreeNode? parent, required TreeNodePosition position});
  void remove();
  void clearAll();
  List<dynamic> get items;
}
