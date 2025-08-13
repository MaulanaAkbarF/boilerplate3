enum ListMediaFolder {
  documents("Documents"),
  downloads("Download"),
  musics("Music"),
  pictures("Pictures"),
  videos("Video");

  final String path;
  const ListMediaFolder(this.path);
}

enum DioMethod {
  get,
  post,
  put,
  delete;
  const DioMethod();
}