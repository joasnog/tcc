import 'package:estruturas_de_dados/data_estructures/data_structure.dart';

final class QueueStructure implements DataStructure {
  @override
  String get id => 'queue';

  final List<int> _dados = [];

  @override
  void add(int? value) {
    _dados.add(value ?? _dados.length + 1);
  }

  @override
  void remove() {
    if (_dados.isEmpty) {
      throw Exception('A fila está vazia.');
    }

    _dados.removeAt(0);
  }

  @override
  List get items => _dados;
  
  @override
  String get name => 'Fila';
  
  @override
  void clearAll() {
    _dados.clear();
  }

}