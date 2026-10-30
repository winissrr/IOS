import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final int reviewsCount;
  final IconData icon;
  final Color badgeColor;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.icon,
    required this.badgeColor,
  });

  factory Product.createMock({
    required String id,
    required String title,
    required String category,
    required double price,
    required double rating,
    required int reviewsCount,
    required IconData icon,
    required Color badgeColor,
  }) {
    return Product(
      id: id,
      title: title,
      category: category,
      price: price,
      rating: rating,
      reviewsCount: reviewsCount,
      icon: icon,
      badgeColor: badgeColor,
    );
  }
}