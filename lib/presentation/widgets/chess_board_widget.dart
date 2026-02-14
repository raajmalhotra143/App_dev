import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/position.dart';
import '../../presentation/providers/game_state_provider.dart';
import '../../core/theme/app_theme.dart';

/// Chess board widget that displays the 8x8 grid and pieces
class ChessBoardWidget extends StatelessWidget {
  const ChessBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        return AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Column(
                children: List.generate(8, (rankIndex) {
                  final rank = 7 - rankIndex;
                  return Expanded(
                    child: Row(
                      children: List.generate(8, (file) {
                        final position = Position(rank: rank, file: file);
                        return Expanded(
                          child: _buildSquare(
                            context,
                            position,
                            gameState,
                            rank,
                            file,
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSquare(
    BuildContext context,
    Position position,
    GameStateProvider gameState,
    int rank,
    int file,
  ) {
    final piece = gameState.board.getPieceAt(position);
    final isSelected = gameState.selectedPosition == position;
    final isValidMove = gameState.isValidMoveTarget(position);
    final isLight = (rank + file) % 2 != 0;
    final isLastMoveFrom = gameState.lastMove?.from == position;
    final isLastMoveTo = gameState.lastMove?.to == position;

    // Determine square color
    Color squareColor;
    if (isSelected) {
      squareColor = AppTheme.selectedSquare;
    } else if (isLastMoveFrom || isLastMoveTo) {
      squareColor = AppTheme.selectedSquare.withValues(alpha: 0.4);
    } else {
      squareColor = isLight
          ? AppTheme.premiumLightSquare
          : AppTheme.premiumDarkSquare;
    }

    return GestureDetector(
      onTap: () => gameState.onSquareTapped(position),
      child: Container(
        color: squareColor,
        child: Stack(
          children: [
            // Valid move indicator
            if (isValidMove)
              Center(
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.validMoveHighlight,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            // Chess piece
            if (piece != null)
              Center(
                child: Text(
                  piece.symbol,
                  style: const TextStyle(fontSize: 42, height: 1.0),
                ),
              ),
            // Coordinate labels
            if (file == 0)
              Positioned(
                left: 4,
                top: 4,
                child: Text(
                  '${rank + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isLight
                        ? AppTheme.premiumDarkSquare
                        : AppTheme.premiumLightSquare,
                  ),
                ),
              ),
            if (rank == 0)
              Positioned(
                right: 4,
                bottom: 4,
                child: Text(
                  String.fromCharCode('a'.codeUnitAt(0) + file),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isLight
                        ? AppTheme.premiumDarkSquare
                        : AppTheme.premiumLightSquare,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
