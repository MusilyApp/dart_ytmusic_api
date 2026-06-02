import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dart_ytmusic_api/enums.dart';
import 'package:dart_ytmusic_api/parsers/album_parser.dart';
import 'package:dart_ytmusic_api/parsers/artist_parser.dart';
import 'package:dart_ytmusic_api/parsers/parser.dart';
import 'package:dart_ytmusic_api/parsers/playlist_parser.dart';
import 'package:dart_ytmusic_api/parsers/search_parser.dart';
import 'package:dart_ytmusic_api/parsers/song_parser.dart';
import 'package:dart_ytmusic_api/parsers/video_parser.dart';
import 'package:dart_ytmusic_api/types.dart';
import 'package:dart_ytmusic_api/utils/traverse.dart';
import 'package:http/http.dart' as http;

class YTMusic {
  static final YTMusic _instance = YTMusic._internal();

  factory YTMusic() {
    return _instance;
  }

  YTMusic._internal() {
    cookieJar = CookieJar();
    config = {};
    _client = http.Client();
    _baseHeaders = {
      "User-Agent":
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36",
      "Accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
      "Accept-Language": "en-US,en;q=0.9",
    };
  }

  late CookieJar cookieJar;
  late Map<String, String> config;
  late http.Client _client;
  late Map<String, String> _baseHeaders;
  bool hasInitialized = false;
  String? ytMusicHomeRawHtml;

  /// Initializes the YTMusic instance with provided cookies, geolocation, and language.
  Future<YTMusic> initialize({
    String? cookies,
    String? gl,
    String? hl,
    String? ytMusicHomeRawHtml,
  }) async {
    // Start initialization

    if (hasInitialized) {
      return this;
    }

    // Accept optional pre-fetched HTML
    this.ytMusicHomeRawHtml = ytMusicHomeRawHtml;
    if (ytMusicHomeRawHtml != null) {}

    // Process incoming cookies string if provided
    if (cookies != null) {
      for (final cookieString in cookies.split('; ')) {
        try {
          final cookie = Cookie.fromSetCookieValue(cookieString);
          cookieJar.saveFromResponse(
            Uri.parse('https://www.youtube.com/'),
            [cookie],
          );
        } catch (e) {
          //
        }
      }
    } else {}

    // Fetch configuration from YouTube Music homepage (or provided HTML)
    await fetchConfig();

    // Override GL/HL if user supplied them explicitly
    if (gl != null) {
      config['GL'] = gl;
    }
    if (hl != null) {
      config['HL'] = hl;
    }

    hasInitialized = true;

    return this;
  }

  /// Fetches the configuration data required for API requests.
  Future<void> fetchConfig() async {
    late final String html;
    final uri = Uri.parse("https://music.youtube.com/");
    if (ytMusicHomeRawHtml != null) {
      html = ytMusicHomeRawHtml!;
    } else {
      final cookies = await cookieJar.loadForRequest(uri);
      final cookieString =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
      final headers = {..._baseHeaders};
      if (cookieString.isNotEmpty) {
        headers['cookie'] = cookieString;
      }
      final response = await _client.get(uri, headers: headers);

      _saveCookiesFromHeaders(uri, response.headers);
      html = response.body;
    }

    if (html.contains('not optimized for your browser')) {
      print('Browser compatibility error in HTML response');
      throw Exception('Browser compatibility error detected');
    }
    config['VISITOR_DATA'] = _extractValue(html, r'"VISITOR_DATA":"(.*?)"');
    config['INNERTUBE_CONTEXT_CLIENT_NAME'] = _extractValue(
        html, r'"INNERTUBE_CONTEXT_CLIENT_NAME":\s*(-?\d+|\"(.*?)\")');
    config['INNERTUBE_CLIENT_VERSION'] =
        _extractValue(html, r'"INNERTUBE_CLIENT_VERSION":"(.*?)"');
    config['DEVICE'] = _extractValue(html, r'"DEVICE":"(.*?)"');
    config['PAGE_CL'] = _extractValue(html, r'"PAGE_CL":\s*(-?\d+|\"(.*?)\")');
    config['PAGE_BUILD_LABEL'] =
        _extractValue(html, r'"PAGE_BUILD_LABEL":"(.*?)"');
    config['INNERTUBE_API_KEY'] =
        _extractValue(html, r'"INNERTUBE_API_KEY":"(.*?)"');
    config['INNERTUBE_API_VERSION'] =
        _extractValue(html, r'"INNERTUBE_API_VERSION":"(.*?)"');
    config['INNERTUBE_CLIENT_NAME'] =
        _extractValue(html, r'"INNERTUBE_CLIENT_NAME":"(.*?)"');
    config['GL'] = _extractValue(html, r'"GL":"(.*?)"');
    config['HL'] = _extractValue(html, r'"HL":"(.*?)"');
  }

  /// Extracts a value from HTML using a regular expression.
  String _extractValue(String html, String regex) {
    final match = RegExp(regex).firstMatch(html);
    return match != null ? match.group(1)! : '';
  }

  /// Constructs and performs an API request to the specified endpoint with optional body and query parameters.
  Future<dynamic> constructRequest(
    String endpoint, {
    Map<String, dynamic> body = const {},
    Map<String, String> query = const {},
    ClientRequestOptions? options,
  }) async {
    final baseUrl = "https://music.youtube.com/";
    final fullQuery = {
      ...query,
      "alt": "json",
      "key": config['INNERTUBE_API_KEY'],
    };

    final uri = Uri.parse(baseUrl).replace(
      path: "youtubei/${config['INNERTUBE_API_VERSION']}/$endpoint",
      queryParameters: fullQuery,
    );

    final cookies = await cookieJar.loadForRequest(uri);
    final cookieString =
        cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

    final headers = <String, String>{
      ..._baseHeaders,
      "x-origin": baseUrl,
      "X-Goog-Visitor-Id": config['VISITOR_DATA'] ?? "",
      "X-YouTube-Client-Name": config['INNERTUBE_CONTEXT_CLIENT_NAME'] ?? '',
      "X-YouTube-Client-Version": config['INNERTUBE_CLIENT_VERSION'] ?? '',
      "X-YouTube-Device": config['DEVICE'] ?? '',
      "X-YouTube-Page-CL": config['PAGE_CL'] ?? '',
      "X-YouTube-Page-Label": config['PAGE_BUILD_LABEL'] ?? '',
      "X-YouTube-Utc-Offset":
          (-DateTime.now().timeZoneOffset.inMinutes).toString(),
      "Content-Type": "application/json",
    };

    if (cookieString.isNotEmpty) {
      headers['cookie'] = cookieString;
    }

    final requestBody = {
      "context": {
        "capabilities": {},
        "client": {
          "clientName": options?.clientName ?? config['INNERTUBE_CLIENT_NAME'],
          "clientVersion":
              options?.clientVersion ?? config['INNERTUBE_CLIENT_VERSION'],
          "experimentIds": [],
          "experimentsToken": "",
          "gl": config['GL'],
          "hl": config['HL'],
          "locationInfo": {
            "locationPermissionAuthorizationStatus":
                "LOCATION_PERMISSION_AUTHORIZATION_STATUS_UNSUPPORTED",
          },
          "musicAppInfo": {
            "musicActivityMasterSwitch":
                "MUSIC_ACTIVITY_MASTER_SWITCH_INDETERMINATE",
            "musicLocationMasterSwitch":
                "MUSIC_LOCATION_MASTER_SWITCH_INDETERMINATE",
            "pwaInstallabilityStatus": "PWA_INSTALLABILITY_STATUS_UNKNOWN",
          },
          "utcOffsetMinutes": -DateTime.now().timeZoneOffset.inMinutes,
        },
        "request": {
          "internalExperimentFlags": [
            {
              "key": "force_music_enable_outertube_tastebuilder_browse",
              "value": "true",
            },
            {
              "key": "force_music_enable_outertube_playlist_detail_browse",
              "value": "true",
            },
            {
              "key": "force_music_enable_outertube_search_suggestions",
              "value": "true",
            },
          ],
          "sessionIndex": {},
        },
        "user": {
          "enableSafetyMode": false,
        },
      },
      ...body,
    };

    try {
      final response = await _client.post(
        uri,
        headers: headers,
        body: json.encode(requestBody),
      );

      _saveCookiesFromHeaders(uri, response.headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception(
            'Failed to make request to $uri - ${response.statusCode} - [${response.body}]');
      }
    } on http.ClientException catch (e) {
      print('HTTP Client Exception during request to $uri: $e');
      rethrow;
    } catch (e) {
      print('Error during request to $uri: $e');
      rethrow;
    }
  }

  void _saveCookiesFromHeaders(Uri uri, Map<String, String> headers) {
    final setCookieHeader = headers['set-cookie'];
    if (setCookieHeader == null) return;
    try {
      final cookie = Cookie.fromSetCookieValue(setCookieHeader);
      cookieJar.saveFromResponse(uri, [cookie]);
    } catch (e) {
      //
    }
  }

  /// Retrieves search suggestions for a given query.
  Future<List<String>> getSearchSuggestions(String query) async {
    final response = await constructRequest("music/get_search_suggestions",
        body: {"input": query});

    return traverseList(response, ["query"]).whereType<String>().toList();
  }

  /// Performs a search for music with the given query and returns a list of search results.
  Future<List<SearchResult>> search(String query) async {
    final searchData = await constructRequest(
      "search",
      body: {"query": query, "params": null},
    );

    return traverseList(searchData, ["musicResponsiveListItemRenderer"])
        .map(SearchParser.parse)
        .where((e) => e != null)
        .cast<SearchResult>()
        .toList();
  }

  /// Performs a search specifically for songs with the given query and returns a list of song details.
  Future<List<SongDetailed>> searchSongs(String query) async {
    final searchData = await constructRequest(
      "search",
      body: {
        "query": query,
        "params": "Eg-KAQwIARAAGAAgACgAMABqChAEEAMQCRAFEAo%3D"
      },
    );

    final results =
        traverseList(searchData, ["musicResponsiveListItemRenderer"]);
    final mappedResults = results.map(SongParser.parseSearchResult).toList();

    return mappedResults;
  }

  /// Performs a search specifically for videos with the given query and returns a list of video details.
  Future<List<VideoDetailed>> searchVideos(String query) async {
    final searchData = await constructRequest(
      "search",
      body: {
        "query": query,
        "params": "Eg-KAQwIABABGAAgACgAMABqChAEEAMQCRAFEAo%3D"
      },
    );

    return traverseList(searchData, ["musicResponsiveListItemRenderer"])
        .map(VideoParser.parseSearchResult)
        .toList();
  }

  /// Performs a search specifically for artists with the given query and returns a list of artist details.
  Future<List<ArtistDetailed>> searchArtists(String query) async {
    final searchData = await constructRequest(
      "search",
      body: {
        "query": query,
        "params": "Eg-KAQwIABAAGAAgASgAMABqChAEEAMQCRAFEAo%3D"
      },
    );

    return traverseList(searchData, ["musicResponsiveListItemRenderer"])
        .map(ArtistParser.parseSearchResult)
        .toList();
  }

  /// Performs a search specifically for albums with the given query and returns a list of album details.
  Future<List<AlbumDetailed>> searchAlbums(String query) async {
    final searchData = await constructRequest(
      "search",
      body: {
        "query": query,
        "params": "Eg-KAQwIABAAGAEgACgAMABqChAEEAMQCRAFEAo%3D"
      },
    );

    return traverseList(searchData, ["musicResponsiveListItemRenderer"])
        .map(AlbumParser.parseSearchResult)
        .toList();
  }

  /// Performs a search specifically for playlists with the given query and returns a list of playlist details.
  Future<List<PlaylistDetailed>> searchPlaylists(String query) async {
    final searchData = await constructRequest(
      "search",
      body: {
        "query": query,
        "params": "Eg-KAQwIABAAGAAgACgBMABqChAEEAMQCRAFEAo%3D"
      },
    );

    return traverseList(searchData, ["musicResponsiveListItemRenderer"])
        .map(PlaylistParser.parseSearchResult)
        .toList();
  }

  /// Retrieves detailed information about a song given its video ID.
  Future<SongFull> getSong(String videoId) async {
    if (!RegExp(r"^[a-zA-Z0-9-_]{11}$").hasMatch(videoId)) {
      throw Exception("Invalid videoId");
    }

    final data = await constructRequest("player", body: {"videoId": videoId});

    final song = SongParser.parse(data);
    if (song.videoId != videoId) {
      throw Exception("Invalid videoId");
    }
    return song;
  }

  /// Retrieves a list of up next songs for a given video ID.
  Future<List<UpNextsDetails>> getUpNexts(String videoId) async {
    if (!RegExp(r"^[a-zA-Z0-9-_]{11}$").hasMatch(videoId)) {
      throw Exception("Invalid videoId");
    }

    final data = await constructRequest("next", body: {
      "videoId": videoId,
      "playlistId": "RDAMVM$videoId",
      "isAudioOnly": true,
    });

    final tabs = data?['contents']?['singleColumnMusicWatchNextResultsRenderer']
                ?['tabbedRenderer']?['watchNextTabbedResultsRenderer']?['tabs']
            ?[0]?['tabRenderer']?['content']?['musicQueueRenderer']?['content']
        ?['playlistPanelRenderer']?['contents'];

    if (tabs == null) {
      throw Exception("Invalid response structure");
    }

    final List<dynamic> tabsList = tabs is List ? tabs : [];

    return tabsList.skip(1).map((item) {
      final renderer = item['playlistPanelVideoRenderer'];
      final videoId = renderer['videoId'] ?? '';
      final title = renderer['title']?['runs']?[0]?['text'] ?? '';

      // Parse artist information from longBylineText
      final longBylineRuns = renderer['longBylineText']?['runs'];
      final artistName = longBylineRuns?[0]?['text'] ?? '';
      final artistId = longBylineRuns?[0]?['navigationEndpoint']
          ?['browseEndpoint']?['browseId'];

      // Parse album information (usually at index 2 in longBylineText.runs)
      AlbumBasic? album;
      if (longBylineRuns != null && longBylineRuns.length > 2) {
        final albumName = longBylineRuns[2]?['text'];
        final albumId = longBylineRuns[2]?['navigationEndpoint']
            ?['browseEndpoint']?['browseId'];
        if (albumName != null && albumId != null) {
          album = AlbumBasic(
            name: albumName,
            albumId: albumId,
          );
        }
      }

      // Parse duration
      final durationText = renderer['lengthText']?['runs']?[0]?['text'];
      final duration = Parser.parseDuration(durationText) ?? 0;

      // Parse thumbnails
      final thumbnailsList = renderer['thumbnail']?['thumbnails'];
      final thumbnails = thumbnailsList is List
          ? thumbnailsList.map((item) => ThumbnailFull.fromMap(item)).toList()
          : <ThumbnailFull>[];

      return UpNextsDetails(
        type: "SONG",
        videoId: videoId,
        title: title,
        artists: ArtistBasic(
          name: artistName,
          artistId: artistId,
        ),
        album: album,
        duration: duration,
        thumbnails: thumbnails,
      );
    }).toList();
  }

  /// Retrieves detailed information about a video given its video ID.
  Future<VideoFull> getVideo(String videoId) async {
    if (!RegExp(r"^[a-zA-Z0-9-_]{11}$").hasMatch(videoId)) {
      throw Exception("Invalid videoId");
    }

    final data = await constructRequest("player", body: {"videoId": videoId});

    final video = VideoParser.parse(data);
    if (video.videoId != videoId) {
      throw Exception("Invalid videoId");
    }
    return video;
  }

  /// Retrieves the lyrics of a song given its video ID.
  Future<String?> getLyrics(String videoId) async {
    if (!RegExp(r"^[a-zA-Z0-9-_]{11}$").hasMatch(videoId)) {
      throw Exception("Invalid videoId");
    }

    final data = await constructRequest("next", body: {"videoId": videoId});
    final browseId =
        traverse(traverseList(data, ["tabs", "tabRenderer"])[1], ["browseId"]);

    final lyricsData =
        await constructRequest("browse", body: {"browseId": browseId});
    final lyrics =
        traverseString(lyricsData, ["description", "runs", "text"])?.trim();

    return lyrics
        ?.replaceAll("\r", "")
        .split("\n")
        .where((element) => element.isNotEmpty)
        .join("\n");
  }

  Future<TimedLyricsRes?> getTimedLyrics(String videoId) async {
    if (!RegExp(r"^[a-zA-Z0-9-_]{11}$").hasMatch(videoId)) {
      throw Exception("Invalid videoId");
    }

    final data = await constructRequest("next", body: {"videoId": videoId});
    final browseId =
        traverse(traverseList(data, ["tabs", "tabRenderer"])[1], ["browseId"]);

    final lyricsData = await constructRequest(
      "browse",
      body: {"browseId": browseId},
      options: ClientRequestOptions(
          clientName: androidClientName, clientVersion: androidClientVersion),
    );

    final timedLyrics =
        traverse(lyricsData, ['contents', 'type', 'lyricsData']);

    if (timedLyrics == null) {
      return null;
    }

    if (timedLyrics is List) {
      return null;
    }

    return TimedLyricsRes.fromMap(timedLyrics);
  }

  /// Retrieves detailed information about an artist given its artist ID.
  Future<ArtistFull> getArtist(String artistId) async {
    final data = await constructRequest("browse", body: {"browseId": artistId});

    return ArtistParser.parse(data, artistId);
  }

  /// Retrieves a list of songs by a specific artist given the artist's ID.
  Future<List<SongDetailed>> getArtistSongs(String artistId) async {
    final artistData =
        await constructRequest("browse", body: {"browseId": artistId});
    final browseToken =
        traverse(artistData, ["musicShelfRenderer", "title", "browseId"]);

    if (browseToken is List) {
      return [];
    }

    final songsData =
        await constructRequest("browse", body: {"browseId": browseToken});
    final continueToken = traverse(songsData, ["continuation"]);
    late final Map moreSongsData;

    if (continueToken is String) {
      moreSongsData = await constructRequest(
        "browse",
        query: {"continuation": continueToken},
      );
    } else {
      moreSongsData = {};
    }

    return [
      ...traverseList(songsData, ["musicResponsiveListItemRenderer"]),
      ...traverseList(moreSongsData, ["musicResponsiveListItemRenderer"]),
    ]
        .map((s) => SongParser.parseArtistSong(
              s,
              ArtistBasic(
                artistId: artistId,
                name: traverseString(artistData, ["header", "title", "text"]) ??
                    '',
              ),
            ))
        .toList();
  }

  /// Retrieves a list of albums by a specific artist given the artist's ID.
  Future<List<AlbumDetailed>> getArtistAlbums(String artistId) async {
    final artistData =
        await constructRequest("browse", body: {"browseId": artistId});
    final artistAlbumsData =
        traverseList(artistData, ["musicCarouselShelfRenderer"])[0];
    final browseBody =
        traverse(artistAlbumsData, ["moreContentButton", "browseEndpoint"]);
    if (browseBody is List) {
      return [];
    }
    final albumsData = await constructRequest(
      "browse",
      body: browseBody is List ? {} : browseBody,
    );

    return [
      ...traverseList(albumsData, ["musicTwoRowItemRenderer"])
          .map(
            (item) => AlbumParser.parseArtistAlbum(
              item,
              ArtistBasic(
                artistId: artistId,
                name: traverseString(albumsData, ["header", "runs", "text"]) ??
                    '',
              ),
            ),
          )
          .where(
            (album) => album.artist.artistId == artistId,
          ),
    ];
  }

  Future<List<AlbumDetailed>> getArtistSingles(String artistId) async {
    final artistData =
        await constructRequest("browse", body: {"browseId": artistId});

    final artistSinglesData =
        traverseList(artistData, ["musicCarouselShelfRenderer"]).length < 2
            ? []
            : traverseList(artistData, ["musicCarouselShelfRenderer"])
                .elementAt(1);

    final browseBody =
        traverse(artistSinglesData, ["moreContentButton", "browseEndpoint"]);
    if (browseBody is List) {
      return [];
    }

    final singlesData = await constructRequest(
      "browse",
      body: browseBody is List ? {} : browseBody,
    );

    return [
      ...traverseList(singlesData, ["musicTwoRowItemRenderer"])
          .map(
            (item) => AlbumParser.parseArtistAlbum(
              item,
              ArtistBasic(
                artistId: artistId,
                name: traverseString(singlesData, ["header", "runs", "text"]) ??
                    '',
              ),
            ),
          )
          .where(
            (album) => album.artist.artistId == artistId,
          ),
    ];
  }

  /// Retrieves detailed information about an album given its album ID.
  Future<AlbumFull> getAlbum(String albumId) async {
    final data = await constructRequest("browse", body: {"browseId": albumId});

    final album = AlbumParser.parse(data, albumId);

    final artistSongs = await getArtistSongs(album.artist.artistId ?? '');
    final filteredSongs = artistSongs.where(
      (song) => album.songs
          .where((item) =>
              '${song.album?.name}-${song.name}' ==
              '${item.album?.name}-${item.name}')
          .isNotEmpty,
    );

    final songsThatArentInArtist = album.songs.where(
      (item) => artistSongs
          .where((song) =>
              '${song.album?.name}-${song.name}' ==
              '${item.album?.name}-${item.name}')
          .isEmpty,
    );

    return album..songs = [...filteredSongs, ...songsThatArentInArtist];
  }

  /// Retrieves detailed information about a playlist given its playlist ID.
  Future<PlaylistFull> getPlaylist(String playlistId) async {
    if (playlistId.startsWith("PL")) {
      playlistId = "VL$playlistId";
    }

    final data =
        await constructRequest("browse", body: {"browseId": playlistId});

    return PlaylistParser.parse(data, playlistId);
  }

  /// Retrieves a list of videos from a playlist given its playlist ID.
  Future<List<VideoDetailed>> getPlaylistVideos(String playlistId) async {
    if (playlistId.startsWith("PL")) {
      playlistId = "VL$playlistId";
    }

    final playlistData =
        await constructRequest("browse", body: {"browseId": playlistId});

    final songs = traverseList(
      playlistData,
      ["musicPlaylistShelfRenderer", "musicResponsiveListItemRenderer"],
    );
    dynamic continuation = traverse(playlistData, ["continuation"]);
    if (continuation is List && (continuation).isNotEmpty) {
      continuation = continuation[0];
    }
    while (continuation is! List) {
      final songsData = await constructRequest(
        "browse",
        query: {"continuation": continuation},
      );
      songs
          .addAll(traverseList(songsData, ["musicResponsiveListItemRenderer"]));
      continuation = traverse(songsData, ["continuation"]);
    }

    return songs
        .map(VideoParser.parsePlaylistVideo)
        .whereType<VideoDetailed>()
        .toList();
  }

  /// Retrieves the home sections of the music platform.
  Future<List<HomeSection>> getHomeSections() async {
    final data =
        await constructRequest("browse", body: {"browseId": feMusicHome});

    final sections = traverseList(data, ["sectionListRenderer", "contents"]);
    dynamic continuation = traverseString(data, ["continuation"]);
    while (continuation != null) {
      final data = await constructRequest("browse",
          query: {"continuation": continuation});
      sections
          .addAll(traverseList(data, ["sectionListContinuation", "contents"]));
      continuation = traverseString(data, ["continuation"]);
    }

    return sections.map(Parser.parseHomeSection).toList();
  }
}
