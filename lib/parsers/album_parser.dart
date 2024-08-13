import 'package:dart_ytmusic_api/parsers/song_parser.dart';
import 'package:dart_ytmusic_api/types.dart';
import 'package:dart_ytmusic_api/utils/filters.dart';
import 'package:dart_ytmusic_api/utils/traverse.dart';

class AlbumParser {
  static AlbumFull parse(dynamic data, String albumId) {
    final albumBasic = AlbumBasic(
      albumId: albumId,
      name: traverseString(data, ["tabs", "title", "text"]) ?? '',
    );

    final artistData = traverse(data, ["tabs", "straplineTextOne", "runs"]);
    final artistBasic = ArtistBasic(
      artistId: traverseString(artistData, ["browseId"]),
      name: traverseString(artistData, ["text"]) ?? '',
    );

    final thumbnails = traverseList(data, ["background", "thumbnails"])
        .map((item) => ThumbnailFull.fromMap(item))
        .toList();

    return AlbumFull(
      name: albumBasic.name,
      type: "ALBUM",
      albumId: albumId,
      playlistId:
          traverseString(data, ["musicPlayButtonRenderer", "playlistId"]) ?? '',
      artist: artistBasic,
      year: processYear(
        traverseList(data, ["tabs", "subtitle", "text"]).last,
      ),
      thumbnails: thumbnails,
      songs: traverseList(data, ["musicResponsiveListItemRenderer"])
          .map(
            (item) => SongParser.parseAlbumSong(
              item,
              artistBasic,
              albumBasic,
              thumbnails,
            ),
          )
          .toList(),
    );
  }

  static AlbumDetailed parseSearchResult(dynamic item) {
    final columns = traverseList(item, ["flexColumns", "runs"])
        .expand((e) => e is List ? e : [e])
        .toList();

    // No specific way to identify the title
    final title = columns[0];
    final artist = columns.firstWhere(isArtist, orElse: () => columns[3]);
    final playlistId = traverseString(item, ["overlay", "playlistId"]) ??
        traverseString(item, ["thumbnailOverlay", "playlistId"]);

    return AlbumDetailed(
      type: "ALBUM",
      albumId: traverseList(item, ["browseId"]).last,
      playlistId: playlistId ?? '',
      artist: ArtistBasic(
        name: traverseString(artist, ["text"]) ?? '',
        artistId: traverseString(artist, ["browseId"]),
      ),
      year: processYear(columns.last?['text']),
      name: traverseString(title, ["text"]) ?? '',
      thumbnails: traverseList(item, ["thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
    );
  }

  static AlbumDetailed parseArtistAlbum(dynamic item, ArtistBasic artistBasic) {
    return AlbumDetailed(
      type: "ALBUM",
      albumId: traverseList(item, ["browseId"])
              .where((element) => element != artistBasic.artistId)
              .firstOrNull ??
          '',
      playlistId:
          traverseString(item, ["thumbnailOverlay", "playlistId"]) ?? '',
      name: traverseString(item, ["title", "text"]) ?? '',
      artist: artistBasic,
      year: processYear(traverseList(item, ["subtitle", "text"]).last),
      thumbnails: traverseList(item, ["thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
    );
  }

  static AlbumDetailed parseArtistTopAlbum(
      dynamic item, ArtistBasic artistBasic) {
    return AlbumDetailed(
      type: "ALBUM",
      albumId: traverseList(item, ["browseId"]).isEmpty
          ? ''
          : traverseList(item, ["browseId"]).last,
      playlistId:
          traverseString(item, ["musicPlayButtonRenderer", "playlistId"]) ?? '',
      name: traverseString(item, ["title", "text"]) ?? '',
      artist: artistBasic,
      year: processYear(traverseList(item, ["subtitle", "text"]).last),
      thumbnails: traverseList(item, ["thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
    );
  }

  static AlbumDetailed parseHomeSection(dynamic item) {
    final artist = traverse(item, ["subtitle", "runs"]).last;

    return AlbumDetailed(
      type: "ALBUM",
      albumId: traverseString(item, ["title", "browseId"]) ?? '',
      playlistId:
          traverseString(item, ["thumbnailOverlay", "playlistId"]) ?? '',
      name: traverseString(item, ["title", "text"]) ?? '',
      artist: ArtistBasic(
        name: traverseString(artist, ["text"]) ?? '',
        artistId: traverseString(artist, ["browseId"]) ?? '',
      ),
      year: null,
      thumbnails: traverseList(item, ["thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
    );
  }

  static int? processYear(String? year) {
    return year != null && RegExp(r"^\d{4}$").hasMatch(year)
        ? int.parse(year)
        : null;
  }
}
