import 'package:ai_image_generator_app/core/constants/colors.dart';
import 'package:ai_image_generator_app/data/models/creation.dart';
import 'package:flutter/material.dart';

class CreationsScreen extends StatefulWidget {
  const CreationsScreen({super.key});

  @override
  State<CreationsScreen> createState() => _CreationsScreenState();
}

class _CreationsScreenState extends State<CreationsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  // Placeholder creations data
  final List<Creation> _creations = [
    Creation(
      id: '1',
      prompt: 'A futuristic city with flying cars at sunset',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      isFavorite: true,
    ),
    Creation(
      id: '2',
      prompt: 'A majestic waterfall inside a bioluminescent cave',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Creation(
      id: '3',
      prompt: 'Cute golden retriever astronaut floating in space',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isFavorite: true,
    ),
    Creation(
      id: '4',
      prompt: 'A tiny magical village hidden inside a hollow tree',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Creation(
      id: '5',
      prompt: 'A steampunk airship soaring through fluffy clouds',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isFavorite: true,
    ),
    Creation(
      id: '6',
      prompt: 'An ancient temple overgrown with glowing mushrooms',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Creation(
      id: '7',
      prompt: 'A cybernetic samurai in a neon-lit rain',
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
    ),
    Creation(
      id: '8',
      prompt: 'Serene Japanese garden with cherry blossoms',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Creation(
      id: '9',
      prompt: 'A dragon made of galaxies breathing stardust',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  // Gradient palettes for placeholder image cards
  static const List<List<Color>> _placeholderGradients = [
    [Color(0xFF667eea), Color(0xFF764ba2)],
    [Color(0xFFf093fb), Color(0xFFf5576c)],
    [Color(0xFF4facfe), Color(0xFF00f2fe)],
    [Color(0xFF43e97b), Color(0xFF38f9d7)],
    [Color(0xFFfa709a), Color(0xFFfee140)],
    [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
    [Color(0xFF30cfd0), Color(0xFF330867)],
    [Color(0xFFff9a9e), Color(0xFFfecfef)],
    [Color(0xFF667eea), Color(0xFF764ba2)],
  ];

  // Icons for placeholder cards
  static const List<IconData> _placeholderIcons = [
    Icons.location_city_rounded,
    Icons.water_drop_rounded,
    Icons.rocket_launch_rounded,
    Icons.park_rounded,
    Icons.cloud_rounded,
    Icons.temple_buddhist_rounded,
    Icons.bolt_rounded,
    Icons.local_florist_rounded,
    Icons.auto_awesome_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Creation> get _favoriteCreations {
    return _creations.where((c) => c.isFavorite).toList();
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [backgroundColor, surfaceColor],
          ),
        ),
        child: Column(
          children: [
            // ─── Header ───
            _buildHeader(),
            // ─── Stats Row ───
            _buildStatsRow(),
            const SizedBox(height: 8),
            // ─── Tab Bar ───
            _buildTabBar(),
            // ─── Content ───
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGridView(_creations),
                  _buildGridView(_favoriteCreations),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  HEADER
  // ═══════════════════════════════════════════════════
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: surfaceColor,
                shape: BoxShape.circle,
                border: Border.all(color: accentColor, width: 2),
              ),
              child: const Icon(Icons.arrow_back, color: accentColor),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "My Creations",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  "Your AI-generated masterpieces",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          // Sort / menu button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: surfaceColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.4),
              ),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: textColor, size: 20),
              color: surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: primaryColor.withValues(alpha: 0.3),
                ),
              ),
              onSelected: (value) {
                // TODO: handle actions
              },
              itemBuilder: (ctx) => [
                _popupItem(Icons.sort_rounded, 'Sort by Date'),
                _popupItem(Icons.select_all_rounded, 'Select All'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _popupItem(IconData icon, String label) {
    return PopupMenuItem(
      value: label,
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 18),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: textColor, fontSize: 14)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  STATS ROW
  // ═══════════════════════════════════════════════════
  Widget _buildStatsRow() {
    final total = _creations.length;
    final favs = _creations.where((c) => c.isFavorite).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          _statCard(Icons.image_rounded, '$total', 'Total'),
          const SizedBox(width: 12),
          _statCard(Icons.favorite_rounded, '$favs', 'Favorites'),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: accentColor, size: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  TAB BAR
  // ═══════════════════════════════════════════════════
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade500,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: 'All Creations'),
            Tab(text: '❤️  Favorites'),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  GRID VIEW
  // ═══════════════════════════════════════════════════
  Widget _buildGridView(List<Creation> creations) {
    if (creations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_outlined,
                color: Colors.grey.shade600, size: 64),
            const SizedBox(height: 16),
            Text(
              'No creations yet',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start generating to see your work here',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemCount: creations.length,
      itemBuilder: (context, index) {
        return _CreationCard(
          creation: creations[index],
          gradient: _placeholderGradients[index % _placeholderGradients.length],
          icon: _placeholderIcons[index % _placeholderIcons.length],
          timeAgo: _timeAgo(creations[index].createdAt),
          onFavoriteTap: () {
            setState(() {
              final i = _creations.indexOf(creations[index]);
              if (i != -1) {
                _creations[i] = _creations[i].copyWith(
                  isFavorite: !_creations[i].isFavorite,
                );
              }
            });
          },
          onTap: () => _showCreationDetail(context, creations[index], index),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════
  //  DETAIL BOTTOM SHEET
  // ═══════════════════════════════════════════════════
  void _showCreationDetail(BuildContext context, Creation creation, int index) {
    final gradient =
        _placeholderGradients[index % _placeholderGradients.length];
    final icon = _placeholderIcons[index % _placeholderIcons.length];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Image preview
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Placeholder image
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: gradient,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: gradient[0].withValues(alpha: 0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(icon, color: Colors.white.withValues(alpha: 0.4), size: 80),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Prompt
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.edit_note_rounded,
                                    color: accentColor, size: 18),
                                const SizedBox(width: 8),
                                const Text(
                                  'Prompt',
                                  style: TextStyle(
                                    color: accentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              creation.prompt,
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: _actionButton(
                              icon: Icons.download_rounded,
                              label: 'Save',
                              gradient: [primaryColor, secondaryColor],
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _actionButton(
                              icon: Icons.share_rounded,
                              label: 'Share',
                              gradient: [secondaryColor, tertiaryColor],
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _actionButton(
                              icon: Icons.delete_outline_rounded,
                              label: 'Delete',
                              gradient: [
                                Colors.red.shade700,
                                Colors.red.shade400,
                              ],
                              onTap: () {
                                Navigator.pop(ctx);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  CREATION CARD WIDGET
// ═══════════════════════════════════════════════════════
class _CreationCard extends StatelessWidget {
  final Creation creation;
  final List<Color> gradient;
  final IconData icon;
  final String timeAgo;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  const _CreationCard({
    required this.creation,
    required this.gradient,
    required this.icon,
    required this.timeAgo,
    required this.onFavoriteTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Placeholder Image ──
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradient,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: Colors.white.withValues(alpha: 0.35),
                        size: 48,
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          creation.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: creation.isFavorite
                              ? Colors.redAccent
                              : Colors.white70,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Info ──
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    creation.prompt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey.shade600,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
