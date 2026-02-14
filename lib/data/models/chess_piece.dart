/// Represents the type of chess piece
enum PieceType { pawn, knight, bishop, rook, queen, king }

/// Represents the color of a chess piece
enum PieceColor { white, black }

/// Extension on PieceColor for utility methods
extension PieceColorExtension on PieceColor {
  /// Returns the opposite color
  PieceColor get opposite {
    return this == PieceColor.white ? PieceColor.black : PieceColor.white;
  }

  /// Returns true if this is white
  bool get isWhite => this == PieceColor.white;

  /// Returns true if this is black
  bool get isBlack => this == PieceColor.black;
}

/// Represents a chess piece with its type and color
class ChessPiece {
  final PieceType type;
  final PieceColor color;

  const ChessPiece({required this.type, required this.color});

  /// Returns the Unicode symbol for this piece
  String get symbol {
    const whiteSymbols = {
      PieceType.pawn: '♙',
      PieceType.knight: '♘',
      PieceType.bishop: '♗',
      PieceType.rook: '♖',
      PieceType.queen: '♕',
      PieceType.king: '♔',
    };

    const blackSymbols = {
      PieceType.pawn: '♟',
      PieceType.knight: '♞',
      PieceType.bishop: '♝',
      PieceType.rook: '♜',
      PieceType.queen: '♛',
      PieceType.king: '♚',
    };

    return color == PieceColor.white
        ? whiteSymbols[type]!
        : blackSymbols[type]!;
  }

  /// Returns the piece value for basic evaluation
  int get value {
    switch (type) {
      case PieceType.pawn:
        return 1;
      case PieceType.knight:
        return 3;
      case PieceType.bishop:
        return 3;
      case PieceType.rook:
        return 5;
      case PieceType.queen:
        return 9;
      case PieceType.king:
        return 1000;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChessPiece && other.type == type && other.color == color;
  }

  @override
  int get hashCode => type.hashCode ^ color.hashCode;

  @override
  String toString() {
    return '${color.name} ${type.name}';
  }

  /// Creates a copy of this piece
  ChessPiece copyWith({PieceType? type, PieceColor? color}) {
    return ChessPiece(type: type ?? this.type, color: color ?? this.color);
  }
}
