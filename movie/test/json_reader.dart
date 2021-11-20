import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path.split('test');
  if (dir.length < 2) {
    dir[0] += "/movie";
  }
  // if (dir.endsWith('/test')) {
  //   dir = dir.replaceAll('/test', '');
  // }C:\Users\Darkshan\Documents\programming\flutter\submisi dicoding\expert\ditonton\movie\test\dummy\now_playing.json
  // print(dir);
  return File('${dir[0]}/test/$name').readAsStringSync();
}
