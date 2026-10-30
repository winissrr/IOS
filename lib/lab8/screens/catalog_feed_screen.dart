import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_grid_card.dart';
import '../widgets/product_list_tile.dart';

class CatalogFeedScreen extends StatefulWidget {
  const CatalogFeedScreen({super.key});

  @override
  State<CatalogFeedScreen> createState() => _CatalogFeedScreenState();
}

class _CatalogFeedScreenState extends State<CatalogFeedScreen> {
  int _currentViewIndex = 0;

  late List<Product> _products;

  @override
  void initState() {
    super.initState();
    _products = _loadProducts();
  }

  List<Product> _loadProducts() {
    return [
      Product(
        id: 'p1',
        title: 'Black Dress',
        category: 'Dresses',
        price: 50,
        rating: 4.8,
        reviewsCount: 20,
        icon: Icons.checkroom,
        badgeColor: Colors.pink,
      ),

      Product(
        id: 'p2',
        title: 'Jacket',
        category: 'Jackets',
        price: 80,
        rating: 4.7,
        reviewsCount: 15,
        icon: Icons.checkroom,
        badgeColor: Colors.deepPurple,
      ),

      Product(
        id: 'p3',
        title: 'Baggy Jeans',
        category: 'Jeans',
        price: 60,
        rating: 4.6,
        reviewsCount: 18,
        icon: Icons.checkroom,
        badgeColor: Colors.blue,
      ),

      Product(
        id: 'p4',
        title: 'T-Shirt',
        category: 'Tops',
        price: 30,
        rating: 4.5,
        reviewsCount: 25,
        icon: Icons.checkroom,
        badgeColor: Colors.teal,
      ),

      Product(
        id: 'p5',
        title: 'Leather Bag',
        category: 'Bags',
        price: 70,
        rating: 4.9,
        reviewsCount: 12,
        icon: Icons.shopping_bag,
        badgeColor: Colors.brown,
      ),

      Product(
        id: 'p6',
        title: 'Running Shoes',
        category: 'Shoes',
        price: 90,
        rating: 4.7,
        reviewsCount: 30,
        icon: Icons.directions_run,
        badgeColor: Colors.orange,
      ),

      Product(
        id: 'p7',
        title: 'Earrings',
        category: 'Jewelry',
        price: 25,
        rating: 4.8,
        reviewsCount: 10,
        icon: Icons.diamond,
        badgeColor: Colors.amber,
      ),

      Product(
        id: 'p8',
        title: 'Sunglasses',
        category: 'Accessories',
        price: 40,
        rating: 4.6,
        reviewsCount: 14,
        icon: Icons.visibility,
        badgeColor: Colors.indigo,
      ),

      Product(
        id: 'p9',
        title: 'Sweater',
        category: 'Tops',
        price: 55,
        rating: 4.7,
        reviewsCount: 16,
        icon: Icons.checkroom,
        badgeColor: Colors.green,
      ),

      Product(
        id: 'p10',
        title: 'Boots',
        category: 'Shoes',
        price: 100,
        rating: 4.9,
        reviewsCount: 22,
        icon: Icons.hiking,
        badgeColor: Colors.red,
      ),

      Product(
        id: 'p11',
        title: 'Small Bag',
        category: 'Bags',
        price: 45,
        rating: 4.8,
        reviewsCount: 13,
        icon: Icons.shopping_bag,
        badgeColor: Colors.purple,
      ),

      Product(
        id: 'p12',
        title: 'Bracelet',
        category: 'Jewelry',
        price: 35,
        rating: 4.5,
        reviewsCount: 9,
        icon: Icons.watch,
        badgeColor: Colors.blueGrey,
      ),
    ];
  }

  Future<void> _onRefresh() async {
    await Future.delayed(
      const Duration(milliseconds: 1500),
    );

    final newProduct = Product(
      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Evening Dress',
      category: 'New Arrival',
      price: 135,
      rating: 5.0,
      reviewsCount: 1,
      icon: Icons.checkroom,
      badgeColor: Colors.pinkAccent,
    );

    setState(() {
      _products.insert(0, newProduct);
    });
  }

  void _deleteProduct(int index) {
    final deletedProduct = _products[index];

    setState(() {
      _products.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedProduct.title} was deleted',),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _products.insert(index, deletedProduct);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fashion Catalog',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _onRefresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentViewIndex =
                _currentViewIndex == 0 ? 1 : 0;
              });
            },
            icon: Icon(
              _currentViewIndex == 0
                  ? Icons.grid_view
                  : Icons.view_list,
            ),
            tooltip: 'Change view',
          ),
        ],
      ),
      body: _products.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _onRefresh,
        child: _currentViewIndex == 0
            ? _buildListView()
            : _buildGridView(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentViewIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentViewIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.view_list),
            label: 'List',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Grid',
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _products.length,
      separatorBuilder: (context, index) {
        return const Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
        );
      },
      itemBuilder: (context, index) {
        final product = _products[index];
        return ProductListTile(
          product: product,
          onDelete: () {
            _deleteProduct(index);
          },
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ProductGridCard(
          product: product,
          onDelete: () {
            _deleteProduct(index);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 150),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 20),
              const Text(
                'Catalog is Empty',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'All products have been removed.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _products = _loadProducts();
                  });
                },
                icon: const Icon(Icons.restore),
                label: const Text('Reset Catalog'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}