import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/constant_values/global_values.dart';
import '../../../../../core/models/_global_widget_model/sf_chart.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';

/// Dapat langsung ditambahkan pada children di widget Listview/Column
/// Info selengkapnya kunjungi : https://help.syncfusion.com/flutter/cartesian-charts/chart-types/line-chart
class CustomSfLineChart extends StatelessWidget {
  final String title;
  final List<SfLineChart> data;
  final bool useXAxisAsDateTime;
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

  const CustomSfLineChart({
    super.key,
    required this.title,
    required this.data,
    this.useXAxisAsDateTime = false,
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
      child: SfCartesianChart(
        primaryXAxis: useXAxisAsDateTime ? DateTimeAxis() : CategoryAxis(title: xAxisTitle == null
            ? AxisTitle() : AxisTitle(text: xAxisTitle, textStyle: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
        primaryYAxis: useXAxisAsDateTime ? DateTimeAxis() : CategoryAxis(title: yAxisTitle == null
            ? AxisTitle() : AxisTitle(text: yAxisTitle, textStyle: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
        tooltipBehavior: TooltipBehavior(enable: true),
        title: ChartTitle(text: title,  textStyle: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
        series: [
          if (useXAxisAsDateTime)
            LineSeries<SfLineChart, DateTime>(
              dataSource: data,
              xValueMapper: (SfLineChart data, _) => data.xDate ?? DateTime.now(),
              yValueMapper: (SfLineChart data, _) => data.y,
              name: title,
              color: ThemeColors.blue(context),
            )
          else
            LineSeries<SfLineChart, String>(
              dataSource: data,
              xValueMapper: (SfLineChart data, _) => data.xString ?? 'nan',
              yValueMapper: (SfLineChart data, _) => data.y,
              name: title,
              color: ThemeColors.blue(context),
            )
        ]
      ),
    );
  }
}
