import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/common.dart';
import '../../widgets/paisa_date_picker.dart';
import '../../widgets/paisa_time_picker.dart';
import '../bloc/expense_bloc.dart';

class ExpenseDatePickerWidget extends StatefulWidget {
  const ExpenseDatePickerWidget({
    super.key,
  });

  @override
  State<ExpenseDatePickerWidget> createState() =>
      _ExpenseDatePickerWidgetState();
}

class _ExpenseDatePickerWidgetState extends State<ExpenseDatePickerWidget> {
  late DateTime selectedDateTime =
      BlocProvider.of<ExpenseBloc>(context).selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () async {
                  final DateTime? dateTime = await paisaDatePicker(
                    context,
                    selectedDateTime: selectedDateTime,
                  );
                  if (dateTime != null) {
                    setState(() {
                      selectedDateTime = selectedDateTime.copyWith(
                        day: dateTime.day,
                        month: dateTime.month,
                        year: dateTime.year,
                      );
                      BlocProvider.of<ExpenseBloc>(context).selectedDate =
                          selectedDateTime;
                    });
                  }
                },
                leading: Icon(
                  Icons.today_rounded,
                  color: context.secondary,
                ),
                title: Text(selectedDateTime.formattedDate),
              ),
            ),
            Expanded(
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () async {
                  final TimeOfDay? timeOfDay = await paisaTimerPicker(context);
                  if (timeOfDay != null) {
                    setState(() {
                      selectedDateTime = selectedDateTime.copyWith(
                        hour: timeOfDay.hour,
                        minute: timeOfDay.minute,
                      );
                      BlocProvider.of<ExpenseBloc>(context).selectedDate =
                          selectedDateTime;
                    });
                  }
                },
                leading: Icon(
                  MdiIcons.clockOutline,
                  color: context.secondary,
                ),
                title: Text(selectedDateTime.formattedTime),
              ),
            ),
          ],
        );
      },
    );
  }
}
