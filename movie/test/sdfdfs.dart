import 'dart:io';

main() {
  var name = 'dummy/now_playing.json';
  var dir = Directory.current.path.split('test');
  // if (dir.endsWith('/test')) {
  //   dir = dir.replaceAll('/test', '');
  // }
  var path = '${dir[0]}test/$name';
  print(path);
  File(path).readAsStringSync();
}
