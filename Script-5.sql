SELECT id, title, COUNT(artistsid) FROM genres g
	JOIN genresartists ga ON g.id = ga.genresid 
    GROUP BY id
    ORDER BY id;

SELECT a.id, a.title, COUNT(m.id) FROM albums a
	JOIN musicalcompositions m ON a.id = m.albumsid
	WHERE releaseyear IN (2019, 2020)
    GROUP BY a.id
    ORDER BY a.id;
    
SELECT a.id, a.title, AVG(m.duration) FROM albums a
	JOIN musicalcompositions m ON a.id = m.albumsid
	GROUP BY a.id
    ORDER BY a.id;

SELECT art.id, art.alias
FROM (SELECT artalb.artistsid FROM artistsalbums artalb
		JOIN albums alb ON artalb.albumsid = alb.id 
		GROUP BY artalb.artistsid, alb.releaseyear
		HAVING alb.releaseyear = 2020) AS art2020
	RIGHT JOIN artists art ON art2020.artistsid = art.id
	WHERE art2020.artistsid IS NULL;

SELECT DISTINCT muscol.title FROM musiccollections muscol
	JOIN collectionscompositions colcom ON muscol.id = colcom.collectionsid 
	JOIN musicalcompositions m ON colcom.compositionsid = m.id 
	JOIN albums alb ON m.albumsid = alb.id 
	JOIN artistsalbums artalb ON alb.id = artalb.albumsid 
	JOIN artists art ON artalb.artistsid = art.id 
	WHERE art.alias = 'Ёлка';

SELECT DISTINCT alb.title 
FROM (SELECT art.id FROM artists art 
	      JOIN genresartists g ON art.id = g.artistsid 
	      GROUP BY art.id
	      HAVING COUNT(g.genresid) > 1) AS multi_genre
	JOIN artistsalbums artalb ON multi_genre.id = artalb.artistsid 
	JOIN albums alb ON artalb.albumsid = alb.id;

INSERT INTO musicalcompositions(albumsid, title, duration)
	VALUES(6, 'Трэк не входящий в сборник', '268');
	
SELECT m.title FROM musicalcompositions m
	LEFT JOIN collectionscompositions colcom ON m.id = colcom.compositionsid
	WHERE colcom.compositionsid IS NULL; 

SELECT art.alias, m.duration FROM artists art
	JOIN artistsalbums artalb ON art.id = artalb.artistsid 
	JOIN albums alb ON artalb.albumsid = alb.id 
	JOIN musicalcompositions m ON alb.id = m.albumsid
	WHERE m.duration = (SELECT MIN(m.duration) FROM musicalcompositions m);

SELECT alb.id, alb.title, COUNT(m.id) FROM albums alb
	JOIN musicalcompositions m ON alb.id = m.albumsid 
	GROUP BY alb.id
	HAVING COUNT(m.id) = (SELECT COUNT(m.id) FROM albums alb
							JOIN musicalcompositions m ON alb.id = m.albumsid 
							GROUP BY alb.id
							ORDER BY COUNT(m.id)
							LIMIT 1);	
