import 'package:estruturas_de_dados/pages/home_page.dart';
import 'package:estruturas_de_dados/pages/simulation_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/structure_data_selection_page.dart';

import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/structure-selection',
          builder: (context, state) => StructureSelectionPage(),
        ),
        GoRoute(
          path: '/simulation/:type',
          builder: (context, state) {
            final type = state.pathParameters['type'];
            return SimulationPage(type: type);
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      title: 'Estruturas de Dados',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
      ),
    );
  }
}
