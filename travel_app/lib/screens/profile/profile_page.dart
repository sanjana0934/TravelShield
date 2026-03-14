import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/user_session.dart';

// ── Tokens ────────────────────────────────────────────────────────────────────
const _bg      = Color(0xFFF5F6F8);
const _white   = Colors.white;
const _primary = Color(0xFF1A6B3C);
const _accent  = Color(0xFF25A05B);
const _dark    = Color(0xFF0D1B12);
const _mid     = Color(0xFF4A6358);
const _light   = Color(0xFF9EB5A8);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Format "2000-01-20 00:00:00.000" → "20 Jan 2000"
  String _formatDob(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    try {
      final dt = DateTime.parse(raw);
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month]} ${dt.year}';
    } catch (_) {
      return raw.length > 10 ? raw.substring(0, 10) : raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = UserSession.currentUser;
    final fullName = [
      user["first_name"],
      user["middle_name"],
      user["last_name"],
    ].where((e) => e != null && e.toString().isNotEmpty).join(" ");
    final initials = (user["first_name"] ?? "U")[0].toUpperCase();
    final nationality = user["nationality"] ?? "";

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          // ── Header ─────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: _primary,
            elevation: 0,
            leading: const SizedBox.shrink(),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F3D2E), Color(0xFF1A6B3C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      // Avatar with initials
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _white.withOpacity(.15),
                          border: Border.all(
                              color: _white.withOpacity(.4), width: 2.5),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: GoogleFonts.urbanist(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: _white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        fullName,
                        style: GoogleFonts.urbanist(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: _white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.public_rounded,
                              color: Colors.white54, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            nationality,
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              color: Colors.white60,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Body ───────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Personal Information
                  _sectionTitle('Personal Information'),
                  const SizedBox(height: 12),
                  _InfoCard(tiles: [
                    _InfoTile(
                      icon: Icons.person_rounded,
                      label: 'Gender',
                      value: user["gender"],
                    ),
                    _InfoTile(
                      icon: Icons.cake_rounded,
                      label: 'Date of Birth',
                      value: _formatDob(user["dob"]),
                    ),
                    _InfoTile(
                      icon: Icons.bloodtype_rounded,
                      label: 'Blood Group',
                      value: user["blood_group"],
                      isLast: true,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Contact Information
                  _sectionTitle('Contact Information'),
                  const SizedBox(height: 12),
                  _InfoCard(tiles: [
                    _InfoTile(
                      icon: Icons.email_rounded,
                      label: 'Email',
                      value: user["email"],
                    ),
                    _InfoTile(
                      icon: Icons.phone_rounded,
                      label: 'Phone',
                      value: user["phone"],
                    ),
                    _InfoTile(
                      icon: Icons.emergency_rounded,
                      label: 'Emergency Contact',
                      value: user["emergency_contact"],
                      valueColor: const Color(0xFFE53935),
                    ),
                    _InfoTile(
                      icon: Icons.location_on_rounded,
                      label: 'Address',
                      value: user["address"],
                      isLast: true,
                    ),
                  ]),

                  const SizedBox(height: 32),

                  // Logout
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEBEE),
                        foregroundColor: const Color(0xFFE53935),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                              color: const Color(0xFFE53935).withOpacity(.3)),
                        ),
                      ),
                      onPressed: () {
                        UserSession.clear();
                        Navigator.pushReplacementNamed(context, "/login");
                      },
                      icon: const Icon(Icons.logout_rounded, size: 20),
                      label: Text(
                        'Log Out',
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: GoogleFonts.urbanist(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: _dark,
          letterSpacing: .3,
        ),
      );
}

// ── Info Card (grouped tiles) ─────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final List<_InfoTile> tiles;
  const _InfoCard({required this.tiles});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: _white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(children: tiles),
      );
}

// ── Info Tile ─────────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic value;
  final bool isLast;
  final Color? valueColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    this.value,
    this.isLast = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF5F1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: _primary, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: _light,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value?.toString() ?? '—',
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: valueColor ?? _dark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(
              height: 1,
              indent: 68,
              endIndent: 18,
              color: const Color(0xFFF0F4F2),
            ),
        ],
      );
}