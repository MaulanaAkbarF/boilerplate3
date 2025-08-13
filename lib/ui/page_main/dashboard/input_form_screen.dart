import 'package:boilerplate_3_firebaseconnect/core/models/_global_widget_model/geocoding.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/selected_item/checkbox.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/selected_item/dropdown.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/selected_item/list_radio_button.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/textfield/textfield_num_input/regular_pinput.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/textfield/textfield_suggestion/type_ahead_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/divider/custom_divider.dart';
import '../../layouts/global_state_widgets/selected_item/expansion_tile.dart';
import '../../layouts/global_state_widgets/textfield/textfield_form/animate_form.dart';
import '../../layouts/global_state_widgets/textfield/textfield_form/regular_form.dart';
import '../../layouts/global_state_widgets/textfield/textfield_hidden/animate_password.dart';
import '../../layouts/global_state_widgets/textfield/textfield_hidden/regular_password.dart';
import '../../layouts/styleconfig/themecolors.dart';

class InputFormScreen extends StatelessWidget {
  InputFormScreen({super.key});

  final TextEditingController tecInput1 = TextEditingController(text: '');
  final TextEditingController tecInput2 = TextEditingController(text: '');
  final TextEditingController tecInput3 = TextEditingController(text: '');
  final TextEditingController tecInput4 = TextEditingController(text: '');
  final TextEditingController tecInput5 = TextEditingController(text: '');
  final TextEditingController tecInput6 = TextEditingController(text: '');

  final List<Expansion> expansionModel = [
    Expansion(text: 'Data 1'),
    Expansion(text: 'Data 2'),
    Expansion(text: 'Data 3'),
    Expansion(text: 'Data 4'),
    Expansion(text: 'Data 5'),
  ];
  
  final List<String> stringModel = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];

  final List<GeocodingModel> geoModel = [
    GeocodingModel(latitude: 100, longitude: 200),
    GeocodingModel(latitude: 150, longitude: 260),
    GeocodingModel(latitude: 250, longitude: 390),
    GeocodingModel(latitude: 375, longitude: 520),
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
      backgroundColor: ThemeColors.greyVeryLowContrast(context),
      appBar: appBarWidget(context: context, title: 'InputForm', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      padding: EdgeInsets.all(paddingMid),
      backgroundColor: ThemeColors.greyVeryLowContrast(context),
      appBar: appBarWidget(context: context, title: 'InputForm', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      children: [
        RegularTextField(
          labelText: 'Regular Form',
          hintText: 'Ketik sesuatu',
          controller: tecInput1,
          minInput: 5,
          shadowColor: ThemeColors.surface(context),
          isRequired: false,
        ),
        ColumnDivider(space: spaceMid),
        RegularPasswordField(
          labelText: 'Regular Password Form',
          hintText: 'Ketik sesuatu',
          controller: tecInput2,
          minInput: 5,
          shadowColor: ThemeColors.surface(context),
          isRequired: false,
        ),
        ColumnDivider(space: spaceFar),
        AnimateTextField(
          labelText: 'Animate Form',
          controller: tecInput3,
          minInput: 5,
          shadowColor: ThemeColors.surface(context),
          borderAnimationColor: ThemeColors.blueHighContrast(context),
          isRequired: false,
        ),
        ColumnDivider(space: spaceFar),
        AnimatePasswordField(
          labelText: 'Animate Password Form',
          controller: tecInput4,
          minInput: 5,
          shadowColor: ThemeColors.surface(context),
          borderAnimationColor: ThemeColors.blueHighContrast(context),
          isRequired: false,
        ),
        ColumnDivider(space: spaceFar),
        RegularPinput(
            controller: tecInput5,
            pinLength: 5,
            isRequired: false,
            onComplete: (value) => print(value)
        ),
        ColumnDivider(space: spaceFar),
        CustomDropdown(
          expansionList: expansionModel,
          onSelected: (value) => print(value)
        ),
        ColumnDivider(space: spaceFar),
        AnimateTypeAhead(
          data: geoModel,
          labelText: 'Cari Latitude dan Longitude',
          suggestionCallback: (item) => item.latitude.toString(),
          onSelected: (value) => print(value)
        ),
        ColumnDivider(space: spaceFar * 5),
        CustomExpansionTile(
            expansionList: expansionModel,
            onSelected: (value) => print(value)
        ),
        ColumnDivider(space: spaceFar),
        Row(
          children: [
            Expanded(
              child: CustomCheckbox(
                value: stringModel[0],
                isRequired: false,
                onChanged: (value) => print(value)
              ),
            ),
            Expanded(
              child: CustomCheckbox(
                value: stringModel[1],
                isRequired: false,
                onChanged: (value) => print(value)
              ),
            ),
          ],
        ),
        ColumnDivider(space: spaceFar),
        CustomRadioButtonGroup(listRadioItem: stringModel, radioButtonLayout: RadioButtonLayout.vertical, onSelected: (value) => print(value))
      ],
    );
  }
}