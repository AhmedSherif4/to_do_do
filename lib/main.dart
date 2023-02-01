import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'application/app.dart';
import 'application/app_bloc_observer.dart';
import 'application/dependency_injection.dart';

void main() async {
  // for making the run app wait the async objects
  WidgetsFlutterBinding.ensureInitialized();
  // for instance hydrated bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  // for dependency injection instance
  await initialAppModule();
  // for errors
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  // for observer bloc
  Bloc.observer = AppBlocObserver();
  // to handle any async error
  runZonedGuarded(
    () => runApp(const App()),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
