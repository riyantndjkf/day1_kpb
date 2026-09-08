import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:day1_kpb/screen/home.dart';
import 'package:day1_kpb/screen/search.dart';
import 'package:day1_kpb/screen/history.dart';
import 'package:day1_kpb/screen/basket.dart';
import 'package:day1_kpb/screen/about.dart';
import 'package:day1_kpb/screen/addrecipe.dart';
import 'package:day1_kpb/screen/itemBasket.dart';
import 'package:day1_kpb/screen/game.dart';

GoRouter getAppRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const MyHomePage(title: "Home"),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) {
          return About();
        },
      ),
      GoRoute(
        path: '/addrecipe',
        builder: (context, state) {
          return AddRecipe();
        },
      ),
      GoRoute(
        path: '/basket', // /basket
        builder: (context, state) => Basket(),
        routes: <RouteBase>[
          GoRoute(
            path: 'item/:id', // /basket/item/10?count=5
            name: 'basketItem',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
              final count =
                  int.tryParse(state.uri.queryParameters['count'] ?? '0') ?? 0;

              return ItemBasket(id, count);
            },
          ),
        ],
      ),
    ],
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: getAppRouter(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  int _currentIndex = 0;
  final List<Widget> _screens = [Home(), Search(), History(), Game()];
  final List<String> _title = ['Home', 'Search', 'History', 'Game'];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: myDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title[_currentIndex]),
      ),
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          onPressed: () {},
          child: const Icon(Icons.skip_previous),
        ),
        ElevatedButton(onPressed: () {}, child: const Icon(Icons.skip_next)),
      ],
      bottomNavigationBar: myBottomNavigationBar(),
    );
  }

  Drawer myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("xyz"),
            accountEmail: Text("xyz@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
            ),
          ),
          ListTile(
            title: const Text("Inbox"),
            leading: const Icon(Icons.inbox),
            onTap: () {},
          ),
          ListTile(
            title: const Text("My Basket"),
            leading: const Icon(Icons.shopping_basket),
            onTap: () {},
          ),
          ListTile(
            title: const Text("About"),
            leading: const Icon(Icons.help),
            onTap: () {
              context.push("/about");
            },
          ),
          ListTile(
            title: const Text("About2"),
            leading: const Icon(Icons.help),
            onTap: () {
              context.go("/about");
            },
          ),
          ListTile(
            title: const Text("Basket"),
            leading: const Icon(Icons.shopping_cart),
            onTap: () {
              context.push("/basket");
            },
          ),

          ListTile(
            title: const Text("Add Recipe"),
            leading: const Icon(Icons.add_box_outlined),
            onTap: () {
              context.push("/addrecipe");
            },
          ),
        ],
      ),
    );
  }

  BottomNavigationBar myBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.teal,
      items: const [
        BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
        BottomNavigationBarItem(label: "History", icon: Icon(Icons.history)),
        BottomNavigationBarItem(label: "Game", icon: Icon(Icons.games)),
      ],
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
