enum PageType {
  musicPageTypeAlbum,
  musicPageTypePlaylist,
  musicVideoTypeOmv;

  static string(PageType pageType) {
    switch (pageType) {
      case PageType.musicPageTypeAlbum:
        return 'MUSIC_PAGE_TYPE_ALBUM';
      case PageType.musicPageTypePlaylist:
        return 'MUSIC_PAGE_TYPE_PLAYLIST';
      case PageType.musicVideoTypeOmv:
        return 'MUSIC_VIDEO_TYPE_OMV';
    }
  }
}

const String feMusicHome = "FEmusic_home";
