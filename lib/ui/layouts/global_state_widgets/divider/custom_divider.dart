import 'package:flutter/material.dart';

import '../../../../core/constant_values/global_values.dart';

class ColumnDivider extends StatelessWidget {
  final double? space;
  final Color? color;
  const ColumnDivider({super.key, this.space, this.color});
  @override
  Widget build(BuildContext context) {
    if (color != null) return Container(height: space ?? spaceNear, color: color);
    return SizedBox(height: space ?? spaceNear);
  }
}

class RowDivider extends StatelessWidget {
  final double? space;
  final Color? color;
  const RowDivider({super.key, this.space, this.color});
  @override
  Widget build(BuildContext context) {
    if (color != null) return Container(width: space ?? spaceNear, color: color);
    return SizedBox(width: space ?? spaceNear);
  }
}
