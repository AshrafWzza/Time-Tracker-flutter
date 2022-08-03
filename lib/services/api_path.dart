class APIPATH {
  static String job(String uid, String jobId) => '/users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
  // static String entry(String uid, String jobId, String entryId) =>
  //     '/users/$uid/jobs/$jobId/entries/$entryId';
  // static String entries(String uid, String jobId) =>
  //     '/users/$uid/jobs/$jobId/entries';
  // All depending on jobId not every query make jobId & $entryId
  static String entry(String uid, String jobId) => '/users/$uid/entries/$jobId';
  static String entries(String uid) => '/users/$uid/entries';
}
