import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_do/application/manager/theme_manager.dart';
import 'package:to_do_do/data/models/todo_model.dart';
import 'package:to_do_do/features/todos_overview/controller/bloc/todos_overview_bloc.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    required this.todo,
    super.key,
    this.onToggleCompleted,
    this.onDismissed,
    this.onTap,
  });

  final TodoModel todo;
  final ValueChanged<bool>? onToggleCompleted;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodyMedium?.color;
    return BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
      builder: (context, state) {
        final selectedDate = state.selectedDate ?? DateTime.now();
        final bool dailyRepeat = (todo.repeat == RepeatStatus.daily);
        final bool weaklyRepeat = (todo.repeat == RepeatStatus.weakly &&
            selectedDate.difference(DateFormat.yMd().parse(todo.date)).inDays %
                    7 ==
                0);
        final bool monthlyRepeat = (todo.repeat == RepeatStatus.monthly &&
            DateFormat.yMd().parse(todo.date).day == selectedDate.day);
        if (todo.date == DateFormat.yMd().format(selectedDate) ||
            dailyRepeat ||
            weaklyRepeat ||
            monthlyRepeat) {
          return dismissibleWidget(theme, captionColor);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Dismissible dismissibleWidget(ThemeData theme, Color? captionColor) {
    return Dismissible(
      key: Key('todoListTile_dismissible_${todo.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        // padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: listTileWidget(captionColor),
    );
  }

  ListTile listTileWidget(Color? captionColor) {
    return ListTile(
      isThreeLine: true,
      tileColor: _getTodoColor(todo.color),
      onTap: onTap,
      title: Text(
        todo.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: !todo.isCompleted
            ? null
            : TextStyle(
                color: captionColor,
                decoration: TextDecoration.lineThrough,
              ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time_rounded,
                color: Colors.grey[200],
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                '${todo.startTime} - ${todo.endTime}',
              )
            ],
          ),
          Text(
            todo.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      leading: Checkbox(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        value: todo.isCompleted,
        onChanged: onToggleCompleted == null
            ? null
            : (value) => onToggleCompleted!(value!),
      ),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
    );
  }

  _getTodoColor(int? color) {
    switch (color) {
      case 0:
        return bluishColor;
      case 1:
        return pinkColor;
      case 2:
        return orangeColor;
      default:
        return bluishColor;
    }
    
  }
}
