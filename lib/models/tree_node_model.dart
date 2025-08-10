class TreeNode {
  int value;
  TreeNode? left;
  TreeNode? right;
  TreeNode? parent;

  bool get isRoot => parent == null;

  TreeNode({required this.value, this.left, this.right, this.parent});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeNode && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}