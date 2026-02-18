import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameplayScreen extends StatelessWidget {
  final String? gameId;
  const GameplayScreen({super.key, this.gameId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A1C24), Color(0xFF050608)],
                ),
              ),
            ),
          ),

          // Board Layer
          Center(
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(0.6) // tilt
                ..rotateZ(-0.05),
              alignment: Alignment.center,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2D1E12), width: 12),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuB5yBqgUjUnmKZnxxMwbFM13Rbi2u9eL5gxG86_8EugMX4snIIee4JuuDBPOztlqtoB1GxOxDp95X0-Zh8Yi1YzIAoRH4EkmJyNcyPmagf3ot4oYLPKCZN0a8FMi1rCa9JGTRoPpHrHGLMhoxG-J8C7i_JJT83-YPfqrCdPcmWEShPOd8-Pb0BWFr2f72IwenubuF7mLKhpwEqagRZ0XB_Hfls3C08QrBUJTqFB83x57JyJV4diGnne97v0pZmXejhmkJzP15ND4gY',
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 50,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemBuilder: (context, index) {
                    // Simple checkerboard overlay
                    final row = index ~/ 8;
                    final col = index % 8;
                    final isDark = (row + col) % 2 == 1;
                    return Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                      // Placeholder for pieces
                      child: _buildPiece(row, col),
                    );
                  },
                  itemCount: 64,
                ),
              ),
            ),
          ),

          // UI Layer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Opponent Bar
                  _buildPlayerBar(
                    name: 'Stockfish v16',
                    rating: '3500',
                    avatarUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuC2qaKt9sGdJ25wod5ihY6Hw7FyEGPQBZmqOnfvx9oGx1hC05wrqjI4yOnZOu0Jml451uQOBei4FoC2B1utYydBECT0Hh8iumasvKA3YA5uAzlkRHeSxrTc6jt2MWQh06L-kMjsXdtQ-N1uCMSZjDgpN9uM8dfdpzetUbMRNpU7EFd8q1c9ptEK4G6tF8wNtG_t25wW__eK87dX7YZn88W6wvFZva0ODeXInohi7lj4O2b-HB4wKoxR3RZ0RQN04z8Xy9-_2FOTlRc',
                    isOpponent: true,
                    time: '08:42',
                  ),

                  const Spacer(),

                  // Game Info & Controls
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Move History Panel
                      _buildGlassPanel(
                        width: 80,
                        height: 200,
                        child: Column(
                          children: [
                            _buildMoveItem('12', 'Nf3', 'd5'),
                            _buildMoveItem('13', 'e4', 'exd4'),
                            _buildMoveItem('14', '...', '', isOpacity: true),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Action Buttons
                      Column(
                        children: [
                          _buildActionButton(Icons.flag),
                          const SizedBox(height: 8),
                          _buildActionButton(Icons.handshake),
                          const SizedBox(height: 8),
                          _buildActionButton(Icons.history),
                          const SizedBox(height: 8),
                          _buildActionButton(Icons.settings),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Player Bar
                  _buildPlayerBar(
                    name: 'You',
                    rating: '1250',
                    avatarUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAXm1FnALT7SqECwoAKto4QfBI9Zql4OOk81-biQmBLtmVN68VLH330mIC0rFmcc1rctB0oqEN0D-p7YVyUVgMf1uwayPBwW9STPRLhgFqZEm9kjoIfP28y0sN1ze-LHD9by7zlrcWMH8pHJ6MoF63EDiTZj_KyiOijGBUG-uZF9RTvTGVD9x8uaoJKyRhq2ZgM-orUB0K8QnFHgE4jCh1QleKT-0GTjzabNP-suTeAI9A6-QUzkBRLgxvpSaDB7oRlN0y0P7ENJxc',
                    isOpponent: false,
                    time: '04:15',
                    isActive: true,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Nav Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPiece(int row, int col) {
    // Placing dummy pieces
    if (row == 0 && col == 1) {
      // Black Knight
      return Image.network(
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAEWPpKn2QV735QdCWv7uN1VypxE1GXO42OAE_yvdhWgCG_2O9fcs3h9xSkYMjGf7HiPTuTy47z68-sjIcVxB8z68fZmrAhhUmjiUJx0jtVkM74UQztVgHmODZj47qcJuccj-UXeJIOsltp0sMWovIeMy8mcTczzeDtX8n_GW62KeGJsP36jk8xFuIfkYibcyuOzVUlXFhI25RhbVcjzSMP0aUr3iHItoTKa4Y7ZRgM5QjmJ7t9Qaxka7kTxMpLUZMOo4SqVAsIkJE',
      );
    }
    if (row == 3 && col == 3) {
      // White Pawn
      return Image.network(
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDxoJ-zpXLDBDfLXMKTbrClIeAq-938RRx4MrjI9hrRrCWQYecD1Pu1CQbSWMNmkT62TlMmimajY6p0h2CeAgnGGgcc31MX-AO0j1Sd8mUhKTANiPBLiEUbPEMhQgE08uQzENF6iIlPFhNvrGvQy0Q-Lp5KgQaB58GvSAfSUQzxiTRS91elRcIY6P4cwmsodUpiTHAyy0k2psFxUJDiziUT9HOUinF9upLPV7t4jSWCsajseSO0m1AGki8uBm8JV1wccMDE83enFgM',
      );
    }
    if (row == 1 && col == 4) {
      // Black Queen
      return Image.network(
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCf9Gvj8ZV9ma89A9VFtCRq3IpCDupKSY6kxgeVlEPB4ZOMSvf_ILqTfpUakdSazFSAundkFy1o-k-sfsMWmJvGd-D9h0x5ADMuGOSqyhB7lkj59HZhPU7gzqWKpcM9g8WkIr7NWPytyTCijLOw-LHoGb7VFYBuRtaeNOawAAk3bYj0eyBbAnZx6MyeWPlQGxGzl25tQUD_3LVFkQhY85QCPzfFGcEx1LWEGV49qtH_fpOcqElKpP5jQ298SEF3TFE4J_5PsBocVLM',
      );
    }
    return const SizedBox();
  }

  Widget _buildPlayerBar({
    required String name,
    required String rating,
    required String avatarUrl,
    required bool isOpponent,
    required String time,
    bool isActive = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildGlassPanel(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 16,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isOpponent ? 'Grandmaster AI' : 'Player 1',
                    style: GoogleFonts.splineSans(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    name,
                    style: GoogleFonts.splineSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildGlassPanel(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderColor: isActive ? const Color(0xFF135BEC) : Colors.transparent,
          child: Text(
            time,
            style: GoogleFonts.sourceCodePro(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassPanel({
    Widget? child,
    double? width,
    double? height,
    EdgeInsets? padding,
    Color? borderColor,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child ?? const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildMoveItem(
    String moveNum,
    String whiteMove,
    String blackMove, {
    bool isOpacity = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Opacity(
        opacity: isOpacity ? 0.5 : 1.0,
        child: Column(
          children: [
            Text(
              moveNum,
              style: GoogleFonts.splineSans(color: Colors.grey, fontSize: 10),
            ),
            Text(
              whiteMove,
              style: GoogleFonts.splineSans(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              blackMove,
              style: GoogleFonts.splineSans(
                color: const Color(0xFF135BEC),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Icon(icon, color: Colors.grey),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0C10).withValues(alpha: 0.8),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.gamepad, 'Match', true),
          _buildNavItem(Icons.analytics, 'Analysis', false),
          _buildNavItem(Icons.forum, 'Chat', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? const Color(0xFF135BEC) : Colors.grey),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.splineSans(
            fontSize: 10,
            color: isActive ? const Color(0xFF135BEC) : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
