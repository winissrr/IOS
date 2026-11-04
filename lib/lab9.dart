import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CatalogScreen(),
      ),
    ),
  );
}

class CartProvider extends ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get items => List.unmodifiable(_cartItems);

  int get count => _cartItems.length;

  double get totalPrice {
    return _cartItems.fold(
      0, (sum, product) => sum + product.price,
    );
  }

  bool isInCart(Product product) {
    return _cartItems.contains(product);
  }

  void toggleItem(Product product) {
    if (_cartItems.contains(product)) {
      _cartItems.remove(product);
    } else {
      _cartItems.add(product);
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearAll() {
    _cartItems.clear();
    notifyListeners();
  }
}

class Product {
  final String name;
  final double price;

  const Product({
    required this.name,
    required this.price,
  });
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});
  final List<Product> products = const [
    Product(
      name: 'iPhone 16 Pro',
      price: 599999,
    ),
    Product(
      name: 'MacBook',
      price: 549999,
    ),
    Product(
      name: 'AirPods 2',
      price: 99999,
    ),
    Product(
      name: 'Apple Watch 11',
      price: 399999,
    ),
    Product(
      name: 'Sony Headphones',
      price: 299999,
    ),
    Product(
      name: 'Samsung A5',
      price: 89999,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().count;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wildberries'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Badge(
              label: Text('$cartCount'),
              isLabelVisible: cartCount > 0,
              child: const Icon(Icons.shopping_cart, size: 28,),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final inCart = context
              .watch<CartProvider>()
              .isInCart(product);
          return ListTile(
            leading: Icon(Icons.shopping_bag, color: inCart ? Colors.purple : Colors.grey,),
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold,),
            ),
            subtitle: Text('${product.price.toStringAsFixed(0)} ₸',),
            trailing: ElevatedButton(
              onPressed: () {
                context
                    .read<CartProvider>()
                    .toggleItem(product);
              },
              child: Text(inCart ? 'Убрать ✕' : 'Купить +',),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя корзина'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear All',
              onPressed: () {
                context.read<CartProvider>().clearAll();
              },
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const Center(
        child: Text('Корзина пуста 🛒', style: TextStyle(fontSize: 20),),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final product = cart.items[index];
                return ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green,),
                  title: Text(product.name),
                  subtitle: Text('${product.price.toStringAsFixed(0)} ₸',),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red,),
                    onPressed: () {
                      context
                          .read<CartProvider>()
                          .removeItem(product);
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                Text(
                  '${cart.totalPrice.toStringAsFixed(0)} ₸',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}