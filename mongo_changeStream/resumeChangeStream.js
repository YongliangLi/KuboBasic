conn = new Mongo("mongodb://localhost:27017/demo?replicaSet=rs");
db = conn.getDB("demo");
collection = db.stock;

const changeStreamCursor = collection.watch();
resumeStream(changeStreamCursor, true);

function resumeStream(changeStreamCursor, forceResume = false) {
  let resumeToken;
  while (!changeStreamCursor.isExhausted()) {
    if (changeStreamCursor.hasNext()) {
      change = changeStreamCursor.next();
      print(JSON.stringify(change));
      resumeToken = change._id;
      if (forceResume === true) {
        print("\r\nSimulating app failure for 10 seconds...");
        //sleepFor(10000);
        changeStreamCursor.close();
        const newChangeStreamCursor = collection.watch([], {
          resumeAfter: resumeToken
        });
        print("\r\nResuming change stream with token " + JSON.stringify(resumeToken) + "\r\n");
        resumeStream(newChangeStreamCursor);
      }
    }
  }
  resumeStream(changeStreamCursor, forceResume);
}