import 'package:flutter/material.dart';
import 'package:gymapp/pages/exercises.dart';
import 'package:gymapp/pages/statistics.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overload',
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(
            brightness: Brightness.light,
            background: Color(0xFFEEEFF5),
            onBackground: Color(0xFF4a4a4a),
            secondary: Color(0xFFe91e63),
            onSecondary: Color(0xFF2a2a2a),
            primary: Color(0xFFc2185b),
            secondaryContainer: Color(0xFFFFFFFF),
            tertiary: Color.fromARGB(255, 50, 197, 55),
            primaryContainer: Colors.white),
      ),
      darkTheme: ThemeData.from(
          colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        background: Color(0xFF2a2a2a),
        onBackground: Color(0xFFFFFFFF),
        secondary: Color(0xFFe91e63),
        onSecondary: Color(0xFF2a2a2a),
        secondaryContainer: Color(0xFF444444),
        primary: Color(0xFFe91e63),
        primaryContainer: Color(0xFF3f3f3f),
        tertiary: Color.fromARGB(255, 50, 197, 55),
      )),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Overload'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _pages = <Widget>[
    const Exercises(),
    const Statistics(),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Statistics',
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
