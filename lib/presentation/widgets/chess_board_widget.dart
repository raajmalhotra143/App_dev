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
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: List.generate(8, (rank) {
                // Display from rank 7 to 0 (8 to 1 in chess notation)
                final displayRank = 7 - rank;
                return Expanded(
                  child: Row(
                    children: List.generate(8, (file) {
                      final position = Position(rank: displayRank, file: file);
                      return Expanded(
                        child: _buildSquare(context, position, gameState),
                      );
                    }),
                  ),
                );
              }),
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
  ) {
    final piece = gameState.board.getPieceAt(position);
    final isSelected = gameState.selectedPosition == position;
    final isValidMove = gameState.isValidMoveTarget(position);
    final isLightSquare = (position.rank + position.file) % 2 == 0;

    // Determine square color
    Color squareColor;
    if (isSelected) {
      squareColor = AppTheme.selectedSquare;
    } else {
      squareColor = isLightSquare ? AppTheme.lightSquare : AppTheme.darkSquare;
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
                  width: piece == null ? 16 : double.infinity,
                  height: piece == null ? 16 : double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.validMoveHighlight,
                    shape: piece == null ? BoxShape.circle : BoxShape.rectangle,
                  ),
                ),
              ),
            // Chess piece
            if (piece != null)
              Center(
                child: Text(
                  piece.symbol,
                  style: const TextStyle(fontSize: 40, height: 1.0),
                ),
              ),
            // Coordinate labels
            if (position.file == 0)
              Positioned(
                left: 2,
                top: 2,
                child: Text(
                  '${position.rank + 1}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isLightSquare
                        ? AppTheme.darkSquare
                        : AppTheme.lightSquare,
                  ),
                ),
              ),
            if (position.rank == 0)
              Positioned(
                right: 2,
                bottom: 2,
                child: Text(
                  String.fromCharCode('a'.codeUnitAt(0) + position.file),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isLightSquare
                        ? AppTheme.darkSquare
                        : AppTheme.lightSquare,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
