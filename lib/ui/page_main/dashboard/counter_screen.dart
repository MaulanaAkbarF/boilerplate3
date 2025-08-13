import 'package:boilerplate_3_firebaseconnect/core/state_management/riverpod/counter_riverpod.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/divider/custom_divider.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/styleconfig/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterRiverpodRef = ref.watch(counterRiverpod);

    return Scaffold(
      body: ListView(
        children: [
          cText(context, counterRiverpodRef.counter.toString()),
          ColumnDivider(),
          AnimateProgressButton(onTap: () => counterRiverpodRef.increase())
        ],
      ),
    );
  }
}
