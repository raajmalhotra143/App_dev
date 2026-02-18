import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchmakingScreen extends StatefulWidget {
  const MatchmakingScreen({super.key});

  @override
  State<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: Stack(
        children: [
          // Nebula Background (using placeholder)
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1534796636912-3b95b3ab5986?q=80&w=2342&auto=format&fit=crop',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.6),
            ),
          ),

          // Grid Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF050B14).withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context),

                const Spacer(),

                // VS Section
                Expanded(
                  flex: 3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Users
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildUserProfile(
                            name: 'YOU',
                            elo: '1540',
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCgjKMvNP9HvD65eAg2pcR4ZW3Q_IEzZMtAT2Zi0_gSqbvr-rgAa21FVlo34jdXv-WkmeXpku2m7DZaB3kufGa01ASHKfMt3QIPOqXJ1_y9ePR9hBwvGaRT3GfjM8GujGCDPVGnOUdzcplfvt6SlRS2iYp5Ahivz26c5ih6AKfMf1qemizImaeNGEtOad-oq685JTR6-AW1WxnEQNMWfjq9Lj8_36C194TsxzIWkD8MBsV8EqKQ67M3ofL3YvV43p1qgbt__pmwqps',
                            isUser: true,
                          ),
                          _buildSearchingProfile(),
                        ],
                      ),

                      // VS Core
                      ScaleTransition(
                        scale: _animation,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [Color(0xFFFFAA00), Color(0xFFFF4500)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFF4500,
                                ).withValues(alpha: 0.6),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'VS',
                              style: GoogleFonts.splineSans(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Stats Card
                _buildStatsCard(),

                const SizedBox(height: 20),

                // Cancel Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: _buildCancelButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: const Icon(Icons.chevron_left, color: Colors.white),
            ),
          ),
          Column(
            children: [
              Text(
                'RANKED MATCH',
                style: GoogleFonts.splineSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: const Color(0xFF00F3FF),
                ),
              ),
              Text(
                'Searching for opponent...',
                style: GoogleFonts.splineSans(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile({
    required String name,
    required String elo,
    required String imageUrl,
    bool isUser = false,
  }) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00F3FF).withValues(alpha: 0.3),
            ),
            color: Colors.black.withValues(alpha: 0.4),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                const Color(0xFF00F3FF).withValues(alpha: 0.2),
                BlendMode.colorBurn,
              ),
            ),
          ),
          child: Stack(
            children: [
              // Scanlines overlay simulation
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF00F3FF).withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: GoogleFonts.splineSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          'ELO $elo',
          style: GoogleFonts.sourceCodePro(
            color: const Color(0xFF00F3FF),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchingProfile() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            color: Colors.black.withValues(alpha: 0.4),
          ),
          child: Center(
            child: Icon(
              Icons.person_search,
              size: 48,
              color: Colors.red.withValues(alpha: 0.5),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'SEARCHING',
          style: GoogleFonts.splineSans(
            color: Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          '???',
          style: GoogleFonts.sourceCodePro(
            color: Colors.red.withValues(alpha: 0.5),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GRANDMASTER TIER',
                style: GoogleFonts.splineSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4AF37),
                  letterSpacing: 1.2,
                ),
              ),
              Row(
                children: [
                  Text(
                    '62%',
                    style: GoogleFonts.splineSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Win Rate',
                    style: GoogleFonts.splineSans(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: const [
                  Icon(Icons.star, size: 12, color: Color(0xFFD4AF37)),
                  Icon(Icons.star, size: 12, color: Color(0xFFD4AF37)),
                  Icon(Icons.star, size: 12, color: Color(0xFFD4AF37)),
                ],
              ),
              Text(
                'Highest Streak: 12',
                style: GoogleFonts.splineSans(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.close, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            'CANCEL MATCH',
            style: GoogleFonts.splineSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
