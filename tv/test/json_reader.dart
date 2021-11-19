import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path.split('test');

  // if (dir.endsWith('/test')) {
  //   dir = dir.replaceAll('/test', '');
  // }
  return File('${dir[0]}\\test\\$name').readAsStringSync();
}
