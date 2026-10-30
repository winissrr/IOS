import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductListTile extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const ProductListTile({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        onDelete();
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: CircleAvatar(
          backgroundColor: product.badgeColor.withValues(alpha: 0.15),
          child: Icon(
            product.icon,
            color: product.badgeColor,
          ),
        ),
        title: Text(
          product.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Row(
          children: [
            Text(product.category),
            const SizedBox(width: 8),
            const Icon(
              Icons.star,
              size: 14,
              color: Colors.amber,
            ),
            const SizedBox(width: 3),
            Text(
              '${product.rating} (${product.reviewsCount})',
            ),
          ],
        ),
        trailing: Text(
          '\$${product.price.toStringAsFixed(0)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}