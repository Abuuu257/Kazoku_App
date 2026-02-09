import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Battery _battery = Battery();
  int _batteryLevel = 100;
  // BatteryState is an enum, not an int
  StreamSubscription<BatteryState>? _batterySubscription;
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  DateTime _lastShakeTime = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _initBattery();
    _initShake();
  }

  @override
  void dispose() {
    _batterySubscription?.cancel();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initBattery() async {
    // Get current battery level
    try {
      final level = await _battery.batteryLevel;
      setState(() => _batteryLevel = level);
      
      // Listen for changes
      _batterySubscription = _battery.onBatteryStateChanged.listen((state) async {
        final level = await _battery.batteryLevel;
        setState(() => _batteryLevel = level);
        
        if (level < 20 && mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
               content: Text('Battery is low! Finish your shopping quickly.'),
               backgroundColor: Colors.orange,
             ),
           );
        }
      });
    } catch (e) {
      debugPrint('Battery info not available: $e');
    }
  }

  void _initShake() {
    _accelerometerSubscription = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      // Simple shake detection
      // If acceleration on any axis is high enough
      if (event.x.abs() > 15 || event.y.abs() > 15 || event.z.abs() > 15) {
        final now = DateTime.now();
        // Debounce shake events (2 seconds)
        if (now.difference(_lastShakeTime) > const Duration(seconds: 2)) {
          _lastShakeTime = now;
          if (mounted) {
            _handleShake();
          }
        }
      }
    });
  }

  void _handleShake() {
    // Show a random product recommendation
    final products = context.read<AppState>().products;
    if (products.isNotEmpty) {
       final randomProduct = (products..shuffle()).first;
       showDialog(
         context: context,
         builder: (context) => AlertDialog(
           title: const Text('🎉 Surprise Recommendation!'),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Text('Because you shook your phone, check this out:\n\n${randomProduct.name}'),
               const SizedBox(height: 10),
               Text('LKR ${randomProduct.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
             ],
           ),
           actions: [
             TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
             FilledButton(
               onPressed: () {
                 context.read<AppState>().addToCart(randomProduct);
                 Navigator.pop(context);
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${randomProduct.name} added to cart!')));
               },
               child: const Text('Add to Cart'),
             ),
           ],
         ),
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 700;
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    final featureTiles = [
      _FeatureTile(
        title: 'For Dogs',
        subtitle: 'Collars • Toys • Treats',
        image: 'assets/images/dogs.webp',
      ),
      _FeatureTile(
        title: 'For Cats',
        subtitle: 'Litter • Scratchers • Bowls',
        image: 'assets/images/cats.webp',
      ),
      _FeatureTile(
        title: 'For Birds',
        subtitle: 'Cages • Feeders • Toys',
        image: 'assets/images/birds.webp',
      ),
      _FeatureTile(
        title: 'For Fish',
        subtitle: 'Food • Filters • Decor',
        image: 'assets/images/fish.webp',
      ),
    ];

    Widget banner = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset('assets/images/banner.webp', fit: BoxFit.cover),
    );

    Widget about = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('About Kazoku'),
        Text(
          'Kazoku Pet Store brings essentials for dogs, cats, birds, and fish to your doorstep. '
          'We focus on safe materials, fair prices, and friendly service. All photos are optimised for faster loading.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        const SectionTitle('Why Shop With Kazoku?'),
        Text(
          '• Curated, pet-safe essentials for every budget\n'
          '• Optimised images for faster loading and lower data use\n'
          '• Clear, readable typography with Material 3 components\n'
          '• Designed to adapt to phones and tablets in portrait/landscape',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        const SectionTitle('Customer Care'),
        Text(
          'Delivery: Island-wide courier with tracked parcels.\n'
          'Returns: 7-day easy returns on unused items.\n'
          'Support: Chat with us 9am–6pm (Mon–Fri).\n'
          'Tips: Check product care notes on each detail page.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        const SectionTitle('Pet Tips (Quick Read)'),
        Text(
          'Dogs: Choose adjustable collars with soft padding.\n'
          'Cats: Low-dust litter helps keep your home cleaner.\n'
          'Birds: Cages should allow wing stretch and toy space.\n'
          'Fish: Feed small portions; remove leftover food.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_batteryLevel < 20)
           Padding(
             padding: const EdgeInsets.only(bottom: 16.0),
             child: Container(
               padding: const EdgeInsets.all(8),
               decoration: BoxDecoration(
                 color: Colors.orange.shade100,
                 borderRadius: BorderRadius.circular(8),
                 border: Border.all(color: Colors.orange),
               ),
               child: Row(
                 children: [
                   const Icon(Icons.battery_alert, color: Colors.orange),
                   const SizedBox(width: 8),
                   Expanded(child: Text('Battery Low ($_batteryLevel%). Optimizing performance...')),
                 ],
               ),
             ),
           ),
        if (!isLandscape) ...[
          banner,
          const SizedBox(height: 16),
          const SectionTitle('Shop by Pet'),
          GridView.count(
            crossAxisCount: isWide ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: featureTiles,
          ),
          const SizedBox(height: 16),
          about,
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: banner),
              const SizedBox(width: 16),
              Expanded(flex: 4, child: about),
            ],
          ),
          const SizedBox(height: 16),
          const SectionTitle('Shop by Pet'),
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: featureTiles,
          ),
        ],
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  const _FeatureTile({required this.title, required this.subtitle, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(image, fit: BoxFit.cover),
          Container(color: Colors.black26),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text.rich(
                TextSpan(
                  text: '$title\n',
                  style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                  children: [
                    TextSpan(
                      text: subtitle,
                      style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
