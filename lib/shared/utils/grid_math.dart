/// Width of one column when [total] is split into [columns] equal columns
/// separated by [spacing].
///
/// Never negative. A parent can lay a grid out at zero width for a frame
/// (hot restart, a collapsing transition, a deferred mount), and a negative
/// `SizedBox` width is an assertion failure rather than an empty layout.
double columnWidth(double total, int columns, double spacing) {
  if (!total.isFinite || columns <= 0) return 0;
  final width = (total - spacing * (columns - 1)) / columns;
  return width > 0 ? width : 0;
}
