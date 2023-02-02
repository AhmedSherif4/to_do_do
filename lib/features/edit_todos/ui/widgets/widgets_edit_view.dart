import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_do/application/manager/size_config.dart';
import 'package:to_do_do/application/manager/string_manager.dart';
import 'package:to_do_do/application/manager/theme_manager.dart';
import 'package:to_do_do/data/models/todo_model.dart';

import '../../controller/bloc/edit_todo_bloc.dart';

class TitleField extends StatelessWidget {
  const TitleField({super.key});

  @override
  Widget build(BuildContext context) {
    final EditTodoState state = context.read<EditTodoBloc>().state;
    final String hintText = state.initialTodo?.title ?? '';

    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: AppStrings.title,
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onFieldSubmitted: (value) =>
          context.read<EditTodoBloc>().add(EditTodoTitleChanged(value)),
    );
  }
}

class DescriptionField extends StatelessWidget {
  const DescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    final EditTodoState state = context.read<EditTodoBloc>().state;
    final String hintText = state.initialTodo?.description ?? '';

    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: AppStrings.description,
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 2,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onFieldSubmitted: (value) =>
          context.read<EditTodoBloc>().add(EditTodoDescriptionChanged(value)),
    );
  }
}

class DateField extends StatelessWidget {
  const DateField({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.date,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: orangeColor,
          ),
          padding: const EdgeInsets.all(12),
          height: SizeConfig.screenHeight / 15,
          child: GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)))
                  .then((value) {
                BlocProvider.of<EditTodoBloc>(context).add(EditTodoDateChanged(
                    DateFormat.yMd().format(value ?? DateTime.now())));
                return value;
              });
            },
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: BlocBuilder<EditTodoBloc, EditTodoState>(
                      builder: (context, state) {
                        return Text(
                          state.date ?? DateFormat.yMd().format(DateTime.now()),
                          style: Theme.of(context).textTheme.titleMedium,
                        );
                      },
                    )),
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StartEndTimeDateField extends StatelessWidget {
  final bool isEndTime;
  StartEndTimeDateField({super.key, required this.isEndTime});
/*   final String _startTime = DateFormat('hh:mm a').format(DateTime.now());
  final String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString(); */

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
/*     final EditTodoState state = context.watch<EditTodoBloc>().state;
    final formStartTime = state.startTime ?? _startTime;
    final formEndTime = state.endTime ?? _endTime; */
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEndTime ? AppStrings.endTime : AppStrings.startTime,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: orangeColor,
          ),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(right: 5),
          width: SizeConfig.screenWidth / 2,
          child: GestureDetector(
            onTap:
                //end Time Logic
                () async {
              TimeOfDay? pickedTime = await showTimePicker(
                initialEntryMode: TimePickerEntryMode.dial,
                context: context,
                initialTime: isEndTime
                    ? TimeOfDay.fromDateTime(
                        DateTime.now().add(const Duration(minutes: 15)))
                    : TimeOfDay.fromDateTime(DateTime.now()),
              ).then((value) {
                if (isEndTime) {
                  // end Time
                  BlocProvider.of<EditTodoBloc>(context)
                      .add(EditTodoEndTimeChanged(value?.format(context)));
                } else {
                  // start Time
                  BlocProvider.of<EditTodoBloc>(context)
                      .add(EditTodoStartTimeChanged(value?.format(context)));
                }
                return value;
              });
            }

            // start Time Logic
            ,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: BlocBuilder<EditTodoBloc, EditTodoState>(
                      builder: (context, state) {
                        return Text(isEndTime
                            ? state.endTime ??
                                DateFormat('hh:mm a').format(DateTime.now())
                            : state.startTime ??
                                DateFormat('hh:mm a').format(DateTime.now()
                                    .add(const Duration(minutes: 15))));
                      },
                    ),
                  ),
                ),
                const Icon(Icons.access_time_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RemindFiled extends StatelessWidget {
  const RemindFiled({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.remind,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Container(
          margin: const EdgeInsets.only(right: 5),
          padding: const EdgeInsets.all(8),
          width: SizeConfig.screenWidth / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: orangeColor,
          ),
          child: BlocBuilder<EditTodoBloc, EditTodoState>(
            builder: (context, state) {
              final List<int> remindList = [5, 10, 15, 20];
              return PopupMenuButton<int>(
                itemBuilder: (context) => remindList
                    .map<PopupMenuItem<int>>(
                        (int valueRemind) => PopupMenuItem<int>(
                              value: valueRemind,
                              child: Text('$valueRemind minutes'),
                            ))
                    .toList(),
                initialValue: state.remind,
                onSelected: (value) {
                  context
                      .read<EditTodoBloc>()
                      .add(EditTodoRemindChanged(value));
                },
                shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                tooltip: AppStrings.remind,
                child: Row(
                  children: [
                    Expanded(child: Text('${state.remind} minutes early')),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 32,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RepeatField extends StatelessWidget {
  const RepeatField({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.repeat,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Container(
          margin: const EdgeInsets.only(right: 5),
          width: SizeConfig.screenWidth / 2,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: orangeColor,
          ),
          child: BlocBuilder<EditTodoBloc, EditTodoState>(
            builder: (context, state) {
              return PopupMenuButton<RepeatStatus>(
                itemBuilder: (context) => RepeatStatus.values
                    .map<PopupMenuItem<RepeatStatus>>(
                        (RepeatStatus valueRepeat) =>
                            PopupMenuItem<RepeatStatus>(
                              value: valueRepeat,
                              child: Text(valueRepeat.name),
                            ))
                    .toList(),
                initialValue: state.repeat,
                onSelected: (value) {
                  context
                      .read<EditTodoBloc>()
                      .add(EditTodoRepeatChanged(value));
                },
                shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                tooltip: AppStrings.repeat,
                child: Row(
                  children: [
                    Expanded(child: Text(state.repeat.name)),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 32,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ColorOptions extends StatelessWidget {
  const ColorOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.color,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Row(
          children: List.generate(
            3,
            (index) => GestureDetector(
              onTap: () =>
                  context.read<EditTodoBloc>().add(EditTodoColorChanged(index)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: BlocBuilder<EditTodoBloc, EditTodoState>(
                  builder: (context, state) {
                    return CircleAvatar(
                      backgroundColor: index == 0
                          ? bluishColor
                          : index == 1
                              ? pinkColor
                              : orangeColor,
                      radius: 14,
                      child: state.color == index
                          ? const Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 25,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
