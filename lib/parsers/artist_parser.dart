import 'package:dart_ytmusic_api/parsers/album_parser.dart';
import 'package:dart_ytmusic_api/parsers/playlist_parser.dart';
import 'package:dart_ytmusic_api/parsers/song_parser.dart';
import 'package:dart_ytmusic_api/parsers/video_parser.dart';
import 'package:dart_ytmusic_api/types.dart';
import 'package:dart_ytmusic_api/utils/traverse.dart';

class ArtistParser {
  static ArtistFull parse(dynamic data, String artistId) {
    final artistBasic = ArtistBasic(
      artistId: artistId,
      name: traverseString(data, ["header", "title", "text"]) ?? '',
    );

    return ArtistFull(
      name: artistBasic.name,
      type: "ARTIST",
      artistId: artistId,
      thumbnails: traverseList(data, ["header", "thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
      topSongs: traverseList(data, ["musicShelfRenderer", "contents"])
          .map((item) => SongParser.parseArtistTopSong(item, artistBasic))
          .toList(),
      topAlbums: (traverseList(data, ["musicCarouselShelfRenderer"]).isEmpty
              ? <AlbumDetailed>[]
              : (traverseList(data, ["musicCarouselShelfRenderer"])
                          .elementAt(0)?['contents'] as List<dynamic>?)
                      ?.map((item) =>
                          AlbumParser.parseArtistTopAlbum(item, artistBasic))
                      .toList() ??
                  <AlbumDetailed>[])
          .where(
            (album) => album.albumId.isNotEmpty,
          )
          .toList(),
      topSingles: (traverseList(data, ["musicCarouselShelfRenderer"]).length < 2
              ? <AlbumDetailed>[]
              : (traverseList(data, ["musicCarouselShelfRenderer"])
                          .elementAt(1)?['contents'] as List<dynamic>?)
                      ?.map((item) =>
                          AlbumParser.parseArtistTopAlbum(item, artistBasic))
                      .toList() ??
                  <AlbumDetailed>[])
          .where(
            (single) =>
                single.albumId.isNotEmpty && single.albumId.startsWith('M'),
          )
          .toList(),
      topVideos: traverseList(data, ["musicCarouselShelfRenderer"]).length < 3
          ? <VideoDetailed>[]
          : (traverseList(data, ["musicCarouselShelfRenderer"])
                      .elementAt(2)?['contents'] as List<dynamic>?)
                  ?.map((item) =>
                      VideoParser.parseArtistTopVideo(item, artistBasic))
                  .toList() ??
              <VideoDetailed>[],
      featuredOn: traverseList(data, ["musicCarouselShelfRenderer"]).length < 4
          ? <PlaylistDetailed>[]
          : (traverseList(data, ["musicCarouselShelfRenderer"])
                      .elementAt(3)?['contents'] as List<dynamic>?)
                  ?.map((item) =>
                      PlaylistParser.parseArtistFeaturedOn(item, artistBasic))
                  .toList() ??
              <PlaylistDetailed>[],
      similarArtists:
          traverseList(data, ["musicCarouselShelfRenderer"]).length < 5
              ? <ArtistDetailed>[]
              : (traverseList(data, ["musicCarouselShelfRenderer"])
                          .elementAt(4)?['contents'] as List<dynamic>?)
                      ?.map((item) => parseSimilarArtists(item))
                      .toList() ??
                  <ArtistDetailed>[],
    );
  }

  static ArtistDetailed parseSearchResult(dynamic item) {
    final columns = traverseList(item, ["flexColumns", "runs"])
        .expand((e) => e is List ? e : [e])
        .toList();

    // No specific way to identify the title
    final title = columns[0];

    return ArtistDetailed(
      type: "ARTIST",
      artistId: traverseString(item, ["browseId"]) ?? '',
      name: traverseString(title, ["text"]) ?? '',
      thumbnails: traverseList(item, ["thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
    );
  }

  static ArtistDetailed parseSimilarArtists(dynamic item) {
    return ArtistDetailed(
      type: "ARTIST",
      artistId: traverseString(item, ["browseId"]) ?? '',
      name: traverseString(item, ["runs", "text"]) ?? '',
      thumbnails: traverseList(item, ["thumbnails"])
          .map((item) => ThumbnailFull.fromMap(item))
          .toList(),
    );
  }
}
