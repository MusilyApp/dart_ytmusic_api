import 'package:dart_ytmusic_api/parsers/album_parser.dart';
import 'package:dart_ytmusic_api/parsers/playlist_parser.dart';
import 'package:dart_ytmusic_api/parsers/song_parser.dart';
import 'package:dart_ytmusic_api/types.dart';
import 'package:dart_ytmusic_api/utils/traverse.dart';

class Parser {
  static int? parseDuration(String? time) {
    if (time == null) return null;

    final parts = time.split(":").reversed.map(int.parse).toList();
    final seconds = parts[0];
    final minutes = parts[1];
    late final int hours;

    if (parts.length > 2) {
      hours = parts[2];
    } else {
      hours = 0;
    }

    return seconds + minutes * 60 + hours * 60 * 60;
  }

  static double parseNumber(String string) {
    if (string.endsWith("K") ||
        string.endsWith("M") ||
        string.endsWith("B") ||
        string.endsWith("T")) {
      final number = double.parse(string.substring(0, string.length - 1));
      final multiplier = string.substring(string.length - 1);

      return {
            "K": number * 1000,
            "M": number * 1000 * 1000,
            "B": number * 1000 * 1000 * 1000,
            "T": number * 1000 * 1000 * 1000 * 1000,
          }[multiplier] ??
          double.nan;
    } else {
      return double.parse(string);
    }
  }

  static HomeSection parseHomeSection(dynamic data) {
    final pageType = traverseString(
        data, ["contents", "title", "browseEndpoint", "pageType"]);
    final playlistId = traverseString(
      data,
      ["navigationEndpoint", "watchPlaylistEndpoint", "playlistId"],
    );

    return HomeSection(
      title: traverseString(data, ["header", "title", "text"]) ?? '',
      contents: traverseList(data, ["contents"])
          .map((item) {
            switch (pageType) {
              case 'MUSIC_PAGE_TYPE_ALBUM':
                return AlbumParser.parseHomeSection(item);
              case 'MUSIC_PAGE_TYPE_PLAYLIST':
                return PlaylistParser.parseHomeSection(item);
              case "":
                if (playlistId != null) {
                  return PlaylistParser.parseHomeSection(item);
                } else {
                  return SongParser.parseHomeSection(item);
                }
              default:
                return null;
            }
          })
          .where((element) => element != null)
          .cast<dynamic>()
          .toList(),
    );
  }
}
