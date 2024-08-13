# Dart YouTube Music API

This package allows you to interact with YouTube Music data in Dart. You can search for songs, albums, artists, and playlists, retrieve detailed information, and get suggestions.

> **Note:** This package is ported from [ts-npm-ytmusic-api](https://github.com/zS1L3NT/ts-npm-ytmusic-api). Credits to the original author.

## Getting Started

### Installation

You can install the package in your Dart project using the following methods:

#### 1. Using `flutter pub` (for Flutter projects)

```bash
flutter pub add dart_ytmusic_api
```

#### 2. Using `dart pub` (for general Dart projects)

```bash
dart pub add dart_ytmusic_api
```

#### 3. Modifying `pubspec.yaml`

Add the following line to your `pubspec.yaml` file under the `dependencies` section:

```yaml
dependencies:
  dart_ytmusic_api: ^1.0.0
```

Then, run `flutter pub get` (for Flutter projects) or `dart pub get` (for general Dart projects) to install the package.

### Usage
Here's a basic example of how to use the YouTube Music API in Dart:

```dart
import 'package:dart_ytmusic_api/yt_music.dart';

void main() async {
  // Create an instance of the YouTube Music API
  final ytmusic = YTMusic();

  // Initialize the API
  await ytmusic.initialize();

  // There's how you can use a method
  final albumResults = await ytmusic.searchAlbums();
}
```

## API Methods

The following methods are available in the `YTMusic` class:

**Initialization**

- `initialize(cookies: String, gl: String, hl: String)`: Initializes the API with the provided cookies, geolocation, and language.

**Search**

- `getSearchSuggestions(query: String)`: Retrieves search suggestions for a given query.
- `search(query: String)`: Performs a general search for music with the given query.
- `searchSongs(query: String)`: Performs a search specifically for songs.
- `searchVideos(query: String)`: Performs a search specifically for videos.
- `searchArtists(query: String)`: Performs a search specifically for artists.
- `searchAlbums(query: String)`: Performs a search specifically for albums.
- `searchPlaylists(query: String)`: Performs a search specifically for playlists.

**Retrieve Details**

- `getSong(videoId: String)`: Retrieves detailed information about a song given its video ID.
- `getVideo(videoId: String)`: Retrieves detailed information about a video given its video ID.
- `getLyrics(videoId: String)`: Retrieves the lyrics of a song given its video ID.
- `getArtist(artistId: String)`: Retrieves detailed information about an artist given its artist ID.
- `getAlbum(albumId: String)`: Retrieves detailed information about an album given its album ID.
- `getPlaylist(playlistId: String)`: Retrieves detailed information about a playlist given its playlist ID.

**Artist Methods**

- `getArtistSongs(artistId: String)`: Retrieves a list of songs by a specific artist.
- `getArtistAlbums(artistId: String)`: Retrieves a list of albums by a specific artist.
- `getArtistSingles(artistId: String)`: Retrieves a list of singles by a specific artist.

**Playlist Methods**

- `getPlaylistVideos(playlistId: String)`: Retrieves a list of videos from a playlist given its playlist ID.

**Home Section**

- `getHomeSections()`: Retrieves the home sections of the music platform.

## Contributing

Contributions are welcome! Please feel free to open issues, submit pull requests, or reach out if you have any questions.

## License

This project is licensed under the GNU General Public License version 3. See the [LICENSE](LICENSE) file for details.
