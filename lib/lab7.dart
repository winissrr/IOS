import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Product {
  final String title;
  final String description;
  final String image;
  final double price;
  final String category;

  const Product({
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
  });
}

const List<Product> products = [
  Product(
    title: 'Dior Lipstick',
    description:
    'An elegant Dior lipstick with a delicate pink shade that gives your lips a natural and fresh look.',
    image:
    'https://www.dior.com/dw/image/v2/BGXS_PRD/on/demandware.static/-/Library-Sites-DiorSharedLibrary/default/dwd6f73939/images/beauty/07-NAVIGATION/2024/09_September/iconic-push/Y0457000_C045700001_E01_GHC.jpg?sw=1280',
    price: 40,
    category: 'Makeup',
  ),
  Product(
    title: 'Dior Palette',
    description:
    'A versatile palette for creating a harmonious face makeup look.',
    image:
    'https://th.bing.com/th/id/R.c54c3f7167f9604038289b05407d2b8e?rik=GHghUd8%2fwtWTqQ&pid=ImgRaw&r=0',
    price: 60,
    category: 'Makeup',
  ),
  Product(
    title: 'Yves Saint Laurent Libre Perfume',
    description:
    'A luxury eau de parfum with an oriental-fougère scent for women.',
    image:
    'https://th.bing.com/th/id/R.c488c791028f50ca92f1cf66b38f7d70?rik=4LmmR7rCoe4RFw&pid=ImgRaw&r=0',
    price: 200,
    category: 'Perfume',
  ),
  Product(
    title: 'Burberry Her Perfume',
    description:
    'The fragrance is dedicated to modern women and combines sweet floral and fruity notes, such as strawberry, raspberry, honeysuckle, and musk.',
    image:
    'https://fraguru.com/mdimg/secundar/o.95387.jpg',
    price: 120,
    category: 'Perfume',
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gold Apple',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Product> _favorites = [];

  void _toggleFavorite(Product product) {
    setState(() {
      if (_favorites.contains(product)) {
        _favorites.remove(product);
      } else {
        _favorites.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      FeedScreen(
        favorites: _favorites,
        onFavoriteToggle: _toggleFavorite,
      ),
      FavoritesScreen(
        favorites: _favorites,
        onFavoriteToggle: _toggleFavorite,
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class FeedScreen extends StatelessWidget {
  final List<Product> favorites;
  final Function(Product) onFavoriteToggle;

  const FeedScreen({
    super.key,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Feed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final bool isFavorite = favorites.contains(product);

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.image_not_supported, size: 60),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Chip(label: Text(product.category)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  onFavoriteToggle(product);
                                },
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(product: product),
                                    ),
                                  );
                                },
                                child: const Text('Details'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<Product> favorites;
  final Function(Product) onFavoriteToggle;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80),
            SizedBox(height: 16),
            Text(
              'No favorite products yet',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final product = favorites[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Image.network(
                product.image,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
              title: Text(
                product.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '\$${product.price.toStringAsFixed(0)}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  onFavoriteToggle(product);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailScreen(product: product),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 55),
            ),
            const SizedBox(height: 20),
            const Text(
              'Anel Utebayeva',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'anel@example.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const ListTile(
              leading: Icon(Icons.lock),
              title: Text('Privacy'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Product product;

  const DetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                product.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Chip(label: Text(product.category)),
              const SizedBox(height: 20),
              Text(
                '\$${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text(
                    'Back to Feed',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
