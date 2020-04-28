const express = require("express");
const bodyParser = require("body-parser");
const MongoClient = require("mongodb").MongoClient;
const ObjectId = require("mongodb").ObjectID;

const CONNECTION_URL = "mongodb+srv://SSK01:SSK01@ludisanalyticacluster-avpzx.mongodb.net/test?retryWrites=true&w=majority";
const DATABASE_NAME = "CoachLudisDB";
const COLLECTION_NAME = "soccerLevel1"

var app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

var database, collection;

app.listen(3000, () => {
    MongoClient.connect(CONNECTION_URL, { useNewUrlParser: true,useUnifiedTopology: true }, (error, client) => {
        if(error) {
            throw error;
        }
        database = client.db(DATABASE_NAME);
        collection = database.collection(COLLECTION_NAME);
        console.log("Connected to `" + DATABASE_NAME + "`!");
    });
});

app.get("/getsoccerinjury", (request, response) => {

	    collection.find({},{"_id":0}).toArray((error, result) => {
        if(error) {
            return response.status(500).send(error);
        }
        response.send(result);
    });
});
