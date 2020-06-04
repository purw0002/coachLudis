// index.js

/**
 * Required External Modules
 */
const express = require("express");
const path = require("path");
const MongoClient = require("mongodb").MongoClient;
const ObjectId = require("mongodb").ObjectID;

/**
 * App Variables
 */
const CONNECTION_URL = "mongodb+srv://SSK01:SSK01@ludisanalyticacluster-avpzx.mongodb.net/test?retryWrites=true&w=majority";
const DATABASE_NAME = "CoachLudisDB";
const COLLECTION_NAME_1 = "Soccer1";
const COLLECTION_NAME_2 = "Cycling";
const app = express();
const port = process.env.PORT || "8080";
app.use(express.static(__dirname + '/public'));

/**
 *  App Configuration
 */
app.set("views", path.join(__dirname, "views"));
app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');

var database, collection;

app.listen(port, () => {
    MongoClient.connect(CONNECTION_URL, { useNewUrlParser: true,useUnifiedTopology: true }, (error, client) => {
        if(error) {
            throw error;
        }
        database = client.db(DATABASE_NAME);
        collection1 = database.collection(COLLECTION_NAME_1);
        collection2 = database.collection(COLLECTION_NAME_2);
        console.log("Connected to " + DATABASE_NAME + "`!");
    });
});
/**
 * Routes Definitions
 */
app.get("/", (req, res) => {
    res.render("coachludis");
  });

app.get("/getsoccerinjury", (request, response) => {

    // collection.find({"Sports.Soccer.bodyPart.bodyPartName" : {"$eq" : "Head and neck", "$exists" : true}}).toArray((error, result)=> {
    //      if(error) {
    //          return response.status(500).send(error);
    //      };

    collection1.find({},{"_id":0}).toArray((error, result) => {
    if(error) {
         return response.status(500).send(error);
     }
    response.send(result);
});
});

app.get("/getcyclinginjury", (request, response) => {

    // collection.find({"Sports.Soccer.bodyPart.bodyPartName" : {"$eq" : "Head and neck", "$exists" : true}}).toArray((error, result)=> {
    //      if(error) {
    //          return response.status(500).send(error);
    //      };

    collection2.find({},{"_id":0}).toArray((error, result) => {
    if(error) {
         return response.status(500).send(error);
     }
    response.send(result);
});
});

