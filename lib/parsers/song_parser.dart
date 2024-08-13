import 'package:dart_ytmusic_api/parsers/parser.dart';
import 'package:dart_ytmusic_api/types.dart';
import 'package:dart_ytmusic_api/utils/filters.dart';
import 'package:dart_ytmusic_api/utils/traverse.dart';

class SongParser {
  static SongFull parse(dynamic data) {
    return SongFull(
      type: "SONG",
      videoId: traverseString(data, ["videoDetails", "videoId"]) ?? '',
      name: traverseString(data, ["videoDetails", "title"]) ?? '',
      artist: ArtistBasic(
        name: traverseString(data, ["author"]) ?? '',
        artistId: traverseString(data, ["videoDetails", "channelId"]),
      ),
      duration: int.parse(
          traverseString(data, ["videoDetails", "lengthSeconds"]) ?? '0'),
      thumbnails: traverseList(data, ["videoDetails", "thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
      formats: traverseList(data, ["streamingData", "formats"]),
      adaptiveFormats: traverseList(data, ["streamingData", "adaptiveFormats"]),
    );
  }

  static SongDetailed parseSearchResult(dynamic item) {
    final columns = traverseList(item, ["flexColumns", "runs"]);
    // It is not possible to identify the title and author
    final title = columns[0];
    final artist = columns.firstWhere(isArtist, orElse: () => columns[3]);
    final album = columns.firstWhere(isAlbum, orElse: () => null);
    final duration = columns.firstWhere(
        (item) => isDuration(item) && item != title,
        orElse: () => null);

    return SongDetailed(
      type: "SONG",
      videoId: traverseString(item, ["playlistItemData", "videoId"]) ?? '',
      name: traverseString(title, ["text"]) ?? '',
      artist: ArtistBasic(
        name: traverseString(artist, ["text"]) ?? '',
        artistId: traverseString(artist, ["browseId"]),
      ),
      album: album != null
          ? AlbumBasic(
              name: traverseString(album, ["text"]) ?? '',
              albumId: traverseString(album, ["browseId"]) ?? '',
            )
          : null,
      duration: Parser.parseDuration(duration?['text']),
      thumbnails: traverseList(item, ["thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
    );
  }

  static SongDetailed parseArtistSong(dynamic item, ArtistBasic artistBasic) {
    final columns = traverseList(item, ["flexColumns", "runs"])
        .expand((e) => e is List ? e : [e])
        .toList();

    final title = columns.firstWhere(isTitle, orElse: () => null);
    final album = columns.firstWhere(isAlbum, orElse: () => null);
    final duration = columns.firstWhere(isDuration, orElse: () => null);
    final cleanedDuration =
        duration?['text']?.replaceAll(RegExp(r'[^0-9:]'), '');

    return SongDetailed(
      type: "SONG",
      videoId: traverseString(item, ["playlistItemData", "videoId"]) ?? '',
      name: traverseString(title, ["text"]) ?? '',
      artist: artistBasic,
      album: album != null
          ? AlbumBasic(
              name: traverseString(album, ["text"]) ?? '',
              albumId: traverseString(album, ["browseId"]) ?? '',
            )
          : null,
      duration: Parser.parseDuration(cleanedDuration),
      thumbnails: traverseList(item, ["thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
    );
  }

  static SongDetailed parseArtistTopSong(
      dynamic item, ArtistBasic artistBasic) {
    final columns = traverseList(item, ["flexColumns", "runs"])
        .expand((e) => e is List ? e : [e])
        .toList();

    final title = columns.firstWhere(isTitle, orElse: () => null);
    final album = columns.firstWhere(isAlbum, orElse: () => null);

    return SongDetailed(
      type: "SONG",
      videoId: traverseString(item, ["playlistItemData", "videoId"]) ?? '',
      name: traverseString(title, ["text"]) ?? '',
      artist: artistBasic,
      album: album != null
          ? AlbumBasic(
              name: traverseString(album, ["text"]) ?? '',
              albumId: traverseString(album, ["browseId"]) ?? '',
            )
          : null,
      duration: null,
      thumbnails: traverseList(item, ["thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
    );
  }

  static SongDetailed parseAlbumSong(
    dynamic item,
    ArtistBasic artistBasic,
    AlbumBasic albumBasic,
    List<ThumbnailFull> thumbnails,
  ) {
    final title = traverseList(item, ["flexColumns", "runs"])
        .firstWhere(isTitle, orElse: () => null);
    final duration = traverseList(item, ["fixedColumns", "runs"])
        .firstWhere(isDuration, orElse: () => null);

    return SongDetailed(
      type: "SONG",
      videoId: traverseString(item, ["playlistItemData", "videoId"]) ?? '',
      name: traverseString(title, ["text"]) ?? '',
      artist: artistBasic,
      album: albumBasic,
      duration: Parser.parseDuration(duration?['text']),
      thumbnails: thumbnails,
    );
  }

  static SongDetailed parseHomeSection(dynamic item) {
    return parseSearchResult(item);
  }
}
