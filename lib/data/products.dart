import '../models/product.dart';

class ProductsData {
  static const sample = <Product>[
    Product(
      id: 'p1',
      name: 'Dog Collar (Adjustable)',
      image: 'assets/images/dog_collar.webp',
      category: 'Dog',
      description: 'Durable nylon collar with soft padding for daily walks.',
      price: 12.50,
    ),
    Product(
      id: 'p2',
      name: 'Cat Litter (5kg, low-dust)',
      image: 'assets/images/cat_litter.webp',
      category: 'Cat',
      description: 'Quick-clumping litter with odour control for easy cleanup.',
      price: 9.99,
    ),
    Product(
      id: 'p3',
      name: 'Fish Food (Tropical flakes)',
      image: 'assets/images/fish_food.webp',
      category: 'Fish',
      description: 'Balanced nutrition for vibrant colours and healthy fins.',
      price: 5.49,
    ),
    Product(
      id: 'p4',
      name: 'Bird Cage (Medium)',
      image: 'assets/images/bird_cage.webp',
      category: 'Bird',
      description: 'Powder-coated steel cage with easy-clean tray.',
      price: 45.00,
    ),
  ];
}
