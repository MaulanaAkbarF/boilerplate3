import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/constant_values/global_values.dart';
import '../../../../../core/models/_global_widget_model/sf_chart.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';

/// Dapat langsung ditambahkan pada children di widget Listview/Column
/// Info selengkapnya kunjungi : https://help.syncfusion.com/flutter/circular-charts/chart-types/pie-chart
class CustomSfPieChart extends StatelessWidget {
  final String title;
  final List<SfCircularsChart> data;
  final String? radiusChart;
  final String? xAxisTitle;
  final String? yAxisTitle;
  final Color? containerColor;
  final double? containerOpacity;
  final double? containerRadius;
  final BorderRadius? borderRadius;
  final double? borderSize;
  final double? borderOpacity;
  final Color? borderColor;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double? shadowBlurRadius;

  const CustomSfPieChart({
    super.key,
    required this.title,
    required this.data,
    this.radiusChart,
    this.xAxisTitle,
    this.yAxisTitle,
    this.containerColor,
    this.containerOpacity,
    this.containerRadius,
    this.borderRadius,
    this.borderSize,
    this.borderOpacity,
    this.borderColor,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(paddingNear),
      decoration: BoxDecoration(
        color: containerColor?.withValues(alpha: containerOpacity ?? 1.0) ?? ThemeColors.onSurface(context),
        borderRadius: borderRadius ?? BorderRadius.circular(containerRadius ?? radiusSquare),
        border: borderColor != null ? Border.all(
          color: borderColor?.withValues(alpha: borderOpacity ?? 1.0) ?? Colors.transparent,
          width: borderSize ?? 1,
        ) : null,
        boxShadow: shadowColor == null ? [] : [
          BoxShadow(
            color: shadowColor!.withValues(alpha: .1),
            offset: shadowOffset ?? const Offset(0, 1.5),
            blurRadius: shadowBlurRadius ?? shadowBlurLow,
          ),
        ],
      ),
      child: SfCircularChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          title: ChartTitle(text: title,  textStyle: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
          series: [
            PieSeries<SfCircularsChart, String>(
              dataSource: data,
              pointColorMapper:(SfCircularsChart data,  _) => data.color,
              xValueMapper: (SfCircularsChart data, _) => data.x,
              yValueMapper: (SfCircularsChart data, _) => data.y,
              name: title,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              radius: radiusChart ?? '100%',
            )
          ]
      ),
    );
  }
}
