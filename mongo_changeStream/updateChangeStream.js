
conn = new Mongo("mongodb://localhost:27017/demo?replicaSet=rs");
db = conn.getDB("demo");
collection = db.stock;

let updateOps = {
  $match: {
    $and: [
      { "updateDescription.updatedFields.quantity": { $lte: 10 } },
      { operationType: "update" }
    ]
  }
};

const changeStreamCursor = collection.watch([updateOps]);

pollStream(changeStreamCursor);

//this function polls a change stream and prints out each change as it comes in
function pollStream(cursor) {
  while (!cursor.isExhausted()) {
    if (cursor.hasNext()) {
      change = cursor.next();
      print(JSON.stringify(change));
    }
  }
  pollStream(cursor);
}