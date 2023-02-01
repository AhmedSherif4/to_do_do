import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_do/data/data_sources/local_data/local_todos.dart';
import 'package:to_do_do/data/repository/todos_repository.dart';
import 'package:to_do_do/features/home/controller/cubit/home_cubit.dart';
import 'package:to_do_do/features/states/controller/bloc/stats_bloc.dart';
import 'package:to_do_do/features/todos_overview/controller/bloc/todos_overview_bloc.dart';



GetIt instanceGetIt=GetIt.instance;

Future<void> initialAppModule() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  // data source
  instanceGetIt
      .registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  instanceGetIt.registerLazySingleton<TodoApi>(
      () => LocalStorageTodoApi(sharedPreferences: instanceGetIt()));

  // repository
  instanceGetIt.registerLazySingleton<TodosRepository>(
      () => TodosRepository (todoApi: instanceGetIt()));

  // bloc
  instanceGetIt.registerFactory<HomeCubit>(() => HomeCubit());
  instanceGetIt.registerFactory<TodosOverviewBloc>(
      () => TodosOverviewBloc(instanceGetIt()));
  instanceGetIt.registerFactory<StatsBloc>(
      () => StatsBloc(todosRepository: instanceGetIt()));
}
