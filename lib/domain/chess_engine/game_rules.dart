import '../../data/models/chess_piece.dart';
import '../../data/models/position.dart';
import '../../data/models/chess_move.dart';
import 'chess_board.dart';
import 'move_validator.dart';

/// Game status enumeration
enum GameStatus { ongoing, check, checkmate, stalemate, draw }

/// Handles chess game rules and game state evaluation
class GameRules {
  /// Checks the current game status
  static GameStatus getGameStatus(ChessBoard board) {
    final currentColor = board.currentTurn;
    final isInCheck = MoveValidator.isKingInCheck(board, currentColor);

    // Check if current player has any legal moves
    final hasLegalMoves = _hasAnyLegalMoves(board, currentColor);

    if (!hasLegalMoves) {
      if (isInCheck) {
        return GameStatus.checkmate;
      } else {
        return GameStatus.stalemate;
      }
    }

    // Check for draw conditions
    if (_isDrawByFiftyMoveRule(board)) {
      return GameStatus.draw;
    }

    if (_isDrawByInsufficientMaterial(board)) {
      return GameStatus.draw;
    }

    if (_isDrawByThreefoldRepetition(board)) {
      return GameStatus.draw;
    }

    if (isInCheck) {
      return GameStatus.check;
    }

    return GameStatus.ongoing;
  }

  /// Checks if the current player has any legal moves
  static bool _hasAnyLegalMoves(ChessBoard board, PieceColor color) {
    final pieces = board.getPiecesOfColor(color);
    for (final entry in pieces) {
      final moves = MoveValidator.generateLegalMoves(board, entry.key);
      if (moves.isNotEmpty) return true;
    }
    return false;
  }

  /// Checks for draw by 50-move rule
  static bool _isDrawByFiftyMoveRule(ChessBoard board) {
    return board.halfmoveClock >= 100; // 50 moves = 100 half-moves
  }

  /// Checks for draw by insufficient material
  static bool _isDrawByInsufficientMaterial(ChessBoard board) {
    final whitePieces = board.getPiecesOfColor(PieceColor.white);
    final blackPieces = board.getPiecesOfColor(PieceColor.black);

    // King vs King
    if (whitePieces.length == 1 && blackPieces.length == 1) {
      return true;
    }

    // King and Bishop vs King
    if (_isKingAndBishopVsKing(whitePieces, blackPieces) ||
        _isKingAndBishopVsKing(blackPieces, whitePieces)) {
      return true;
    }

    // King and Knight vs King
    if (_isKingAndKnightVsKing(whitePieces, blackPieces) ||
        _isKingAndKnightVsKing(blackPieces, whitePieces)) {
      return true;
    }

    // King and Bishop vs King and Bishop (same color squares)
    if (_isKingAndBishopVsKingAndBishop(board, whitePieces, blackPieces)) {
      return true;
    }

    return false;
  }

  static bool _isKingAndBishopVsKing(
    List<MapEntry<Position, ChessPiece>> pieces1,
    List<MapEntry<Position, ChessPiece>> pieces2,
  ) {
    if (pieces1.length != 2 || pieces2.length != 1) return false;
    final nonKing = pieces1.firstWhere((e) => e.value.type != PieceType.king);
    return nonKing.value.type == PieceType.bishop;
  }

  static bool _isKingAndKnightVsKing(
    List<MapEntry<Position, ChessPiece>> pieces1,
    List<MapEntry<Position, ChessPiece>> pieces2,
  ) {
    if (pieces1.length != 2 || pieces2.length != 1) return false;
    final nonKing = pieces1.firstWhere((e) => e.value.type != PieceType.king);
    return nonKing.value.type == PieceType.knight;
  }

  static bool _isKingAndBishopVsKingAndBishop(
    ChessBoard board,
    List<MapEntry<Position, ChessPiece>> whitePieces,
    List<MapEntry<Position, ChessPiece>> blackPieces,
  ) {
    if (whitePieces.length != 2 || blackPieces.length != 2) return false;

    final whiteBishop = whitePieces
        .where((e) => e.value.type == PieceType.bishop)
        .toList();
    final blackBishop = blackPieces
        .where((e) => e.value.type == PieceType.bishop)
        .toList();

    if (whiteBishop.isEmpty || blackBishop.isEmpty) return false;

    // Check if bishops are on same color squares
    final whiteBishopPos = whiteBishop.first.key;
    final blackBishopPos = blackBishop.first.key;

    final whiteSquareColor = (whiteBishopPos.rank + whiteBishopPos.file) % 2;
    final blackSquareColor = (blackBishopPos.rank + blackBishopPos.file) % 2;

    return whiteSquareColor == blackSquareColor;
  }

  /// Checks for draw by threefold repetition
  static bool _isDrawByThreefoldRepetition(ChessBoard board) {
    // For a complete implementation, we would need to track position hashes
    // This is a simplified version that would need enhancement
    // In a real implementation, we'd maintain a map of position hashes
    // and count occurrences
    return false; // Placeholder for now
  }

  /// Validates if a move would leave the king in check (illegal move)
  static bool wouldLeaveKingInCheck(ChessBoard board, ChessMove move) {
    final boardCopy = board.copy();
    boardCopy.makeMove(move);
    final piece = board.getPieceAt(move.from);
    if (piece == null) return true;
    return MoveValidator.isKingInCheck(boardCopy, piece.color);
  }

  /// Gets all legal moves for all pieces of the current player
  static List<ChessMove> getAllLegalMoves(ChessBoard board) {
    final moves = <ChessMove>[];
    final pieces = board.getPiecesOfColor(board.currentTurn);

    for (final entry in pieces) {
      final pieceMoves = MoveValidator.generateLegalMoves(board, entry.key);
      moves.addAll(pieceMoves);
    }

    return moves;
  }

  /// Determines the winner (returns null if game is not over)
  static PieceColor? getWinner(ChessBoard board, GameStatus status) {
    if (status == GameStatus.checkmate) {
      // The winner is the opposite of the current turn (who is in checkmate)
      return board.currentTurn.opposite;
    }
    return null;
  }
}
