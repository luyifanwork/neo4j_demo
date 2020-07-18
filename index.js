var express = require('express');
var path = require('path');
var logger = require('morgan');
var bodyPasrser = require('body-parser');
var neo4j = require('neo4j-driver');

var app = express();

// app.set("views", path.join(__dirname,'views'));
// app.set('view engine', 'ejs');

app.use(logger('dev'));
app.use(bodyPasrser.json());
app.use(bodyPasrser.urlencoded({ extended: false}));
app.use(express.static(path.join(__dirname, 'public')));

var driver = neo4j.driver('bolt://localhost', neo4j.auth.basic('neo4j','*'));
var session = driver.session();

app.get("/", function(req, res){
    session 
        .run('MATCH (n) RETURN n LIMIT 25')
        .then(function(result){
            result.records.forEach(function(record){
                console.log(record._fields[0].properties);
            });
        })
        .catch(function(err){
            console.log(err);
        })
    res.send('it works');
});
app.listen(3200);
console.log("server started on port 3200");
module.exports = app;


