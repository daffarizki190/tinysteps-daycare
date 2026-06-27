import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../auth/login_page.dart';
import '../auth/login_provider.dart';
import 'data/tracker_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedTab = 0;
  String _selectedClassroom = 'Classroom A';
  late AnimationController _homeFadeController;
  late Animation<double> _homeFadeAnimation;

  late AnimationController _trackerFadeController;
  late Animation<double> _trackerFadeAnimation;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _homeFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _homeFadeAnimation = CurvedAnimation(
      parent: _homeFadeController,
      curve: Curves.easeInOut,
    );

    _trackerFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _trackerFadeAnimation = CurvedAnimation(
      parent: _trackerFadeController,
      curve: Curves.easeInOut,
    );
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _homeFadeController.forward();
  }

  @override
  void dispose() {
    _homeFadeController.dispose();
    _trackerFadeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
    });

    if (index == 0) {
      _homeFadeController.forward(from: 0.0);
    } else if (index == 1) {
      _trackerFadeController.forward(from: 0.0);
      // Menggunakan context.read untuk memanggil fungsi tanpa rebuild (Materi Provider)
      context.read<TrackerProvider>().fetchTrackerFromAPI();
    }
  }

  Animation<double> _buildStaggeredBounce(int index, int total) {
    final double start = (index / total) * 0.4;
    final double end = start + 0.6;

    return Tween<double>(begin: 120.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Interval(
          start.clamp(0.0, 1.0),
          end.clamp(0.0, 1.0),
          curve: Curves.bounceOut,
        ),
      ),
    );
  }

  Animation<double> _buildStaggeredOpacity(int index, int total) {
    final double start = (index / total) * 0.4;
    final double end = (start + 0.3).clamp(0.0, 1.0);

    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Interval(start.clamp(0.0, 1.0), end, curve: Curves.easeOut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildHomeTab(),
          _buildTrackerTab(),
          _buildComingSoonTab(Icons.camera_alt_rounded, 'Photos'),
          _buildComingSoonTab(Icons.chat_bubble_outline_rounded, 'Messages'),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    // Menggunakan Consumer untuk mendengarkan perubahan userName (Materi Provider)
    final loginProvider = context.watch<LoginProvider>();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryGreen.withValues(alpha: 0.4),
                width: 1.5,
              ),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'TinySteps',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryGreenDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.park_rounded,
                    size: 14,
                    color: AppColors.primaryGreenDark.withValues(alpha: 0.8),
                  ),
                ],
              ),
              Text(
                'Hello, ${loginProvider.userName}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
                size: 24,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No new notifications')),
                );
              },
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.divider, height: 1),
      ),
    );
  }

  Widget _buildHomeTab() {
    return FadeTransition(
      opacity: _homeFadeAnimation,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLiamStatusCard(),
            const SizedBox(height: 24),

            const Text(
              'QUICK ACTIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickActionsRow(),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'UPCOMING SCHEDULE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                TextButton(
                  onPressed: () => _onTabSelected(1),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreenDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildUpcomingScheduleList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLiamStatusCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Liam's Status",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreenLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '20 mins ago',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreenDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F0FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  color: Color(0xFF1A73E8),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Liam is currently Napping 😴',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.6,
                        backgroundColor: Color(0xFFECEFF1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF1A73E8),
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Expected wake up in 40 mins',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsRow() {
    final List<Map<String, dynamic>> actions = [
      {
        'label': 'Check-in',
        'icon': Icons.qr_code_scanner_rounded,
        'bgColor': const Color(0xFFE8F5E9),
        'iconColor': const Color(0xFF2E7D32),
      },
      {
        'label': 'Meals',
        'icon': Icons.restaurant_rounded,
        'bgColor': const Color(0xFFFFF3E0),
        'iconColor': const Color(0xFFE65100),
      },
      {
        'label': 'Activities',
        'icon': Icons.palette_rounded,
        'bgColor': const Color(0xFFF3ECFF),
        'iconColor': const Color(0xFF651FFF),
      },
      {
        'label': 'Photos',
        'icon': Icons.camera_alt_rounded,
        'bgColor': const Color(0xFFE1F5FE),
        'iconColor': const Color(0xFF0277BD),
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((act) {
        return Expanded(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Quick Action: ${act['label']}')),
                  );
                },
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: act['bgColor'] as Color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (act['iconColor'] as Color).withValues(
                          alpha: 0.06,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    act['icon'] as IconData,
                    color: act['iconColor'] as Color,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                act['label'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUpcomingScheduleList() {
    final now = DateTime.now();

    List<Map<String, dynamic>> schedules;

    if (now.hour >= 6 && now.hour < 11) {
      schedules = [
        {
          'time': '08:30 AM',
          'activity': 'Breakfast',
          'desc': 'Healthy cereal and fresh milk',
          'icon': Icons.breakfast_dining_rounded,
          'color': const Color(0xFFF57C00),
          'bgColor': const Color(0xFFFFF3E0),
        },
        {
          'time': '10:00 AM',
          'activity': 'Arts & Crafts',
          'desc': 'Finger painting and coloring',
          'icon': Icons.palette_rounded,
          'color': const Color(0xFF6A1B9A),
          'bgColor': const Color(0xFFF3E5F5),
        },
      ];
    } else if (now.hour >= 11 && now.hour < 15) {
      schedules = [
        {
          'time': '12:00 PM',
          'activity': 'Lunch Time',
          'desc': 'Organic purees & finger foods',
          'icon': Icons.restaurant_rounded,
          'color': const Color(0xFFE65100),
          'bgColor': const Color(0xFFFFF3E0),
        },
        {
          'time': '02:00 PM',
          'activity': 'Nap Time',
          'desc': 'Quiet time with soft music',
          'icon': Icons.bedtime_rounded,
          'color': const Color(0xFF1565C0),
          'bgColor': const Color(0xFFE3F2FD),
        },
      ];
    } else if (now.hour >= 15 && now.hour < 18) {
      schedules = [
        {
          'time': '03:30 PM',
          'activity': 'Outdoor Play',
          'desc': 'Weather permitting, sandbox & swings',
          'icon': Icons.nature_people_rounded,
          'color': const Color(0xFF2E7D32),
          'bgColor': const Color(0xFFE8F5E9),
        },
        {
          'time': '04:30 PM',
          'activity': 'Evening Snack',
          'desc': 'Fruits and light crackers',
          'icon': Icons.apple_rounded,
          'color': const Color(0xFFC62828),
          'bgColor': const Color(0xFFFFEBEE),
        },
      ];
    } else {
      schedules = [
        {
          'time': '06:30 PM',
          'activity': 'Dinner Time',
          'desc': 'Warm soup and vegetables',
          'icon': Icons.soup_kitchen_rounded,
          'color': const Color(0xFFE65100),
          'bgColor': const Color(0xFFFFF3E0),
        },
        {
          'time': '08:00 PM',
          'activity': 'Bedtime Story',
          'desc': 'Reading fairy tales before sleep',
          'icon': Icons.menu_book_rounded,
          'color': const Color(0xFF4527A0),
          'bgColor': const Color(0xFFEDE7F6),
        },
      ];
    }

    return Column(
      children: schedules.map((sch) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: sch['bgColor'] as Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                sch['icon'] as IconData,
                color: sch['color'] as Color,
                size: 22,
              ),
            ),
            title: Text(
              sch['activity'] as String,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                sch['desc'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (sch['bgColor'] as Color),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                sch['time'] as String,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: sch['color'] as Color,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrackerTab() {
    return FadeTransition(
      opacity: _trackerFadeAnimation,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Live Camera',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                _buildClassroomDropdown(),
              ],
            ),
            const SizedBox(height: 12),

            _buildLiveCameraFeed(),
            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daily Tracker',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                // Menggunakan Consumer untuk badge status API (Materi Provider)
                Consumer<TrackerProvider>(
                  builder: (context, provider, child) {
                    final hasData = provider.trackerData.isNotEmpty;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: hasData
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasData
                                ? Icons.cloud_done_rounded
                                : Icons.cloud_off_rounded,
                            size: 12,
                            color: hasData
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFE65100),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hasData ? 'API Connected' : 'Loading...',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: hasData
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFE65100),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Menggunakan Consumer untuk mendengarkan perubahan data tracker (Materi Provider)
            Consumer<TrackerProvider>(
              builder: (context, provider, child) {
                return _buildTrackerContent(provider);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackerContent(TrackerProvider provider) {
    if (provider.isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Mengambil data dari server...',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (provider.trackerError != null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  color: AppColors.error,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Gagal memuat data',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Periksa koneksi internet Anda',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                // Menggunakan context.read untuk memanggil fungsi refresh (Materi Provider)
                onPressed: () =>
                    context.read<TrackerProvider>().refreshTracker(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // TRIGGER ANIMASI ANTIGRAVITY: Jalankan efek membal saat data selesai di-load
    if (_bounceController.status == AnimationStatus.dismissed &&
        provider.trackerData.isNotEmpty) {
      _bounceController.forward(from: 0.0);
    }

    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        return Column(
          children: List.generate(provider.trackerData.length, (index) {
            final bounceAnim = _buildStaggeredBounce(
              index,
              provider.trackerData.length,
            );
            final opacityAnim = _buildStaggeredOpacity(
              index,
              provider.trackerData.length,
            );

            final item = provider.trackerData[index];

            return Opacity(
              opacity: opacityAnim.value,
              child: Transform.translate(
                offset: Offset(0, bounceAnim.value),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: item.bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: item.color, size: 22),
                    ),
                    title: Text(
                      item.activity,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.1,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: item.bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: item.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildClassroomDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedClassroom,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppColors.primaryGreenDark,
          ),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGreenDark,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedClassroom = newValue;
              });
            }
          },
          items: <String>['Classroom A', 'Classroom B', 'Playground']
              .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toList(),
        ),
      ),
    );
  }

  Widget _buildLiveCameraFeed() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/images/classroom_feed.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'LIVE',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: AppColors.primaryGreenDark,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonTab(IconData icon, String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreenLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 38, color: AppColors.primaryGreenDark),
          ),
          const SizedBox(height: 20),
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Coming soon in the next session 🚀',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    // Menggunakan Consumer untuk menampilkan data user dari Provider
    final loginProvider = context.watch<LoginProvider>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryGreen, width: 3),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            loginProvider.userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Parent Account',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () async {
                // Menggunakan context.read untuk memanggil logout tanpa rebuild (Materi Provider)
                await context.read<LoginProvider>().logout();
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.analytics_rounded, 'label': 'Tracker'},
      {'icon': Icons.camera_alt_rounded, 'label': 'Photos'},
      {'icon': Icons.chat_bubble_outline_rounded, 'label': 'Messages'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (index) {
              final isSelected = _selectedTab == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTabSelected(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        padding: EdgeInsets.all(isSelected ? 8 : 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryGreenLight
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          items[index]['icon'] as IconData,
                          size: isSelected ? 22 : 20,
                          color: isSelected
                              ? AppColors.primaryGreenDark
                              : AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected
                              ? AppColors.primaryGreenDark
                              : AppColors.textHint,
                        ),
                        child: Text(items[index]['label'] as String),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
