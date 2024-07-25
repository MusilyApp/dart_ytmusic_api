import 'package:dart_ytmusic_api/utils/traverse.dart';

bool isTitle(dynamic data) {
  return traverseString(data, ["musicVideoType"])
          ?.startsWith("MUSIC_VIDEO_TYPE_") ??
      false;
}

/// Verifica se um objeto representa um artista.
bool isArtist(dynamic data) {
  final pageType = traverseString(data, ["pageType"]);
  return ["MUSIC_PAGE_TYPE_USER_CHANNEL", "MUSIC_PAGE_TYPE_ARTIST"]
      .contains(pageType);
}

/// Verifica se um objeto representa um álbum.
bool isAlbum(dynamic data) {
  return traverseString(data, ["pageType"]) == "MUSIC_PAGE_TYPE_ALBUM";
}

/// Verifica se um objeto representa uma duração.
bool isDuration(dynamic data) {
  final text = traverseString(data, ["text"]);
  return RegExp(r"(\d{1,2}:)?\d{1,2}:\d{1,2}").hasMatch(text ?? '');
}
