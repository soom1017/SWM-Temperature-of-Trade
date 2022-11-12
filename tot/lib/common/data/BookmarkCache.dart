import 'package:get/get.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/news_tile_data.dart';

class BookmarkCache extends GetxController {
  static BookmarkCache get to => Get.find<BookmarkCache>();

  var bookmarks = <NewsTileData>[].obs;

  Future<void> loadBookmark() async {
    bookmarks.clear();
    final bookmark = await tokenCheck(() => API.getUserBookmark());
    if (bookmark != null) {
      bookmarks.addAll(bookmark);
    } else {
      bookmarks.clear();
    }
  }

  Future<void> createBookmark(NewsTileData news) async {
    bookmarks.add(news);
    tokenCheck(() => API.createBookmarkById(news.id));
  }

  Future<void> deleteBookmark(int id) async {
    bookmarks.removeWhere((x) => x.id == id);
    tokenCheck(() => API.deleteBookmarkById(id));
  }
}
