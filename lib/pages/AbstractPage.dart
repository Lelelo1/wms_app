abstract class AbstractPage {
  // name should maybe be called 'featureName' and be more specific
  String
      get name; // for some eason 'final' in the widget page and 'get' matches

  //Future<bool> load(Future<bool> task);
  /*
  // can't restrict to a contructor signatur like this: https://stackoverflow.com/questions/58223010/dart-abstract-constructors
  AbstractPage(String name);
  */

}
