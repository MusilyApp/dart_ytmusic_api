import 'package:dart_ytmusic_api/yt_music.dart';

void main() async {
  // Create an instance of the YouTube Music API
  final ytmusic = YTMusic();

  // Initialize the API
  await ytmusic.initialize();

  await searchSongs(ytmusic);
}

// Search Methods
/// Searches for search suggestions by the given query and prints the results.
Future<void> getSearchSuggestions(YTMusic ytmusic) async {
  final results = await ytmusic.getSearchSuggestions('The Sco');
  for (final suggestion in results) {
    print(suggestion);
  }
}

/// Searches for songs by the given query and prints the results.
Future<void> searchSongs(YTMusic ytmusic) async {
  final results = await ytmusic.searchSongs('Aurora Runaway');
  for (final result in results) {
    print(
        '${result.name} - ${result.artist.name} (${result.artist.artistId}) - ${result.videoId}');
  }
}

/// Searches for albums by the given query and prints the results.
Future<void> searchAlbums(YTMusic ytmusic) async {
  final results = await ytmusic.searchAlbums('bastille');
  for (final result in results) {
    print('${result.name} - ${result.artist.name} - ${result.albumId}');
  }
}

/// Searches for artists by the given query and prints the results.
Future<void> searchArtists(YTMusic ytmusic) async {
  final results = await ytmusic.searchArtists('Aurora');
  for (final result in results) {
    print('${result.name} - ${result.artistId}');
  }
}

/// Searches for videos by the given query and prints the results.
Future<void> searchVideos(YTMusic ytmusic) async {
  final results = await ytmusic.searchVideos('Aurora Runaway');
  for (final result in results) {
    print('${result.name} - ${result.videoId}');
  }
}

/// Searches for playlists by the given query and prints the results.
Future<void> searchPlaylists(YTMusic ytmusic) async {
  final results = await ytmusic.searchPlaylists('Global Songs');
  for (final result in results) {
    print('${result.name} - ${result.playlistId}');
  }
}

// Specific Data Retrieval Methods
/// Retrieves details of a song by its ID and prints the result.
Future<void> getSong(YTMusic ytmusic) async {
  final result = await ytmusic.getSong('LDY4Bf8Zwn8');
  print('${result.name} - ${result.videoId}');
}

/// Retrieves details of a video by its ID and prints the result.
Future<void> getVideo(YTMusic ytmusic) async {
  final result = await ytmusic.getVideo('LDY4Bf8Zwn8');
  print('${result.name} - ${result.artist.artistId}');
}

/// Retrieves lyrics of a song by its video ID and prints the result.
Future<void> getLyrics(YTMusic ytmusic) async {
  final result = await ytmusic.getLyrics('LDY4Bf8Zwn8');
  print('$result');
}

/// Retrieves albums of an artist by the artist's ID and prints the results.
Future<void> getArtistAlbums(YTMusic ytmusic) async {
  // The Score - UCdQICt_YIo4FEOaLtTOi4RA
  // Aurora - UC4G-AJa7kn8oumI6TT2WXYw
  final results = await ytmusic.getArtistAlbums('UC4G-AJa7kn8oumI6TT2WXYw');
  for (final result in results) {
    print('${result.name} - ${result.artist.artistId}');
  }
}

Future<void> getArtistSingles(YTMusic ytmusic) async {
  // The Score - UCdQICt_YIo4FEOaLtTOi4RA
  // Aurora - UC4G-AJa7kn8oumI6TT2WXYw
  final results = await ytmusic.getArtistSingles('UC4G-AJa7kn8oumI6TT2WXYw');
  for (final result in results) {
    print('${result.name} - ${result.artist.artistId}');
  }
}

/// Retrieves videos of a playlist by the playlist's ID and prints the results.
Future<void> getPlaylistVideos(YTMusic ytmusic) async {
  final results = await ytmusic
      .getPlaylistVideos('RDCLAK5uy_nfs_t4FUu00E5ED6lveEBBX1VMYe1mFjk');
  for (final result in results) {
    print('${result.name} - ${result.videoId}');
  }
}

/// Retrieves details of an album by its ID and prints the result.
Future<void> getAlbum(YTMusic ytmusic) async {
  final result = await ytmusic.getAlbum('UC4G-AJa7kn8oumI6TT2WXYw');
  print('${result.name} - ${result.artist.name}');
}

/// Retrieves details of an artist by their ID and prints the result.
Future<void> getArtist(YTMusic ytmusic) async {
  final result = await ytmusic.getArtist('UC4G-AJa7kn8oumI6TT2WXYw');
  print('${result.name} - ${result.artistId}');
}

Future<void> getArtistSongs(YTMusic ytmusic) async {
  final songs = await ytmusic.getArtistSongs('UCdQICt_YIo4FEOaLtTOi4RA');
  for (final song in songs) {
    print('${song.name} - ${song.artist.artistId}');
  }
}

// General Data Retrieval Methods
/// Retrieves home sections and prints the results.
Future<void> getHomeSections(YTMusic ytmusic) async {
  final results = await ytmusic.getHomeSections();
  for (final result in results) {
    print('${result.title} - ${result.contents}');
  }
}
