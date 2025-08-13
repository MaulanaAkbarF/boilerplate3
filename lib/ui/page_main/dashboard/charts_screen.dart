import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/models/_global_widget_model/sf_chart.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/divider/custom_divider.dart';
import '../../layouts/global_state_widgets/infographics/cartesian_chart/area_chart.dart';
import '../../layouts/global_state_widgets/infographics/cartesian_chart/bar_chart.dart';
import '../../layouts/global_state_widgets/infographics/cartesian_chart/line_chart.dart';
import '../../layouts/global_state_widgets/infographics/circular_chart/pie_chart.dart';
import '../../layouts/global_state_widgets/infographics/circular_chart/radial_chart.dart';

class ChartsScreen extends StatelessWidget {
  ChartsScreen({super.key});

  final List<SfBarChart> datasA = [
    SfBarChart(x: 'judul1', y: 100),
    SfBarChart(x: 'judul2', y: 200),
    SfBarChart(x: 'judul3', y: 300),
    SfBarChart(x: 'judul4', y: 400),
    SfBarChart(x: 'judul5', y: 500),
  ];

  final List<SfLineChart> datasB = [
    SfLineChart(xDate: DateTime.now(), xString: 'Senin', y: 863),
    SfLineChart(xDate: DateTime.now().subtract(Duration(days: 365)), xString: 'Selasa', y: 214),
    SfLineChart(xDate: DateTime.now().subtract(Duration(days: 365 * 2)), xString: 'Rabu', y: 298),
    SfLineChart(xDate: DateTime.now().subtract(Duration(days: 365 * 3)), xString: 'Kamiz', y: 463),
    SfLineChart(xDate: DateTime.now().subtract(Duration(days: 365 * 4)), xString: 'Jumat', y: 500),
  ];

  final List<SfCircularsChart> datasC = [
    SfCircularsChart(x: 'judul1', y: 50),
    SfCircularsChart(x: 'judul2', y: 120),
    SfCircularsChart(x: 'judul3', y: 350),
    SfCircularsChart(x: 'judul4', y: 440),
    SfCircularsChart(x: 'judul5', y: 480),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceSettingProvider>(
      builder: (context, provider, child) {
        if (provider.isTabletMode.condition) {
          if (getMediaQueryWidth(context) > provider.tabletModePixel.value) return _setTabletLayout(context);
          if (getMediaQueryWidth(context) < provider.tabletModePixel.value) return _setPhoneLayout(context);
        }
        return _setPhoneLayout(context);
      }
    );
  }

  Widget _setPhoneLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      padding: EdgeInsets.all(paddingMid),
      appBar: appBarWidget(context: context, title: 'Charts', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      padding: EdgeInsets.all(paddingMid),
      appBar: appBarWidget(context: context, title: 'Charts', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      children: [
        CustomSfAreaChart(title: 'Area Chart', data: datasB),
        ColumnDivider(),
        CustomSfBarChart(title: 'Bar Chart', data: datasA),
        ColumnDivider(),
        CustomSfLineChart(title: 'Line Chart', data: datasB),
        ColumnDivider(),
        CustomSfRadialChart(title: 'Radial Charts', data: datasC),
        ColumnDivider(),
        CustomSfPieChart(title: 'Pie Charts', data: datasC),
      ],
    );
  }
}