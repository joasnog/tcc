enum StructureType { stack, queue, list, tree }

class DataStructure {
  final StructureType type;
  final List<int> values;

  DataStructure({required this.type, this.values = const []});
}
