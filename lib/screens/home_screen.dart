import 'package:flutter/material.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

    // Portrait: banner on top, then grid, then text sections.
    // Landscape: banner on left, content on right, grid below.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
