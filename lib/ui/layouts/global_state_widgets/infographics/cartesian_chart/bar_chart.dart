import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/constant_values/global_values.dart';
import '../../../../../core/models/_global_widget_model/sf_chart.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';

/// Dapat langsung ditambahkan pada children di widget Listview/Column
/// Info selengkapnya kunjungi : https://help.syncfusion.com/flutter/cartesian-charts/chart-types/bar-chart
class CustomSfBarChart extends StatelessWidget {
  final String title;
  final List<SfBarChart> data;
  final double? maximumlength;
  final double? interval;
  final bool invertAxisData;
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

  const CustomSfBarChart({
    super.key,
    required this.title,
    required this.data,
    this.maximumlength,
    this.interval,
    this.invertAxisData = false,
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
    final double maxY = maximumlength ?? data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final double chartInterval = interval ?? (maxY / 8);
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
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(title: xAxisTitle == null
            ? AxisTitle() : AxisTitle(text: xAxisTitle, textStyle: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
        primaryYAxis: NumericAxis(minimum: 0, maximum: maxY, interval: interval ?? chartInterval, title: xAxisTitle == null
            ? AxisTitle() : AxisTitle(text: xAxisTitle, textStyle: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
        tooltipBehavior: TooltipBehavior(enable: true),
        title: ChartTitle(text: title,  textStyle: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
        series: [
          if (invertAxisData)
            ColumnSeries<SfBarChart, String>(
              dataSource: data,
              xValueMapper: (SfBarChart data, _) => data.x,
              yValueMapper: (SfBarChart data, _) => data.y,
              name: title,
              color: ThemeColors.blue(context),
            )
          else
            BarSeries<SfBarChart, String>(
              dataSource: data,
              xValueMapper: (SfBarChart data, _) => data.x,
              yValueMapper: (SfBarChart data, _) => data.y,
              name: title,
              color: ThemeColors.blue(context),
            ),
        ]
      ),
    );
  }
}
