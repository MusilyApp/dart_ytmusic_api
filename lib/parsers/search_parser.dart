import 'package:dart_ytmusic_api/parsers/album_parser.dart';
import 'package:dart_ytmusic_api/parsers/artist_parser.dart';
import 'package:dart_ytmusic_api/parsers/playlist_parser.dart';
import 'package:dart_ytmusic_api/parsers/song_parser.dart';
import 'package:dart_ytmusic_api/parsers/video_parser.dart';
import 'package:dart_ytmusic_api/types.dart';
import 'package:dart_ytmusic_api/utils/traverse.dart';

class SearchParser {
  static SearchResult? parse(dynamic item) {
    final flexColumns = traverseList(item, ["flexColumns"]);
    final type =
        traverseList(flexColumns[1], ["runs", "text"]).firstOrNull as String?;

    final parsers = {
      "Song": SongParser.parseSearchResult,
      "Video": VideoParser.parseSearchResult,
      "Artist": ArtistParser.parseSearchResult,
      "EP": AlbumParser.parseSearchResult,
      "Single": AlbumParser.parseSearchResult,
      "Album": AlbumParser.parseSearchResult,
      "Playlist": PlaylistParser.parseSearchResult,
    };

    if (parsers.containsKey(type)) {
      final parsedResult = parsers[type]!(item);
      if (parsedResult is SearchResult) {
        return parsedResult;
      }
    } else {
      return null;
    }
    return null;
  }
}
