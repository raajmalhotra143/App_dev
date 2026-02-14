import 'package:equatable/equatable.dart';
import 'position.dart';
import 'chess_piece.dart';

/// Represents a chess move with additional metadata
class ChessMove extends Equatable {
  final Position from;
  final Position to;
  final bool isCapture;
  final bool isCheck;
  final bool isCheckmate;
  final CastleType? castleType;
  final PieceType? promotionPiece;
  final bool isEnPassant;

  const ChessMove({
    required this.from,
    required this.to,
    this.isCapture = false,
    this.isCheck = false,
    this.isCheckmate = false,
    this.castleType,
    this.promotionPiece,
    this.isEnPassant = false,
  });

  /// Returns true if this is a castling move
  bool get isCastle => castleType != null;

  /// Returns true if this is a pawn promotion
  bool get isPromotion => promotionPiece != null;

  /// Returns the algebraic notation for this move
  String toAlgebraic() {
    if (isCastle) {
      return castleType == CastleType.kingSide ? 'O-O' : 'O-O-O';
    }

    final fromNotation = from.toAlgebraic();
    final toNotation = to.toAlgebraic();
    final capture = isCapture ? 'x' : '';
    final promotion = isPromotion ? '=${_promotionSymbol()}' : '';
    final check = isCheckmate
        ? '#'
        : isCheck
        ? '+'
        : '';

    return '$fromNotation$capture$toNotation$promotion$check';
  }

  String _promotionSymbol() {
    switch (promotionPiece) {
      case PieceType.queen:
        return 'Q';
      case PieceType.rook:
        return 'R';
      case PieceType.bishop:
        return 'B';
      case PieceType.knight:
        return 'N';
      default:
        return '';
    }
  }

  @override
  List<Object?> get props => [
    from,
    to,
    isCapture,
    isCheck,
    isCheckmate,
    castleType,
    promotionPiece,
    isEnPassant,
  ];

  @override
  String toString() => toAlgebraic();

  /// Creates a copy of this move with different properties
  ChessMove copyWith({
    Position? from,
    Position? to,
    bool? isCapture,
    bool? isCheck,
    bool? isCheckmate,
    CastleType? castleType,
    PieceType? promotionPiece,
    bool? isEnPassant,
  }) {
    return ChessMove(
      from: from ?? this.from,
      to: to ?? this.to,
      isCapture: isCapture ?? this.isCapture,
      isCheck: isCheck ?? this.isCheck,
      isCheckmate: isCheckmate ?? this.isCheckmate,
      castleType: castleType ?? this.castleType,
      promotionPiece: promotionPiece ?? this.promotionPiece,
      isEnPassant: isEnPassant ?? this.isEnPassant,
    );
  }
}

/// Types of castling
enum CastleType { kingSide, queenSide }
