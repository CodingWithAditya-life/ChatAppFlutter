class GenerateCallID{
  static String generateCallId(String otherUserId, String userId){
    List<String> ids = [otherUserId, userId];
    ids.sort();
    return ids.join("_");
  }
}
