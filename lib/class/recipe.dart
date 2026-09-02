class Recipe {
  final int id;
  final String name;
  final String photo;
  final String desc;

  Recipe({
    required this.id,
    required this.name,
    required this.photo,
    required this.desc,
  });
}

var recipes = <Recipe>[
  Recipe(
    id: 1,
    name: 'Rujak Cingur',
    photo: 'https://www.astronauts.id/blog/wp-content/uploads/2023/12/rujak-cingur-makanan-khas-daerah-jawa-timur.jpg',
    desc: 'Rujak Cingur, makanan khas Surabaya, menjadi unik dengan menggunakan cingur (mulut sapi) sebagai bahan utama.',
  ),
  Recipe(
    id: 2,
    name: 'Nasi Gudeg',
    photo: 'https://www.astronauts.id/blog/wp-content/uploads/2023/12/nasi-gudeg-makanan-khas-daerah-DI-Jogjakarta.jpg',
    desc: 'Nasi Gudeg, kuliner khas Jogja, merupakan olahan nangka muda yang dimasak dengan santan.',
  ),
  Recipe(
    id: 3,
    name: 'Palumara',
    photo: 'https://www.astronauts.id/blog/wp-content/uploads/2023/12/palumara-makanan-khas-daerah-sulawesi-tengah.jpg',
    desc: 'Palumara, sup ikan khas Sulawesi Tengah, adalah perpaduan citarasa pedas dan asam yang menggoda selera.',
  ),
];
