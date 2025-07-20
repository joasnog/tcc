class TreeNode {
  int value;
  TreeNode? left;
  TreeNode? right;
  TreeNode? parent;

  bool get isRoot => parent == null;

  TreeNode({required this.value, this.left, this.right, this.parent});
}