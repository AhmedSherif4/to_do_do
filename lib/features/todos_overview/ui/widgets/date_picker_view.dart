import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_do/application/manager/theme_manager.dart';

import '../../controller/bloc/todos_overview_bloc.dart';

class TodosOverviewDatePicker extends StatefulWidget {
  const TodosOverviewDatePicker({super.key});
  @override
  State<TodosOverviewDatePicker> createState() =>
      _TodosOverviewDatePickerState();
}

class _TodosOverviewDatePickerState extends State<TodosOverviewDatePicker> {
  _TodosOverviewDatePickerState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6, left: 20),
      child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
        builder: (context, state) {
          return DatePicker(
            DateTime.now(),
            width: 80,
            height: 120,
            initialSelectedDate: state.selectedDate,
            selectedTextColor: Colors.white,
            selectionColor: primaryColor,
            dateTextStyle: Theme.of(context).textTheme.bodySmall!,
            dayTextStyle: Theme.of(context).textTheme.bodyMedium!,
            monthTextStyle: Theme.of(context).textTheme.bodySmall!,
            onDateChange: (newDate) {
              context
                  .read<TodosOverviewBloc>()
                  .add(TodosOverviewSelectDate(selectedDate: newDate));
            },
            daysCount: 30,
          );
        },
      ),
    );
  }
}
