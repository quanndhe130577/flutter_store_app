String shortenString(String word, int length) {
  return "${word.length > length ? word.substring(0, length) + " . . ." : word}";
}
