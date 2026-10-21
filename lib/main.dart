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
import 'package:day1_kpb/screen/highscore.dart';
import 'package:day1_kpb/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:day1_kpb/screen/popularmovie.dart';
import 'package:day1_kpb/screen/detailpop.dart';


String active_user = '';
final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  active_user = prefs.getString('user_id') ?? '';
  isLoggedIn.value = active_user.isNotEmpty;
  return active_user;
}

Future<void> saveHighScore(int point) async {
  final prefs = await SharedPreferences.getInstance();
  final topPoint = prefs.getInt('top_point');
  if (topPoint == null || point > topPoint) {
    await prefs.setInt('top_point', point);
    await prefs.setString('top_user', active_user);
  }
}

GoRouter getAppRouter() {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: isLoggedIn,
    redirect: (context, state) {
      final login = state.uri.path == '/login';
      if (!isLoggedIn.value && !login) {
        return '/login';
      }
      if (isLoggedIn.value && login) {
        return '/';
      }
      return null;
    },
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
      GoRoute(path: '/login', builder: (context, state) => Login()),
      GoRoute(
        path: '/highscore',
        builder: (context, state) => const Highscore(),
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
      GoRoute(
        path: '/popularmovie',
        builder: (context, state) => const PopularMovie(),
      ),
      GoRoute(
        path: '/detailpop/:id',
        builder: (context, state) {
          final movieID = int.parse(state.pathParameters['id']!);
          return DetailPop(movieID: movieID);
        },
      ),
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkUser();
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

  @override
  void initState() {
    super.initState();
    checkUser().then((value) {
      if (!mounted) return;
      setState(() {
        active_user = value;
      });
    });
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    active_user = '';
    isLoggedIn.value = false;
  }

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
          UserAccountsDrawerHeader(
            accountName: Text(active_user),
            accountEmail: Text(active_user),
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
          ListTile(
            title: const Text("High Score"),
            leading: const Icon(Icons.emoji_events),
            onTap: () {
              context.push("/highscore");
            },
          ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: doLogout,
          ),
          ListTile(
            title: const Text("Popular Movie"),
            leading: const Icon(Icons.movie),
            onTap: () {
              context.push("/popularmovie");
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
