import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:day1_kpb/screen/about.dart';
import 'package:day1_kpb/screen/basket.dart';
import 'package:day1_kpb/screen/itembasket.dart';
import 'package:day1_kpb/screen/home.dart';
import 'package:day1_kpb/screen/search.dart';
import 'package:day1_kpb/screen/history.dart';
import 'package:day1_kpb/screen/addrecipe.dart';

GoRouter getAppRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const MyHomePage(title: "Home"),
      ),
      GoRoute(path: '/about', builder: (context, state) => const About()),
      GoRoute(path: '/addrecipe', builder: (context, state) => const AddRecipe()),
      GoRoute(
        path: '/basket',
        builder: (context, state) => const Basket(),
        routes: <RouteBase>[
          GoRoute(
            path: 'item/:id',
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

//stateless widget adalah widget yang tidak memiliki state,
//artinya widget ini tidak dapat berubah selama siklus hidupnya.
//Widget ini hanya memiliki properti yang bersifat final dan tidak dapat diubah setelah dibuat.
//Contoh dari stateless widget adalah Text, Icon, dan Image.
//harus di x atau di ctrl c untuk menghentikan proses running di terminal trus dijalankan lagi dengan perintah flutter run untuk melihat perubahan warna pada appbar
//scaffold gampangnya itu adalah kanvas atau kerangka kerja untuk membangun tampilan aplikasi.
//Scaffold menyediakan struktur dasar untuk aplikasi, termasuk app bar, body, floating action button, dan elemen-elemen lainnya. Scaffold memudahkan pengembang untuk membuat tampilan yang konsisten dan terorganisir dalam aplikasi Flutter.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: getAppRouter(),
    );
  }
}

//stateful widget adalah widget yang memiliki state, artinya widget ini dapat berubah selama siklus hidupnya.
//contoh dari stateful widget adalah Checkbox, Radio, dan Slider.
//tinggal di save aja di terminal dan otomatis akan melakukan hot reload untuk melihat perubahan pada emoji atau bisa ketik r di terminal untuk melakukan hot reload
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
  int _counter = 0;
  int _currentIndex = 0;
  final List<Widget> _screens = [Home(), Search(), History()];
  final List<String> _title = ['Home', 'Search', 'History'];

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
    String emoji = "";
    for (int i = 1; i <= _counter; i++) {
      if (i % 5 == 0) {
        emoji += "😡";
      } else {
        emoji += "😊";
      }
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
        elevation: 16.0,
        child: Column(
          children: <Widget>[
            //fungsi tipe data const itu adalah konstanta, artinya nilainya tidak dapat diubah setelah ditetapkan.
            //const diprosesnya lebih cepat daripada final karena const ditentukan pada waktu kompilasi, sedangkan final ditentukan pada waktu runtime.
            //untuk tipe data final itu adalah variabel yang nilainya hanya dapat ditetapkan sekali dan tidak dapat diubah setelah itu.
            //Final diproses pada waktu runtime, sehingga nilainya dapat ditentukan saat program dijalankan.
            const UserAccountsDrawerHeader(
              accountName: Text("xyz"),
              accountEmail: Text("xyz@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
              ),
              //semuanya itu const
            ),
            //fungsi listtile itu adalah widget yang digunakan untuk membuat item daftar (list item) dalam antarmuka pengguna Flutter.
            //ListTile biasanya digunakan dalam widget ListView atau Drawer untuk menampilkan informasi dalam bentuk baris yang dapat
            ListTile(
              title: const Text("Inbox"),
              leading: const Icon(Icons.inbox),
              onTap: () {},
            ),
            ListTile(
              title: const Text("My Basket"),
              leading: const Icon(Icons.shopping_basket),
              onTap: () {
                context.push('/basket');
              },
            ),
            ListTile(
              title: const Text("About"),
              leading: const Icon(Icons.info),
              onTap: () {
                //fungsi go itu adalah untuk navigasi ke halaman lain menggunakan go_router di Flutter.
                //Dengan menggunakan context dan path, kita dapat berpindah ke halaman yang diinginkan dalam aplikasi.
                //GoRouter.of(context).go('/about');
                //bedanya .go dan .push itu adalah .go akan mengganti halaman saat ini dengan halaman baru,
                //sedangkan .push akan menambahkan halaman baru di atas halaman saat ini,
                //sehingga pengguna dapat kembali ke halaman sebelumnya menggunakan tombol kembali.
                //context.go('/about');
                context.push('/about');
              },
            ),
            ListTile(
              title: const Text("Add Recipe"),
              leading: const Icon(Icons.add_box),
              onTap: () {
                context.push('/addrecipe');
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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

      //cara gampangnya nama methodnya di klik kanan trus pilih refactor terus pilih extract method,
      //nanti otomatis bikin method baru
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      fixedColor: Colors.teal,
      items: const [
        BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
        BottomNavigationBarItem(label: "History", icon: Icon(Icons.history)),
      ],
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
