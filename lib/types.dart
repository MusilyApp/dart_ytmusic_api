class ThumbnailFull {
  final String url;
  final int width;
  final int height;

  ThumbnailFull({
    required this.url,
    required this.width,
    required this.height,
  });

  // Construtor nomeado para criar uma ThumbnailFull a partir de um mapa
  ThumbnailFull.fromMap(Map<String, dynamic> map)
      : url = map['url'] as String,
        width = map['width'] as int,
        height = map['height'] as int;
}

class ArtistBasic {
  final String? artistId;
  final String name;

  ArtistBasic({
    this.artistId,
    required this.name,
  });

  // Construtor nomeado para criar uma ArtistBasic a partir de um mapa
  ArtistBasic.fromMap(Map<String, dynamic> map)
      : artistId = map['artistId'] as String?,
        name = map['name'] as String;
}

class AlbumBasic {
  final String albumId;
  final String name;

  AlbumBasic({
    required this.albumId,
    required this.name,
  });

  // Construtor nomeado para criar uma AlbumBasic a partir de um mapa
  AlbumBasic.fromMap(Map<String, dynamic> map)
      : albumId = map['albumId'] as String,
        name = map['name'] as String;
}

class SongDetailed {
  final String type;
  final String videoId;
  final String name;
  final ArtistBasic artist;
  final AlbumBasic? album;
  final int? duration;
  final List<ThumbnailFull> thumbnails;

  SongDetailed({
    required this.type,
    required this.videoId,
    required this.name,
    required this.artist,
    this.album,
    this.duration,
    required this.thumbnails,
  });

  // Construtor nomeado para criar uma SongDetailed a partir de um mapa
  SongDetailed.fromMap(Map<String, dynamic> map)
      : type = map['type'] as String,
        videoId = map['videoId'] as String,
        name = map['name'] as String,
        artist = ArtistBasic.fromMap(map['artist']),
        album = map['album'] != null ? AlbumBasic.fromMap(map['album']) : null,
        duration = map['duration'] as int?,
        thumbnails = (map['thumbnails'] as List)
            .map((item) => ThumbnailFull.fromMap(item))
            .toList();
}

class VideoDetailed {
  final String type;
  final String videoId;
  final String name;
  final ArtistBasic artist;
  final int? duration;
  final List<ThumbnailFull> thumbnails;

  VideoDetailed({
    required this.type,
    required this.videoId,
    required this.name,
    required this.artist,
    this.duration,
    required this.thumbnails,
  });

  // Construtor nomeado para criar uma VideoDetailed a partir de um mapa
  VideoDetailed.fromMap(Map<String, dynamic> map)
      : type = map['type'] as String,
        videoId = map['videoId'] as String,
        name = map['name'] as String,
        artist = ArtistBasic.fromMap(map['artist']),
        duration = map['duration'] as int?,
        thumbnails = (map['thumbnails'] as List)
            .map((item) => ThumbnailFull.fromMap(item))
            .toList();
}

class ArtistDetailed {
  final String artistId;
  final String name;
  final String type;
  final List<ThumbnailFull> thumbnails;

  ArtistDetailed({
    required this.artistId,
    required this.name,
    required this.type,
    required this.thumbnails,
  });

  // Construtor nomeado para criar uma ArtistDetailed a partir de um mapa
  ArtistDetailed.fromMap(Map<String, dynamic> map)
      : artistId = map['artistId'] as String,
        name = map['name'] as String,
        type = map['type'] as String,
        thumbnails = (map['thumbnails'] as List)
            .map((item) => ThumbnailFull.fromMap(item))
            .toList();
}

class AlbumDetailed {
  final String type;
  final String albumId;
  final String playlistId;
  final String name;
  final ArtistBasic artist;
  final int? year;
  final List<ThumbnailFull> thumbnails;

  AlbumDetailed({
    required this.type,
    required this.albumId,
    required this.playlistId,
    required this.name,
    required this.artist,
    this.year,
    required this.thumbnails,
  });

  // Construtor nomeado para criar uma AlbumDetailed a partir de um mapa
  AlbumDetailed.fromMap(Map<String, dynamic> map)
      : type = map['type'] as String,
        albumId = map['albumId'] as String,
        playlistId = map['playlistId'] as String,
        name = map['name'] as String,
        artist = ArtistBasic.fromMap(map['artist']),
        year = map['year'] as int?,
        thumbnails = (map['thumbnails'] as List)
            .map((item) => ThumbnailFull.fromMap(item))
            .toList();
}

class PlaylistDetailed {
  final String type;
  final String playlistId;
  final String name;
  final ArtistBasic artist;
  final List<ThumbnailFull> thumbnails;

  PlaylistDetailed({
    required this.type,
    required this.playlistId,
    required this.name,
    required this.artist,
    required this.thumbnails,
  });

  // Construtor nomeado para criar uma PlaylistDetailed a partir de um mapa
  PlaylistDetailed.fromMap(Map<String, dynamic> map)
      : type = map['type'] as String,
        playlistId = map['playlistId'] as String,
        name = map['name'] as String,
        artist = ArtistBasic.fromMap(map['artist']),
        thumbnails = (map['thumbnails'] as List)
            .map((item) => ThumbnailFull.fromMap(item))
            .toList();
}

class SongFull {
  final String type;
  final String videoId;
  final String name;
  final ArtistBasic artist;
  final int duration;
  final List<ThumbnailFull> thumbnails;
  final List<dynamic> formats;
  final List<dynamic> adaptiveFormats;

  SongFull({
    required this.type,
    required this.videoId,
    required this.name,
    required this.artist,
    required this.duration,
    required this.thumbnails,
    required this.formats,
    required this.adaptiveFormats,
  });

  // Construtor nomeado para criar uma SongFull a partir de um mapa
  SongFull.fromMap(Map<String, dynamic> map)
      : type = map['type'] as String,
        videoId = map['videoId'] as String,
        name = map['name'] as String,
        artist = ArtistBasic.fromMap(map['artist']),
        duration = map['duration'] as int,
        thumbnails = (map['thumbnails'] as List)
            .map((item) => ThumbnailFull.fromMap(item))
            .toList(),
        formats = map['formats'] as List<dynamic>,
        adaptiveFormats = map['adaptiveFormats'] as List<dynamic>;
}

class VideoFull {
  final String type;
  final String videoId;
  final String name;
  final ArtistBasic artist;
  final int duration;
  final List<ThumbnailFull> thumbnails;
  final bool unlisted;
  final bool familySafe;
  final bool paid;
  final List<String> tags;

  VideoFull({
    required this.type,
    required this.videoId,
    required this.name,
    required this.artist,
    required this.duration,
    required this.thumbnails,
    required this.unlisted,
    required this.familySafe,
    required this.paid,
    required this.tags,
  });

  // Construtor nomeado para criar uma VideoFull a partir de um mapa
  VideoFull.fromMap(Map<String, dynamic> map)
      : type = map['type'] as String,
        videoId = map['videoId'] as String,
        name = map['name'] as String,
        artist = ArtistBasic.fromMap(map['artist']),
        duration = map['duration'] as int,
        thumbnails = (map['thumbnails'] as List)
            .map((item) => ThumbnailFull.fromMap(item))
            .toList(),
        unlisted = map['unlisted'] as bool,
        familySafe = map['familySafe'] as bool,
        paid = map['paid'] as bool,
        tags = (map['tags'] as List).cast<String>();
}

class ArtistFull {
  final String artistId;
  final String name;
  final String type;
  final List<ThumbnailFull> thumbnails;
  final List<SongDetailed> topSongs;
  final List<AlbumDetailed> topAlbums;
  final List<AlbumDetailed> topSingles;
  final List<VideoDetailed> topVideos;
  final List<PlaylistDetailed> featuredOn;
  final List<ArtistDetailed> similarArtists;

  ArtistFull({
    required this.artistId,
    required this.name,
    required this.type,
    required this.thumbnails,
    required this.topSongs,
    required this.topAlbums,
    required this.topSingles,
    required this.topVideos,
    required this.featuredOn,
    required this.similarArtists,
  });

  // Construtor nomeado para criar uma ArtistFull a partir de um mapa
  ArtistFull.fromMap(Map<String, dynamic> map)
      : artistId = map['artistId'] as String,
        name = map['name'] as String,
        type = map['type'] as String,
        thumbnails = (map['thumbnails'] as List)
            .map((item) => ThumbnailFull.fromMap(item))
            .toList(),
        topSongs = (map['topSongs'] as List)
            .map((item) => SongDetailed.fromMap(item))
            .toList(),
        topAlbums = (map['topAlbums'] as List)
            .map((item) => AlbumDetailed.fromMap(item))
            .toList(),
        topSingles = (map['topSingles'] as List)
            .map((item) => AlbumDetailed.fromMap(item))
            .toList(),
        topVideos = (map['topVideos'] as List)
            .map((item) => VideoDetailed.fromMap(item))
            .toList(),
        featuredOn = (map['featuredOn'] as List)
            .map((item) => PlaylistDetailed.fromMap(item))
            .toList(),
        similarArtists = (map['similarArtists'] as List)
            .map((item) => ArtistDetailed.fromMap(item))
            .toList();
}

class AlbumFull {
  final String type;
  final String albumId;
  final String playlistId;
  final String name;
  final ArtistBasic artist;
  final int? year;
  final List<ThumbnailFull> thumbnails;
  final List<SongDetailed> songs;

  AlbumFull({
    required this.type,
    required this.albumId,
    required this.playlistId,
    required this.name,
    required this.artist,
    this.year,
    required this.thumbnails,
    required this.songs,
  });

  // Construtor nomeado para criar uma AlbumFull a partir de um mapa
  AlbumFull.fromMap(Map<String, dynamic> map)
      : type = map['type'] as String,
        albumId = map['albumId'] as String,
        playlistId = map['playlistId'] as String,
        name = map['name'] as String,
        artist = ArtistBasic.fromMap(map['artist']),
        year = map['year'] as int?,
        thumbnails = (map['thumbnails'] as List)
            .map((item) => ThumbnailFull.fromMap(item))
            .toList(),
        songs = (map['songs'] as List)
            .map((item) => SongDetailed.fromMap(item))
            .toList();
}

class PlaylistFull {
  final String type;
  final String playlistId;
  final String name;
  final ArtistBasic artist;
  final int videoCount;
  final List<ThumbnailFull> thumbnails;

  PlaylistFull({
    required this.type,
    required this.playlistId,
    required this.name,
    required this.artist,
    required this.videoCount,
    required this.thumbnails,
  });

  // Construtor nomeado para criar uma PlaylistFull a partir de um mapa
  PlaylistFull.fromMap(Map<String, dynamic> map)
      : type = map['type'] as String,
        playlistId = map['playlistId'] as String,
        name = map['name'] as String,
        artist = ArtistBasic.fromMap(map['artist']),
        videoCount = map['videoCount'] as int,
        thumbnails = (map['thumbnails'] as List)
            .map((item) => ThumbnailFull.fromMap(item))
            .toList();
}

// SearchResult é uma union de vários tipos, então é uma interface
abstract class SearchResult {
  String get type;
}

class SongDetailedSearchResult implements SearchResult {
  @override
  final String type = 'SONG';
  final SongDetailed songDetailed;

  SongDetailedSearchResult({
    required this.songDetailed,
  });
}

class VideoDetailedSearchResult implements SearchResult {
  @override
  final String type = 'VIDEO';
  final VideoDetailed videoDetailed;

  VideoDetailedSearchResult({
    required this.videoDetailed,
  });
}

class AlbumDetailedSearchResult implements SearchResult {
  @override
  final String type = 'ALBUM';
  final AlbumDetailed albumDetailed;

  AlbumDetailedSearchResult({
    required this.albumDetailed,
  });
}

class ArtistDetailedSearchResult implements SearchResult {
  @override
  final String type = 'ARTIST';
  final ArtistDetailed artistDetailed;

  ArtistDetailedSearchResult({
    required this.artistDetailed,
  });
}

class PlaylistDetailedSearchResult implements SearchResult {
  @override
  final String type = 'PLAYLIST';
  final PlaylistDetailed playlistDetailed;

  PlaylistDetailedSearchResult({
    required this.playlistDetailed,
  });
}

// Factory para criar um SearchResult a partir de um mapa
SearchResult createSearchResultFromMap(Map<String, dynamic> map) {
  switch (map['type']) {
    case 'SONG':
      return SongDetailedSearchResult(
        songDetailed: SongDetailed.fromMap(map),
      );
    case 'VIDEO':
      return VideoDetailedSearchResult(
        videoDetailed: VideoDetailed.fromMap(map),
      );
    case 'ALBUM':
      return AlbumDetailedSearchResult(
        albumDetailed: AlbumDetailed.fromMap(map),
      );
    case 'ARTIST':
      return ArtistDetailedSearchResult(
        artistDetailed: ArtistDetailed.fromMap(map),
      );
    case 'PLAYLIST':
      return PlaylistDetailedSearchResult(
        playlistDetailed: PlaylistDetailed.fromMap(map),
      );
    default:
      throw ArgumentError('Tipo inválido para SearchResult: ${map['type']}');
  }
}

class HomeSection {
  final String title;
  final List<dynamic> contents;

  HomeSection({
    required this.title,
    required this.contents,
  });

  // Construtor nomeado para criar uma HomeSection a partir de um mapa
  HomeSection.fromMap(Map<String, dynamic> map)
      : title = map['title'] as String,
        contents = map['contents'] as List<dynamic>;
}
