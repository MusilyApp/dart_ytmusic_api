import 'package:dart_ytmusic_api/parsers/parser.dart';
import 'package:dart_ytmusic_api/types.dart';
import 'package:dart_ytmusic_api/utils/filters.dart';
import 'package:dart_ytmusic_api/utils/traverse.dart';

class VideoParser {
  static VideoFull parse(dynamic data) {
    return VideoFull(
      type: "VIDEO",
      videoId: traverseString(data, ["videoDetails", "videoId"]) ?? '',
      name: traverseString(data, ["videoDetails", "title"]) ?? '',
      artist: ArtistBasic(
        artistId: traverseString(data, ["videoDetails", "channelId"]),
        name: traverseString(data, ["author"]) ?? '',
      ),
      duration: int.parse(
          traverseString(data, ["videoDetails", "lengthSeconds"]) ?? '0'),
      thumbnails: traverseList(data, ["videoDetails", "thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
      unlisted: traverse(data, ["unlisted"]),
      familySafe: traverse(data, ["familySafe"]),
      paid: traverse(data, ["paid"]),
      tags: traverseList(data, ["tags"]).whereType<String>().toList(),
    );
  }

  static VideoDetailed parseSearchResult(dynamic item) {
    final columns = traverseList(item, ["flexColumns", "runs"])
        .expand((e) => e is List ? e : [e])
        .toList();

    final title = columns.firstWhere(isTitle, orElse: () => null);
    final artist = columns.firstWhere(isArtist, orElse: () => columns[1]);
    final duration = columns.firstWhere(isDuration, orElse: () => null);

    return VideoDetailed(
      type: "VIDEO",
      videoId:
          traverseString(item, ["playNavigationEndpoint", "videoId"]) ?? '',
      name: traverseString(title, ["text"]) ?? '',
      artist: ArtistBasic(
        artistId: traverseString(artist, ["browseId"]),
        name: traverseString(artist, ["text"]) ?? '',
      ),
      duration: Parser.parseDuration(duration?['text']),
      thumbnails: traverseList(item, ["thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
    );
  }

  static VideoDetailed parseArtistTopVideo(
      dynamic item, ArtistBasic artistBasic) {
    return VideoDetailed(
      type: "VIDEO",
      videoId: traverseString(item, ["videoId"]) ?? '',
      name: traverseString(item, ["runs", "text"]) ?? '',
      artist: artistBasic,
      duration: null,
      thumbnails: traverseList(item, ["thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
    );
  }

  static VideoDetailed parsePlaylistVideo(dynamic item) {
    final columns =
        traverseList(item, ["flexColumns", "runs"]).expand((e) => e).toList();

    final title = columns.firstWhere(isTitle, orElse: () => columns[0]);
    final artist = columns.firstWhere(isArtist, orElse: () => columns[1]);
    final duration = columns.firstWhere(isDuration, orElse: () => null);

    return VideoDetailed(
      type: "VIDEO",
      videoId: traverseString(item, ["playNavigationEndpoint", "videoId"]) ??
          traverseList(item, ["thumbnails"])
              .first
              .url
              .split("https://i.ytimg.com/vi/")[1]
              .split("/")[0],
      name: traverseString(title, ["text"]) ?? '',
      artist: ArtistBasic(
        name: traverseString(artist, ["text"]) ?? '',
        artistId: traverseString(artist, ["browseId"]),
      ),
      duration: Parser.parseDuration(duration?.text),
      thumbnails: traverseList(item, ["thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
    );
  }
}
