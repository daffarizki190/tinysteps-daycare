import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/tracker_provider.dart';
import '../models/photo_model.dart';
import '../widgets/live_camera_card.dart';
import '../widgets/activity_card.dart';
import '../widgets/photo_grid_item.dart';
import '../database/database_helper.dart';
import 'login_page.dart';

// ── Warna ────────────────────────────────────────────────────
const Color _kBackground       = Color(0xFFF7FAF8);
const Color _kPrimaryGreen     = Color(0xFF85B38B);
const Color _kPrimaryGreenDark = Color(0xFF5E8C64);
const Color _kPrimaryGreenLight = Color(0xFFE2EFE5);
const Color _kTextPrimary      = Color(0xFF1A1A2E);
const Color _kTextSecondary    = Color(0xFF6B7280);
const Color _kTextHint         = Color(0xFFB0B7C3);
const Color _kBorder           = Color(0xFFE5E7EB);
const Color _kError            = Color(0xFFEF4444);

/// HomePage — Navigasi utama dengan IndexedStack dan BottomNavigationBar.
/// 3 tab: Dashboard (Home), Photos (Galeri & Kamera), Profile (Info & Logout).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedTab = 0;

  // ── Staggered Antigravity Animation Controller ─────────────
  late AnimationController _staggerController;

  // ── Photos state ───────────────────────────────────────────
  final List<PhotoModel> _photos = [];
  bool _photosLoaded = false;

  @override
  void initState() {
    super.initState();

    // Staggered Antigravity: durasi 1.5 detik
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fetch tracker data saat pertama kali masuk
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TrackerProvider>(context, listen: false)
          .fetchTrackerFromAPI()
          .then((_) {
        // Mulai animasi setelah data dimuat
        _staggerController.forward(from: 0.0);
      });

      _loadPhotos();
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  /// Load photos dari SQLite
  Future<void> _loadPhotos() async {
    if (_photosLoaded) return;
    final photosFromDB = await DatabaseHelper.instance.getPhotos();
    setState(() {
      _photos.addAll(photosFromDB);
      _photosLoaded = true;
    });
  }

  /// Pilih foto dari kamera atau galeri
  Future<void> _pickPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final newPhoto = PhotoModel(
        id: 0, // Akan di-generate oleh DB
        imageUrl: pickedFile.path,
        caption: source == ImageSource.camera
            ? 'New photo captured 📸'
            : 'Photo from gallery 🖼️',
        timestamp: DateTime.now(),
      );
      final id = await DatabaseHelper.instance.addPhoto(newPhoto);
      final photoWithId = PhotoModel(
        id: id,
        imageUrl: newPhoto.imageUrl,
        caption: newPhoto.caption,
        timestamp: newPhoto.timestamp,
      );
      setState(() {
        _photos.insert(0, photoWithId);
      });
    }
  }

  /// Show bottom sheet untuk pilih kamera / galeri
  void _showAddPhotoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _kBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _kTextPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildSheetOption(
              icon: Icons.camera_alt_rounded,
              label: 'Take Photo',
              color: const Color(0xFF2E7D32),
              bgColor: const Color(0xFFE8F5E9),
              onTap: () {
                Navigator.pop(ctx);
                _pickPhoto(ImageSource.camera);
              },
            ),
            const SizedBox(height: 12),
            _buildSheetOption(
              icon: Icons.photo_library_rounded,
              label: 'Choose from Gallery',
              color: const Color(0xFF1565C0),
              bgColor: const Color(0xFFE3F2FD),
              onTap: () {
                Navigator.pop(ctx);
                _pickPhoto(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetOption({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: color.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  /// Ganti tab
  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  // ══════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildDashboardTab(),     // Tab 0: Dashboard (Home)
          _buildPhotosTab(),        // Tab 1: Photos (Galeri & Kamera)
          _buildProfileTab(),       // Tab 2: Profile (Info & Logout)
        ],
      ),
      // FAB hanya muncul di tab Photos
      floatingActionButton: _selectedTab == 1
          ? FloatingActionButton(
              onPressed: _showAddPhotoSheet,
              backgroundColor: _kPrimaryGreen,
              elevation: 6,
              child: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
            )
          : null,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: _kPrimaryGreen.withValues(alpha: 0.4), width: 1.5),
              color: _kPrimaryGreenLight,
            ),
            child: const Icon(Icons.person_rounded,
                size: 22, color: _kPrimaryGreenDark),
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
                      color: _kPrimaryGreenDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.park_rounded,
                      size: 14,
                      color: _kPrimaryGreenDark.withValues(alpha: 0.8)),
                ],
              ),
              // Sapaan dengan nama user
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return Text(
                    'Hello, ${auth.userName}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _kTextSecondary,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded,
              color: _kTextPrimary, size: 24),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('No new notifications'),
                backgroundColor: _kPrimaryGreenDark,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: _kBorder, height: 1),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // TAB 0: DASHBOARD
  // ══════════════════════════════════════════════════════════
  Widget _buildDashboardTab() {
    return Consumer<TrackerProvider>(
      builder: (context, tracker, _) {
        return RefreshIndicator(
          onRefresh: () async {
            await tracker.fetchTrackerFromAPI();
            // Reset animasi setelah refresh
            _staggerController.forward(from: 0.0);
          },
          color: _kPrimaryGreen,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.all(16),
            children: [
              // ── Status Card ──
              _buildStatusCard(),
              const SizedBox(height: 24),

              // ── Live Camera ──
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Live Camera',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _kTextPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const LiveCameraCard(),
              const SizedBox(height: 28),

              // ── Daily Tracker Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daily Tracker',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _kTextPrimary,
                    ),
                  ),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _kTextSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Tracker Content ──
              _buildTrackerContent(tracker),
            ],
          ),
        );
      },
    );
  }

  /// Kartu status anak
  Widget _buildStatusCard() {
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
        border: Border.all(color: _kBorder, width: 0.8),
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
                  color: _kTextPrimary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _kPrimaryGreenLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '20 mins ago',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _kPrimaryGreenDark,
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
                        color: _kTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.6,
                        backgroundColor: Color(0xFFECEFF1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF1A73E8)),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Expected wake up in 40 mins',
                      style: TextStyle(
                        fontSize: 12,
                        color: _kTextSecondary,
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

  /// Konten tracker: loading, error, atau staggered list
  Widget _buildTrackerContent(TrackerProvider tracker) {
    if (tracker.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(color: _kPrimaryGreen),
        ),
      );
    }

    if (tracker.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 40, color: _kError),
              const SizedBox(height: 8),
              Text(
                tracker.errorMessage,
                style: const TextStyle(color: _kError, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (tracker.activities.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No activities yet.',
              style: TextStyle(color: _kTextSecondary)),
        ),
      );
    }

    final itemCount = tracker.activities.length;

    // ── Staggered Antigravity Animation ──────────────────────
    // AnimatedBuilder + Transform.translate sumbu Y
    // Kurva: bounceOut dengan Interval bertahap
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, _) {
        return Column(
          children: tracker.activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            final isLast = index == itemCount - 1;

            // startDelay = (index / length) * 0.5
            final double startDelay = (index / itemCount) * 0.5;

            // CurvedAnimation dengan Interval + bounceOut
            final curvedAnim = CurvedAnimation(
              parent: _staggerController,
              curve: Interval(startDelay, 1.0, curve: Curves.bounceOut),
            );

            // Antigravity: kartu jatuh dari atas (-300) ke posisi normal (0)
            final double offsetY = -300.0 * (1.0 - curvedAnim.value);

            return Transform.translate(
              offset: Offset(0, offsetY),
              child: Opacity(
                opacity: curvedAnim.value.clamp(0.0, 1.0),
                child: ActivityCard(
                  activity: activity,
                  index: index,
                  isLast: isLast,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════
  // TAB 1: PHOTOS
  // ══════════════════════════════════════════════════════════
  Widget _buildPhotosTab() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Photo Gallery',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _kTextPrimary,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _kPrimaryGreenLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_photos.length} photos',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _kPrimaryGreenDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Grid
        _photos.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: _kPrimaryGreenLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.photo_library_outlined,
                            size: 38, color: _kPrimaryGreenDark),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No photos yet',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _kTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap + to add your first photo',
                        style: TextStyle(
                          fontSize: 13,
                          color: _kTextHint,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final photo = _photos[index];
                      return PhotoGridItem(photo: photo);
                    },
                    childCount: _photos.length,
                  ),
                ),
              ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  // TAB 2: PROFILE
  // ══════════════════════════════════════════════════════════
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile header
          _buildProfileHeader(),
          const SizedBox(height: 20),

          // Child info
          _buildChildCard(),
          const SizedBox(height: 20),

          // Settings
          _buildSettingsSection(),
          const SizedBox(height: 20),

          // Logout button
          _buildLogoutButton(),
          const SizedBox(height: 32),

          // Version
          const Text(
            'TinySteps v1.0.0',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _kTextHint,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF85B38B), Color(0xFF5E8C64)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _kPrimaryGreen.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: const Icon(Icons.person_rounded,
                size: 42, color: Colors.white),
          ),
          const SizedBox(height: 14),

          // Name
          Consumer<AuthProvider>(
            builder: (context, auth, _) => Text(
              auth.userName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'parent@tinysteps.com',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.child_care_rounded,
                  size: 18, color: _kPrimaryGreenDark),
              SizedBox(width: 8),
              Text(
                'Child Information',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _kTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: _kPrimaryGreenLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.face_rounded,
                    size: 28, color: _kPrimaryGreenDark),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Liam',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _kTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildInfoChip(
                            Icons.cake_rounded, '2 years', const Color(0xFFE91E63)),
                        const SizedBox(width: 8),
                        _buildInfoChip(Icons.school_rounded, 'Class A',
                            const Color(0xFF1565C0)),
                      ],
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

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.notifications_rounded,
            iconColor: const Color(0xFFFF9800),
            iconBg: const Color(0xFFFFF3E0),
            title: 'Notifications',
          ),
          _settingsDivider(),
          _buildSettingsTile(
            icon: Icons.lock_rounded,
            iconColor: const Color(0xFF7B1FA2),
            iconBg: const Color(0xFFF3E5F5),
            title: 'Privacy & Security',
          ),
          _settingsDivider(),
          _buildSettingsTile(
            icon: Icons.help_outline_rounded,
            iconColor: const Color(0xFF00897B),
            iconBg: const Color(0xFFE0F2F1),
            title: 'Help & Support',
          ),
          _settingsDivider(),
          _buildSettingsTile(
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xFF546E7A),
            iconBg: const Color(0xFFECEFF1),
            title: 'About TinySteps',
            subtitle: 'v1.0.0',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    String? subtitle,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title — coming soon!'),
            backgroundColor: _kPrimaryGreenDark,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _kTextPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _kTextSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: _kTextHint),
          ],
        ),
      ),
    );
  }

  Widget _settingsDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: _kBorder),
    );
  }

  /// Tombol Logout dengan konfirmasi dialog
  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text('Logout',
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: _kTextPrimary)),
            content: const Text('Are you sure you want to logout?',
                style: TextStyle(color: _kTextSecondary)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel',
                    style: TextStyle(color: _kTextSecondary)),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await Provider.of<AuthProvider>(context, listen: false)
                      .logout();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kError,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _kError.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kError.withValues(alpha: 0.2)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 20, color: _kError),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _kError,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Navigation Bar ──────────────────────────────────
  Widget _buildBottomNavBar() {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.camera_alt_rounded, 'label': 'Photos'},
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
                              ? _kPrimaryGreenLight
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          items[index]['icon'] as IconData,
                          size: isSelected ? 22 : 20,
                          color: isSelected
                              ? _kPrimaryGreenDark
                              : _kTextHint,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w400,
                          color:
                              isSelected ? _kPrimaryGreenDark : _kTextHint,
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
