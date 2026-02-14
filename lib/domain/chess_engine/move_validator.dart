import '../../data/models/chess_piece.dart';
import '../../data/models/position.dart';
import '../../data/models/chess_move.dart';
import 'chess_board.dart';

/// Validates chess moves and generates legal moves
class MoveValidator {
  /// Generates all pseudo-legal moves for a piece at the given position
  /// (doesn't check if king would be in check)
  static List<ChessMove> generatePseudoLegalMoves(
    ChessBoard board,
    Position from,
  ) {
    final piece = board.getPieceAt(from);
    if (piece == null) return [];

    switch (piece.type) {
      case PieceType.pawn:
        return _generatePawnMoves(board, from, piece);
      case PieceType.knight:
        return _generateKnightMoves(board, from, piece);
      case PieceType.bishop:
        return _generateBishopMoves(board, from, piece);
      case PieceType.rook:
        return _generateRookMoves(board, from, piece);
      case PieceType.queen:
        return _generateQueenMoves(board, from, piece);
      case PieceType.king:
        return _generateKingMoves(board, from, piece);
    }
  }

  /// Generates all legal moves for a piece (accounts for king safety)
  static List<ChessMove> generateLegalMoves(ChessBoard board, Position from) {
    final pseudoLegalMoves = generatePseudoLegalMoves(board, from);
    final legalMoves = <ChessMove>[];

    for (final move in pseudoLegalMoves) {
      // Make the move on a copy of the board
      final boardCopy = board.copy();
      boardCopy.makeMove(move);

      // Check if our king is in check after the move
      final piece = board.getPieceAt(from);
      if (piece != null && !isKingInCheck(boardCopy, piece.color)) {
        legalMoves.add(move);
      }
    }

    return legalMoves;
  }

  /// Checks if the king of the given color is in check
  static bool isKingInCheck(ChessBoard board, PieceColor kingColor) {
    final kingPos = board.findKing(kingColor);
    if (kingPos == null) return false;

    return isSquareAttacked(board, kingPos, kingColor.opposite);
  }

  /// Checks if a square is attacked by any piece of the attacking color
  static bool isSquareAttacked(
    ChessBoard board,
    Position square,
    PieceColor attackingColor,
  ) {
    // Check for pawn attacks
    if (_isAttackedByPawn(board, square, attackingColor)) return true;

    // Check for knight attacks
    if (_isAttackedByKnight(board, square, attackingColor)) return true;

    // Check for sliding piece attacks (bishop, rook, queen)
    if (_isAttackedBySlidingPiece(board, square, attackingColor)) return true;

    // Check for king attacks
    if (_isAttackedByKing(board, square, attackingColor)) return true;

    return false;
  }

  static bool _isAttackedByPawn(
    ChessBoard board,
    Position square,
    PieceColor attackingColor,
  ) {
    final direction = attackingColor == PieceColor.white ? -1 : 1;
    final leftAttack = square.offset(direction, -1);
    final rightAttack = square.offset(direction, 1);

    for (final pos in [leftAttack, rightAttack]) {
      if (!pos.isValid) continue;
      final piece = board.getPieceAt(pos);
      if (piece != null &&
          piece.type == PieceType.pawn &&
          piece.color == attackingColor) {
        return true;
      }
    }
    return false;
  }

  static bool _isAttackedByKnight(
    ChessBoard board,
    Position square,
    PieceColor attackingColor,
  ) {
    final knightMoves = [
      [-2, -1],
      [-2, 1],
      [-1, -2],
      [-1, 2],
      [1, -2],
      [1, 2],
      [2, -1],
      [2, 1],
    ];

    for (final delta in knightMoves) {
      final pos = square.offset(delta[0], delta[1]);
      if (!pos.isValid) continue;
      final piece = board.getPieceAt(pos);
      if (piece != null &&
          piece.type == PieceType.knight &&
          piece.color == attackingColor) {
        return true;
      }
    }
    return false;
  }

  static bool _isAttackedBySlidingPiece(
    ChessBoard board,
    Position square,
    PieceColor attackingColor,
  ) {
    // Check diagonals (bishop, queen)
    final diagonalDirections = [
      [-1, -1],
      [-1, 1],
      [1, -1],
      [1, 1],
    ];
    for (final dir in diagonalDirections) {
      if (_checkDirection(board, square, dir, attackingColor, [
        PieceType.bishop,
        PieceType.queen,
      ])) {
        return true;
      }
    }

    // Check orthogonal (rook, queen)
    final orthogonalDirections = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1],
    ];
    for (final dir in orthogonalDirections) {
      if (_checkDirection(board, square, dir, attackingColor, [
        PieceType.rook,
        PieceType.queen,
      ])) {
        return true;
      }
    }

    return false;
  }

  static bool _checkDirection(
    ChessBoard board,
    Position start,
    List<int> direction,
    PieceColor attackingColor,
    List<PieceType> pieceTypes,
  ) {
    var current = start.offset(direction[0], direction[1]);
    while (current.isValid) {
      final piece = board.getPieceAt(current);
      if (piece != null) {
        return piece.color == attackingColor && pieceTypes.contains(piece.type);
      }
      current = current.offset(direction[0], direction[1]);
    }
    return false;
  }

  static bool _isAttackedByKing(
    ChessBoard board,
    Position square,
    PieceColor attackingColor,
  ) {
    final kingMoves = [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1],
    ];

    for (final delta in kingMoves) {
      final pos = square.offset(delta[0], delta[1]);
      if (!pos.isValid) continue;
      final piece = board.getPieceAt(pos);
      if (piece != null &&
          piece.type == PieceType.king &&
          piece.color == attackingColor) {
        return true;
      }
    }
    return false;
  }

  static List<ChessMove> _generatePawnMoves(
    ChessBoard board,
    Position from,
    ChessPiece piece,
  ) {
    final moves = <ChessMove>[];
    final direction = piece.color == PieceColor.white ? 1 : -1;
    final startRank = piece.color == PieceColor.white ? 1 : 6;
    final promotionRank = piece.color == PieceColor.white ? 7 : 0;

    // Forward move
    final forward = from.offset(direction, 0);
    if (forward.isValid && board.getPieceAt(forward) == null) {
      if (forward.rank == promotionRank) {
        // Promotion moves
        for (final promotionPiece in [
          PieceType.queen,
          PieceType.rook,
          PieceType.bishop,
          PieceType.knight,
        ]) {
          moves.add(
            ChessMove(from: from, to: forward, promotionPiece: promotionPiece),
          );
        }
      } else {
        moves.add(ChessMove(from: from, to: forward));

        // Double forward from starting position
        if (from.rank == startRank) {
          final doubleForward = from.offset(direction * 2, 0);
          if (doubleForward.isValid &&
              board.getPieceAt(doubleForward) == null) {
            moves.add(ChessMove(from: from, to: doubleForward));
          }
        }
      }
    }

    // Captures
    for (final fileDelta in [-1, 1]) {
      final capturePos = from.offset(direction, fileDelta);
      if (!capturePos.isValid) continue;

      final targetPiece = board.getPieceAt(capturePos);
      if (targetPiece != null && targetPiece.color != piece.color) {
        if (capturePos.rank == promotionRank) {
          // Capture with promotion
          for (final promotionPiece in [
            PieceType.queen,
            PieceType.rook,
            PieceType.bishop,
            PieceType.knight,
          ]) {
            moves.add(
              ChessMove(
                from: from,
                to: capturePos,
                isCapture: true,
                promotionPiece: promotionPiece,
              ),
            );
          }
        } else {
          moves.add(ChessMove(from: from, to: capturePos, isCapture: true));
        }
      }

      // En passant
      if (board.enPassantTarget != null &&
          capturePos == board.enPassantTarget) {
        moves.add(
          ChessMove(
            from: from,
            to: capturePos,
            isCapture: true,
            isEnPassant: true,
          ),
        );
      }
    }

    return moves;
  }

  static List<ChessMove> _generateKnightMoves(
    ChessBoard board,
    Position from,
    ChessPiece piece,
  ) {
    final moves = <ChessMove>[];
    final knightMoves = [
      [-2, -1],
      [-2, 1],
      [-1, -2],
      [-1, 2],
      [1, -2],
      [1, 2],
      [2, -1],
      [2, 1],
    ];

    for (final delta in knightMoves) {
      final to = from.offset(delta[0], delta[1]);
      if (!to.isValid) continue;

      final targetPiece = board.getPieceAt(to);
      if (targetPiece == null) {
        moves.add(ChessMove(from: from, to: to));
      } else if (targetPiece.color != piece.color) {
        moves.add(ChessMove(from: from, to: to, isCapture: true));
      }
    }

    return moves;
  }

  static List<ChessMove> _generateSlidingMoves(
    ChessBoard board,
    Position from,
    ChessPiece piece,
    List<List<int>> directions,
  ) {
    final moves = <ChessMove>[];

    for (final dir in directions) {
      var current = from.offset(dir[0], dir[1]);
      while (current.isValid) {
        final targetPiece = board.getPieceAt(current);
        if (targetPiece == null) {
          moves.add(ChessMove(from: from, to: current));
        } else {
          if (targetPiece.color != piece.color) {
            moves.add(ChessMove(from: from, to: current, isCapture: true));
          }
          break; // Stop at any piece
        }
        current = current.offset(dir[0], dir[1]);
      }
    }

    return moves;
  }

  static List<ChessMove> _generateBishopMoves(
    ChessBoard board,
    Position from,
    ChessPiece piece,
  ) {
    final diagonals = [
      [-1, -1],
      [-1, 1],
      [1, -1],
      [1, 1],
    ];
    return _generateSlidingMoves(board, from, piece, diagonals);
  }

  static List<ChessMove> _generateRookMoves(
    ChessBoard board,
    Position from,
    ChessPiece piece,
  ) {
    final orthogonals = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1],
    ];
    return _generateSlidingMoves(board, from, piece, orthogonals);
  }

  static List<ChessMove> _generateQueenMoves(
    ChessBoard board,
    Position from,
    ChessPiece piece,
  ) {
    final allDirections = [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1],
    ];
    return _generateSlidingMoves(board, from, piece, allDirections);
  }

  static List<ChessMove> _generateKingMoves(
    ChessBoard board,
    Position from,
    ChessPiece piece,
  ) {
    final moves = <ChessMove>[];
    final kingMoves = [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1],
    ];

    for (final delta in kingMoves) {
      final to = from.offset(delta[0], delta[1]);
      if (!to.isValid) continue;

      final targetPiece = board.getPieceAt(to);
      if (targetPiece == null) {
        moves.add(ChessMove(from: from, to: to));
      } else if (targetPiece.color != piece.color) {
        moves.add(ChessMove(from: from, to: to, isCapture: true));
      }
    }

    // Castling
    moves.addAll(_generateCastlingMoves(board, from, piece));

    return moves;
  }

  static List<ChessMove> _generateCastlingMoves(
    ChessBoard board,
    Position from,
    ChessPiece piece,
  ) {
    final moves = <ChessMove>[];
    final rank = piece.color == PieceColor.white ? 0 : 7;

    // Only castle if king is on starting square
    if (from.rank != rank || from.file != 4) return moves;

    // Don't castle if in check
    if (isKingInCheck(board, piece.color)) return moves;

    // King-side castling
    if ((piece.color == PieceColor.white && board.whiteCanCastleKingSide) ||
        (piece.color == PieceColor.black && board.blackCanCastleKingSide)) {
      if (_canCastleKingSide(board, piece.color, rank)) {
        moves.add(
          ChessMove(
            from: from,
            to: Position(rank: rank, file: 6),
            castleType: CastleType.kingSide,
          ),
        );
      }
    }

    // Queen-side castling
    if ((piece.color == PieceColor.white && board.whiteCanCastleQueenSide) ||
        (piece.color == PieceColor.black && board.blackCanCastleQueenSide)) {
      if (_canCastleQueenSide(board, piece.color, rank)) {
        moves.add(
          ChessMove(
            from: from,
            to: Position(rank: rank, file: 2),
            castleType: CastleType.queenSide,
          ),
        );
      }
    }

    return moves;
  }

  static bool _canCastleKingSide(ChessBoard board, PieceColor color, int rank) {
    // Check squares between king and rook are empty
    for (int file = 5; file < 7; file++) {
      if (board.getPieceAt(Position(rank: rank, file: file)) != null) {
        return false;
      }
    }

    // Check that squares king passes through are not attacked
    for (int file = 4; file <= 6; file++) {
      if (isSquareAttacked(
        board,
        Position(rank: rank, file: file),
        color.opposite,
      )) {
        return false;
      }
    }

    return true;
  }

  static bool _canCastleQueenSide(
    ChessBoard board,
    PieceColor color,
    int rank,
  ) {
    // Check squares between king and rook are empty
    for (int file = 1; file < 4; file++) {
      if (board.getPieceAt(Position(rank: rank, file: file)) != null) {
        return false;
      }
    }

    // Check that squares king passes through are not attacked
    for (int file = 2; file <= 4; file++) {
      if (isSquareAttacked(
        board,
        Position(rank: rank, file: file),
        color.opposite,
      )) {
        return false;
      }
    }

    return true;
  }
}
