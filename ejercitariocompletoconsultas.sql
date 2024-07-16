--primera consulta
SELECT TOP 200 DisplayName, Location, Reputation 
FROM Users
ORDER BY Reputation desc;

--segunda consulta
SELECT TOP 200 
Posts.Title, Users.DisplayName
FROM Posts
JOIN Users ON Posts.OwnerUserId = Users.Id
WHERE Posts.OwnerUserId IS NOT NULL;

--Tercera Consulta
SELECT TOP 200
Users.DisplayName, AVG(Posts.Score) AS AverageScore
FROM Posts
JOIN Users ON Posts.OwnerUserId = Users.Id
GROUP BY Users.DisplayName;

--Cuarta consulta
SELECT Users.DisplayName
FROM Users
WHERE Users.Id IN (
	SELECT Comments.UserId
	FROM Comments
	GROUP BY Comments.UserId
	HAVING COUNT (Comments.Id) > 100);

--quinta consulta 
UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = '';


PRINT 'La actualizacion de ubicaciones vacias se realizo exitosamente'

--sexta consulta
DELETE Comments
FROM Comments
JOIN Users On Comments.UserId = Users.Id
WHERE Users.Reputation < 100;

DECLARE @DeletedCount INT;
SET @DeletedCount = @@ROWCOUNT;
PRINT CAST(@DeletedCount AS VARCHAR) + ' comentarios fueron eliminados.';

--septima consulta
SELECT Users.DisplayName,
       COALESCE(PostCounts.TotalPosts, 0) AS TotalPosts,
       COALESCE(CommentCounts.TotalComments, 0) AS TotalComments,
       COALESCE(BadgeCounts.TotalBadges, 0) AS TotalBadges
FROM Users
LEFT JOIN (
    SELECT OwnerUserId, COUNT(*) AS TotalPosts
    FROM Posts
    GROUP BY OwnerUserId
) AS PostCounts ON Users.Id = PostCounts.OwnerUserId
LEFT JOIN (
    SELECT UserId, COUNT(*) AS TotalComments
    FROM Comments
    GROUP BY UserId
) AS CommentCounts ON Users.Id = CommentCounts.UserId
LEFT JOIN (
    SELECT UserId, COUNT(*) AS TotalBadges
    FROM Badges
    GROUP BY UserId
) AS BadgeCounts ON Users.Id = BadgeCounts.UserId;

--octava consulta
SELECT TOP 10 Title, Score
FROM Posts
ORDER BY Score DESC;

--novena consulta
SELECT TOP 5 Text, CreationDate
FROM Comments
ORDER BY CreationDate DESC;
