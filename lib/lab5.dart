import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.pinkAccent),
      ),
      home: ItemPage(),
    );
  }
}

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  bool _isBookmarked = false;
  bool _isAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Product Details'),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
            },
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenWidth < 400 ? 250 : 320,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.network(
                        'https://img.pikbest.com/png-images/20240521/pink-color-luxury-womens-bag-made-of-leather-purse-isolated-on-a-transparent-background_10575643.png!bw700',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      top: 15,
                      right: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _isBookmarked = !_isBookmarked;
                            });
                          },
                          icon: Icon(
                            _isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Shopping Bag',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 25,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    '4.8',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    '(125 reviews)',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$49.99',
                    style: TextStyle(
                      fontSize: screenWidth < 400 ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: const Text('Fashion'),
                    avatar: const Icon(
                      Icons.checkroom,
                      size: 18,
                    ),
                  ),
                  Chip(
                    label: const Text('Accessories'),
                    avatar: const Icon(
                      Icons.shopping_bag,
                      size: 18,
                    ),
                  ),
                  Chip(
                    label: const Text('Premium'),
                    avatar: const Icon(
                      Icons.star,
                      size: 18,
                    ),
                  ),
                  Chip(
                    label: const Text('New'),
                    avatar: const Icon(
                      Icons.new_releases,
                      size: 18,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'A stylish and practical shopping bag is perfect for everyday use and special occasions.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isAddedToCart = true;
                    });
                  },
                  icon: Icon(
                    _isAddedToCart ? Icons.check : Icons.shopping_cart,
                  ),
                  label: Text(
                    _isAddedToCart ? 'Added to Cart' : 'Add to Cart',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
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