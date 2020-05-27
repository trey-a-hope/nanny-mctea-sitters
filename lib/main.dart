import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/home/Bloc.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/home/HomeBloc.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/home/HomePage.dart';
import 'package:nanny_mctea_sitters_flutter/themeData.dart';
import 'package:package_info/package_info.dart';
import 'constants.dart';

// This is our global ServiceLocator
final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUpLocater();

  //Assign app version and build number.
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nanny McTea Sitters',
      theme: theme,
      home: BlocProvider(
        create: (BuildContext context) => HomeBloc()..add(LoadPageEvent()),
        child: HomePage(),
      ),
    );
  }
}
