CREATE CONSTRAINT ON (person:Person) ASSERT person.id IS UNIQUE
CREATE CONSTRAINT ON (movie:Movie) ASSERT movie.id IS UNIQUE
CREATE INDEX ON :Country(name)

LOAD CSV WITH HEADERS FROM "file:///persons.csv" AS csvLine
CREATE (p:Person {id: toInteger(csvLine.id), name: csvLine.name})

LOAD CSV WITH HEADERS FROM "file:///movies.csv" AS csvLine
MERGE (country:Country {name: csvLine.country})//Using MERGE avoids creating duplicate country nodes in the case where multiple movies have been made in the same country.
CREATE (movie:Movie {id: toInteger(csvLine.id), title: csvLine.Title, year:toInteger(csvLine.year)})
CREATE (movie)-[:MADE_IN]->(country)

LOAD CSV WITH HEADERS FROM "file:///roles.csv" AS csvLine
MATCH (person:Person {id: toInteger(csvLine.personId)}),(movie:Movie {id: toInteger(csvLine.movieId)})
CREATE (person)-[:PLAYED {role: csvLine.role}]->(movie)

MATCH (person:Person),(movie:Movie)	
WHERE person.name = 'Michael Douglas' AND movie.title = 'Wall Street'	
create (person)-[:PLAYED{role: 'wife'}]->(movie)

MATCH (:Person {name: "Michael Douglas"})-[r:PLAYED {roll:"wife"}]-(:Movie {title: "Wall Street"}) 
DELETE r
