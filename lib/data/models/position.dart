import 'package:equatable/equatable.dart';

/// Represents a position on the chess board using rank (row) and file (column)
/// Rank: 0-7 (1-8 in chess notation)
/// File: 0-7 (a-h in chess notation)
class Position extends Equatable {
  final int rank; // 0-7 (row, where 0 is rank 1, 7 is rank 8)
  final int file; // 0-7 (column, where 0 is file 'a', 7 is file 'h')

  const Position({required this.rank, required this.file});

  /// Creates a Position from algebraic notation (e.g., "e4")
  factory Position.fromAlgebraic(String notation) {
    if (notation.length != 2) {
      throw ArgumentError('Invalid algebraic notation: $notation');
    }

    final file = notation[0].toLowerCase().codeUnitAt(0) - 'a'.codeUnitAt(0);
    final rank = int.parse(notation[1]) - 1;

    if (file < 0 || file > 7 || rank < 0 || rank > 7) {
      throw ArgumentError('Position out of bounds: $notation');
    }

    return Position(rank: rank, file: file);
  }

  /// Returns true if this position is within the board bounds
  bool get isValid {
    return rank >= 0 && rank <= 7 && file >= 0 && file <= 7;
  }

  /// Converts this position to algebraic notation (e.g., "e4")
  String toAlgebraic() {
    final fileChar = String.fromCharCode('a'.codeUnitAt(0) + file);
    final rankNumber = (rank + 1).toString();
    return '$fileChar$rankNumber';
  }

  /// Returns a new position offset by the given delta
  Position offset(int rankDelta, int fileDelta) {
    return Position(rank: rank + rankDelta, file: file + fileDelta);
  }

  /// Returns the Manhattan distance to another position
  int distanceTo(Position other) {
    return (rank - other.rank).abs() + (file - other.file).abs();
  }

  /// Returns the Chebyshev distance (king's move distance) to another position
  int kingDistanceTo(Position other) {
    return ((rank - other.rank).abs()).max((file - other.file).abs());
  }

  /// Returns true if this position is on the same rank as another
  bool onSameRank(Position other) => rank == other.rank;

  /// Returns true if this position is on the same file as another
  bool onSameFile(Position other) => file == other.file;

  /// Returns true if this position is on the same diagonal as another
  bool onSameDiagonal(Position other) {
    return (rank - other.rank).abs() == (file - other.file).abs();
  }

  @override
  List<Object?> get props => [rank, file];

  @override
  String toString() => toAlgebraic();
}

/// Extension methods for integers
extension IntExtension on int {
  int max(int other) => this > other ? this : other;
  int min(int other) => this < other ? this : other;
}
