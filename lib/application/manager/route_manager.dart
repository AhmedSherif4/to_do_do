import 'package:flutter/material.dart';
import 'package:to_do_do/data/models/todo_model.dart';
import 'package:to_do_do/features/home/ui/home_view.dart';
import 'package:to_do_do/features/states/ui/stats_view.dart';
import 'package:to_do_do/features/todos_overview/ui/todos_overview_view.dart';

import '../../features/edit_todos/ui/edit_view.dart';

class Routes {
  static const String homeTodoPage = '/';
  static const String editTodoPage = 'EditTodoPage';
  static const String todoOverViewPage = 'TodoOverViewPage';
  static const String statesTodoPage = 'StatesTodoPage';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeTodoPage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.editTodoPage:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) =>  
          
          
          EditPage(initialTodo: settings.arguments as TodoModel?),
          
          );
      case Routes.todoOverViewPage:
        return MaterialPageRoute(builder: (_) => const TodosOverviewPage());
      case Routes.statesTodoPage:
        return MaterialPageRoute(builder: (_) => const StatsPage());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => unDefinedView(),
    );
  }

  static Widget unDefinedView() {
    return Scaffold(
      body: Container(),
    );
  }
}
