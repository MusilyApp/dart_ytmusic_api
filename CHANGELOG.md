## 1.3.7

**Fix**
- Fixed `searchSongs` and all song parsers returning empty `videoId`: YouTube Music API removed the `playlistItemData` field; now extracting `videoId` via `watchEndpoint`.
- Fixed `getPlaylistVideos` crashing with a type error when expanding `flexColumns`/`fixedColumns` from playlist items.
- Fixed `getPlaylistVideos` crashing with a `RangeError` when a playlist has no continuation token (empty list unwrap guard).
- Fixed `VideoParser.parsePlaylistVideo` using dynamic `.url` and `.text` property access on raw `Map` objects; replaced with proper bracket notation and `traverseString`.

## 1.3.6
**Fix**
- Critical API crash on non-English systems: Resolved a FormatException that prevented the application from working on operating systems with non-English locales (e.g., Portuguese, Spanish). The issue was caused by an invalid timezone format in API request headers.

**Refactor**
- Dependency Migration: Replaced the dio package with the standard http package for all network requests.

## 1.3.5

**Fix**
- Removed package versions from pubspec

## 1.3.4

**Chore**
- Removed unused `intl` dependency.

## 1.3.3

**Fix**
- Fixed `parseDuration` to handle duration strings with extra text/metadata using regex extraction.

## 1.3.2

**Fix**
- Fixed `getUpNexts` to properly parse artist ID from `longBylineText` instead of `shortBylineText`.
- Added album support to `getUpNexts` with optional `AlbumBasic` field.

## 1.3.1

**Fix**
- Fixed `getUpNexts` return type to properly match original implementation with correct data structure (artists as ArtistBasic object, duration as int in seconds, thumbnails as array).

## 1.3.0

**New Feature**
- Added `getUpNexts(String videoId)`: Retrieve suggested up next songs for a given video.

## 1.2.1

**Fix**
- Removed exit(1)

## 1.2.0

**New Feature**
- Added ytMusicHomeRawHtml property to add credentials externally

## 1.1.1

**Fixes**
- Fix exeption when timed lyrics is not found

## 1.1.0

**New Feature**
- getTimedLyrics(String videoId): New method to retrieve timed lyrics for a song. This allows developers to access lyrics synchronized with audio playback times.

## 1.0.8
**Fixes**
- Fix search method: fixed search method returns empty results.

## 1.0.7

- **Fixes**
- Some songs were not found.

## 1.0.6

**Fixes**
- Fixed song duration handler

## 1.0.5

**Fixes**
- Fixed albumParser: Fixed bad element when ids array is empty.
- Fixed artistPaser: Fixed filters to prevent return items where albumId is empty.
- Fixed songParser: Fixed duration parser.

## 1.0.4

- Fixed no songs in some albums

## 1.0.3

- Fixed album songs

## 1.0.2

- Return artist songs instead of album songs in getAlbum to increase lyrics search.

## 1.0.0

- Initial version.
