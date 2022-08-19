---------------TEAM 18---------------
--Dimpleben Kanjibhai Patel (NU ID - 002965372)
--Garima Sanjay Choudhary (NU ID - 002104897)
--Mridul Regmi (NU ID - 001090410)
--Nidhi Singh (NU ID - 002925684 )
--Virendra Singh Rathore (NU ID - 001584432)
------------------------------------

------------------------------------------CREATE DATABASE------------------------------------------

CREATE DATABASE OTTDatabase; 
USE OTTDatabase;

------------------------------------------CREATE SCHEMA------------------------------------------

CREATE SCHEMA Ott;

--------------------------------CREATE MASTER KEY, SYMMETRIC KEY & CERTIFICATE---------------------------

CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'p@ssword123';

CREATE CERTIFICATE OttCertificate
WITH SUBJECT = 'OTT Certificate',
EXPIRY_DATE = '2025-12-31';

CREATE SYMMETRIC KEY DummySymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE OttCertificate;

OPEN SYMMETRIC KEY DummySymmetricKey
DECRYPTION BY CERTIFICATE OttCertificate;

------------------------------------------CREATE TABLES------------------------------------------

CREATE TABLE ott.Subscribers (
	SubscriberID int Identity NOT NULL PRIMARY KEY,
	FName Varchar(40) NOT NULL,
	LName Varchar(40) NOT NULL,
	Email Varchar(100) NOT NULL,
	BirthDate Date NULL,
	UserName Varchar(40) NOT NULL,
	Password VARBINARY(250) NOT NULL,
	Phone BIGINT NOT NULL
);

CREATE TABLE ott.StreamPlan (
	PlanID  int Identity NOT NULL PRIMARY KEY,
	PlanName Varchar(40) Null,
	Price Money NOT NULL,
	PlanDuration varchar(20) NOT NULL
);

CREATE TABLE ott.Payment (
	PaymentID int Identity NOT NULL PRIMARY KEY,
	PaymentMethod Varchar(40) NOT NULL CHECK (PaymentMethod IN ('CreditCard','DebitCard','Others')),
	InitiatedTimestamp datetime,
	CompletedTimestamp datetime,
	Amount Money NOT NULL,
	SubscriberID int FOREIGN KEY REFERENCES ott.Subscribers(SubscriberID),
	PlanID  int FOREIGN KEY REFERENCES ott.StreamPlan(PlanID),
	Status Varchar(40) NULL CHECK (Status IN ('Pending','Completed') )	
);

CREATE TABLE ott.Subscriptions (
	SubscriptionID  int Identity NOT NULL PRIMARY KEY,
	SubscriberID int FOREIGN KEY REFERENCES ott.Subscribers(SubscriberID),
	PlanID  int FOREIGN KEY REFERENCES ott.StreamPlan(PlanID),
	SubscriptionDate datetime Default GetDate(),
	ExpirationDate datetime,
	SubscriptionStatus varchar(40) NULL CHECK(SubscriptionStatus IN('Active','Inactive'))
);

CREATE TABLE ott.PromotionalOffers(
	OfferID  int Identity NOT NULL PRIMARY KEY,
	SubscriberID int FOREIGN KEY REFERENCES ott.Subscribers(SubscriberID),
	Discount Float not null,
	OfferExpiryDate datetime,
	Status Varchar(20)
);

CREATE TABLE ott.Actors(
	ActorID int IDENTITY NOT NULL PRIMARY KEY,
	FName Varchar(40) NOT NULL,
	LName Varchar(40) NOT NULL,
	BirthDate Date NULL,
	Gender Varchar(10) NULL,
	ActorCategory Varchar(40) not Null check(ActorCategory in ('Movie', 'Webseries', 'Both'))
);

CREATE TABLE ott.Format(
	FormatId  int identity NOT NULL PRIMARY KEY,
	FormatName Varchar(40) NOT NULL,
	Description Varchar(100) NULL
);

CREATE TABLE ott.Awards(
	AwardId  int identity NOT NULL PRIMARY KEY,
	AwardYear int NULL,
	AwardName varchar(40) NULL,
	AwardCategory varchar(40) NULL
);

CREATE TABLE ott.Genre(
	GenreId  int Identity NOT NULL PRIMARY KEY,
	GenreName varchar(40) NOT NULL,
	Description Varchar(100) NULL
);

CREATE TABLE ott.Movies(
	MovieID int identity NOT NULL PRIMARY KEY,
	Name varchar(40) NOT NULL,
	MovieYear int NULL,
	Rating float Null
);

CREATE TABLE ott.MovieActors(
	MovieID int NOT NULL FOREIGN KEY REFERENCES ott.Movies(MovieID),
	ActorID int NOT NULL FOREIGN KEY REFERENCES ott.Actors(ActorID)
		CONSTRAINT PKMActors PRIMARY KEY CLUSTERED  
             (MovieID, ActorID)
	
);


CREATE TABLE ott.WebSeries(
	WebSeriesID int Identity NOT NULL PRIMARY KEY,
	Name varchar(40) NOT NULL,
	WebSeriesYear int NULL,
	Rating float Null,
	TotalSeasons int Null
);

CREATE TABLE ott.WebSeriesActors(
	WebSeriesID int NOT NULL FOREIGN KEY REFERENCES ott.WebSeries(WebSeriesID),
	ActorID int NOT NULL FOREIGN KEY REFERENCES ott.Actors(ActorID)
		CONSTRAINT PKWSActors PRIMARY KEY CLUSTERED  
             (WebSeriesID, ActorID)
);

CREATE TABLE ott.WebSeriesWatchHistory(
	SubscriberID int NOT NULL FOREIGN KEY REFERENCES ott.Subscribers(SubscriberID),
	WebSeriesID int NOT NULL FOREIGN KEY REFERENCES ott.WebSeries(WebSeriesID)
	CONSTRAINT PKWSHistory PRIMARY KEY CLUSTERED  
             (SubscriberID, WebSeriesID),
    Rating float Null
);

CREATE TABLE ott.MovieWatchHistory(
	SubscriberID int NOT NULL FOREIGN KEY REFERENCES ott.Subscribers(SubscriberID),
	MovieID int NOT NULL FOREIGN KEY REFERENCES ott.Movies(MovieID),
	CONSTRAINT PKMHistory PRIMARY KEY CLUSTERED  
             (SubscriberID, MovieID),
	Rating float Null
);

CREATE TABLE ott.MovieFormat(
	FormatID int NOT NULL FOREIGN KEY REFERENCES ott.Format(FormatID),
	MovieID int NOT NULL FOREIGN KEY REFERENCES ott.Movies(MovieID),
	CONSTRAINT PKMFormat PRIMARY KEY CLUSTERED  
             (FormatID, MovieID),
);

CREATE TABLE ott.WebSeriesFormat(
	FormatID int NOT NULL FOREIGN KEY REFERENCES ott.Format(FormatID),
	WebSeriesID int NOT NULL FOREIGN KEY REFERENCES ott.WebSeries(WebSeriesID),
	CONSTRAINT PKWSFormat PRIMARY KEY CLUSTERED  
             (FormatID, WebSeriesID),
);

CREATE TABLE ott.MovieAwards(
	AwardID int NOT NULL FOREIGN KEY REFERENCES ott.Awards(AwardID),
	MovieID int NOT NULL FOREIGN KEY REFERENCES ott.Movies(MovieID),
	CONSTRAINT PKMAwards PRIMARY KEY CLUSTERED  
             (AwardID, MovieID),
);

CREATE TABLE ott.WebSeriesAwards(
	AwardID int NOT NULL FOREIGN KEY REFERENCES ott.Awards(AwardID),
	WebSeriesID int NOT NULL FOREIGN KEY REFERENCES ott.WebSeries(WebSeriesID),
	CONSTRAINT PKWSAwards PRIMARY KEY CLUSTERED  
             (AwardID, WebSeriesID),
);

CREATE TABLE ott.MovieGenre(
	MovieID int NOT NULL FOREIGN KEY REFERENCES ott.Movies(MovieID),
	GenreID int NOT NULL FOREIGN KEY REFERENCES ott.Genre(GenreId)
	CONSTRAINT PKMGenre PRIMARY KEY CLUSTERED  
             (MovieID, GenreID) 
);

CREATE TABLE ott.WebSeriesGenre(
	WebSeriesID int NOT NULL FOREIGN KEY REFERENCES ott.WebSeries(WebSeriesID),
	GenreID int NOT NULL FOREIGN KEY REFERENCES ott.Genre(GenreId)
	CONSTRAINT PKWSGenre PRIMARY KEY CLUSTERED  
             (WebSeriesID, GenreID) 
);

CREATE TABLE ott.MovieFavorite(
MovieID int NOT NULL FOREIGN KEY REFERENCES ott.Movies(MovieID),
SubscriberID int NOT NULL FOREIGN KEY REFERENCES ott.Subscribers(SubscriberID),
CONSTRAINT PKMFavorite PRIMARY KEY CLUSTERED  
             (SubscriberID, MovieID)
);


CREATE TABLE ott.WebSeriesFavorite(
	SubscriberID int NOT NULL FOREIGN KEY REFERENCES ott.Subscribers(SubscriberID),
	WebSeriesID int NOT NULL FOREIGN KEY REFERENCES ott.WebSeries(WebSeriesID)
	CONSTRAINT PKWSFavorite PRIMARY KEY CLUSTERED  
             (SubscriberID, WebSeriesID)
);


---------------------------------------------------------------------------------------- Computed Column----------------------------------------------------------------------------------

-- Calculating Actor's Age
Alter table ott.Actors
add Age AS DATEDIFF(hour, BirthDate,GETDATE())/8766;


--------------------------------------------------------------------------------------TABLE LEVEL CONSTRAINTS--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Promotional Offers Constraint: Only 12 active offers and one customer can have at most one active offer
GO
CREATE FUNCTION ott.checkOffers(@subscriberID INT) RETURNS VARCHAR(5)
AS
BEGIN
    DECLARE @activeOffers INT;
    DECLARE @totalOffers INT;
    SELECT @activeOffers=COUNT(*) from Ott.PromotionalOffers WHERE SubscriberID=@subscriberID and Status='ACTIVE';
    SELECT @totalOffers=COUNT(*) from Ott.PromotionalOffers WHERE Status='ACTIVE';
    IF @activeOffers>0 or @totalOffers>11
    BEGIN
        RETURN 'False'
    END
    RETURN 'True'
END;
GO
ALTER TABLE Ott.PromotionalOffers ADD CONSTRAINT offerConstraints CHECK (ott.checkOffers(SubscriberID) = 'True');

-- Subscription constraint: Only one active subscription per user
GO
CREATE FUNCTION ott.checkSubscriptionFunction(@subscriberID INT) RETURNS VARCHAR(5)
AS
BEGIN
    DECLARE @activeSubscriptions INT;
    SELECT @activeSubscriptions=COUNT(*) from Ott.Subscriptions WHERE SubscriberID=@subscriberID and SubscriptionStatus='Active';
    IF @activeSubscriptions>0
    BEGIN
        RETURN 'False'
    END
    RETURN 'True'
END;
GO
ALTER TABLE Ott.Subscriptions ADD CONSTRAINT checkSubscription CHECK (ott.checkSubscriptionFunction(SubscriberID) = 'True');


------------------------------------------------------------------------------------------------TRIGGERS------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Update [Status] column based on payment status
GO
CREATE TRIGGER statusCheck ON Ott.Payment
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @initiated DATETIME;
    DECLARE @completed DATETIME;
    SELECT @completed=CompletedTimestamp from inserted;
    IF @completed is NULL
    BEGIN
        UPDATE Ott.Payment SET [Status]='Pending' where [PaymentID]=(SELECT PaymentID from inserted);
        RETURN
    END
    UPDATE Ott.Payment SET [Status]='Completed' where [PaymentID]=(SELECT PaymentID from inserted);
    RETURN
END;

-- Promotional Offers Trigger: Update status column
GO
CREATE TRIGGER offerStatus ON Ott.PromotionalOffers
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @completed DATETIME;
    SELECT @completed=OfferExpiryDate from inserted;
    IF @completed<GETDATE()
    BEGIN
        UPDATE Ott.PromotionalOffers SET [Status]='EXPIRED' WHERE OfferID=(SELECT OfferID from inserted);
        RETURN
    END
    ELSE
    BEGIN
        UPDATE Ott.PromotionalOffers SET [Status]='ACTIVE' WHERE OfferID=(SELECT OfferID from inserted);
        RETURN
    END
END;

-- Subscriptions trigger: Populate Expiration Date and PlanID Column
GO
CREATE TRIGGER subscribeStatus ON Ott.Subscriptions
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @completed DATETIME;
    DECLARE @started DATETIME;
    DECLARE @planDuration INT;
    SELECT @started=SubscriptionDate from inserted;
    SELECT @planDuration=CAST(PlanDuration as INT) from Ott.StreamPlan WHERE PlanID=(SELECT PlanID from inserted)
    SET @completed=DATEADD(MONTH,@planDuration,@started)
    IF @completed<GETDATE()
    BEGIN
        UPDATE Ott.Subscriptions SET [SubscriptionStatus]='Inactive', [ExpirationDate]=@completed WHERE SubscriptionID=(SELECT SubscriptionID from inserted);
        RETURN
    END
    ELSE
    BEGIN
        UPDATE Ott.Subscriptions SET [SubscriptionStatus]='Active', [ExpirationDate]=@completed WHERE SubscriptionID=(SELECT SubscriptionID from inserted);
        RETURN
    END
END;

-- Trigger for rating movies
GO
CREATE TRIGGER movieRatingUpdate on Ott.MovieWatchHistory
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @totalRatingsCount INT;
    DECLARE @totalRatings INT;
    SELECT @totalRatingsCount=COUNT(*) from Ott.MovieWatchHistory WHERE MovieID=(SELECT MovieID from inserted);
    SELECT @totalRatings=SUM(Rating) from Ott.MovieWatchHistory WHERE MovieID=(SELECT MovieID from inserted);
    DECLARE @rate INT;
    SET @rate=@totalRatings/@totalRatingsCount;
    UPDATE Ott.Movies SET Rating=@rate WHERE MovieID=(SELECT MovieID from inserted);
END;

-- Trigger for rating webseries
GO
CREATE TRIGGER seriesRatingUpdate on Ott.WebSeriesWatchHistory
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @totalRatingsCount INT;
    DECLARE @totalRatings INT;
    SELECT @totalRatingsCount=COUNT(*) from Ott.WebSeriesWatchHistory WHERE WebSeriesID=(SELECT WebSeriesID from inserted);
    SELECT @totalRatings=SUM(Rating) from Ott.WebSeriesWatchHistory WHERE WebSeriesID=(SELECT WebSeriesID from inserted);
    DECLARE @rate INT;
    SELECT @rate=@totalRatings/@totalRatingsCount;
    UPDATE Ott.WebSeries SET Rating=@rate WHERE WebSeriesID=(SELECT WebSeriesID from inserted);
END;

---------------------------------------------------------------------------------------------------------DML------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--inserting into Subscribers table
insert into ott.Subscribers values('Mark','Chadwick','MarkChadwick7065@mafthy.com','2100-05-19','Chadwick Mark',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'824-33-5544')),3324427485);
insert into ott.Subscribers values('Ronald','Lunt','Ronald_Lunt1282@tonsy.com','2100-05-20','Lunt Ronald',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'568-83-6861')),9855748455);
insert into ott.Subscribers values('Sienna','Glynn','Sienna_Glynn502@typill.com','2100-05-21','Glynn Sienna',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'264-78-7632')),9854763210);
insert into ott.Subscribers values('Charlotte','Owen','Charlotte_Owen2547@famism.com','2100-05-22','Owen Charlotte',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'007-43-8752')),5454585625);
insert into ott.Subscribers values('Brad','Gray','Brad_Gray9292@deavo.com','2100-05-23','Gray Brad',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'824-33-9987')),8568965922);
insert into ott.Subscribers values('Carina','Yard','Carina_Yard6638@corti.com','2100-05-24','Yard Carina',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'706-03-4724')),2255334545);
insert into ott.Subscribers values('Chanelle','Mcgee','Chanelle_Mcgee8276@twipet.com','2100-05-25','Mcgee Chanelle',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'563-38-8380')),7812191513);
insert into ott.Subscribers values('Kaylee','Baker','Kaylee_Baker8531@fuliss.com','2100-05-26','Baker Kaylee',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'724-48-8411')),6547854120);
insert into ott.Subscribers values('Francesca','Corbett','Francesca_Corbett8469@bulaffy.com','2100-05-27','Corbett Francesca',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'317-20-2423')),1458757485);
insert into ott.Subscribers values('Peyton','Morris','Peyton_Morris9335@twace.com','2100-05-28','Morris Peyton',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'587-35-7050')),6589745841);
insert into ott.Subscribers values('Hayden','Gray','Hayden_Gray4231@typill.com','2100-05-29','Gray Hayden',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'117-35-7561')),2105410254);
insert into ott.Subscribers values('Angel','Robinson','Angel_Robinson7108@qater.com','2100-05-30','Robinson Angel',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'456-86-7173')),3254102563);
insert into ott.Subscribers values('Elijah','Phillips','Elijah_Phillips2537@ovock.com','2100-05-31','Phillips Elijah',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'400-02-5427')),3259874569);
insert into ott.Subscribers values('Alessandra','Wigley','Alessandra_Wigley8768@irrepsy.com','2100-06-01','Wigley Alessandra',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'812-56-8232')),02145632014);
insert into ott.Subscribers values('Joyce','Lewis','Joyce_Lewis1428@liret.com','2100-06-02','Lewis Joyce',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'522-17-7174')),4324327485);
insert into ott.Subscribers values('Aiden','Vane','Aiden_Vane3281@tonsy.com','2100-05-03','Vane Aiden',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'346-41-6434')),1254867485);
insert into ott.Subscribers values('Angelica','Warden','Angelica_Warden7262@elnee.com','1987-04-14','Warden Angelica',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'820-26-1053')),9896327410);
insert into ott.Subscribers values('Noah','Purvis','Noah_Purvis7268@twace.com','1955-08-19','Purvis Noah',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'014-83-4374')),8824417485);
insert into ott.Subscribers values('Rocco','Robinson','Rocco_Robinson1422@mafthy.com','1997-12-19','Robinson Rocco',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'102-25-2501')),9744427485);
insert into ott.Subscribers values('Cameron','Abbey','Cameron_Abbey4354@sheye.com','1954-11-06','Abbey Cameron',EncryptByKey(Key_GUID(N'DummySymmetricKey'), convert(varbinary,'303-54-2004')),4844437485);

--inserting into Movies
INSERT INTO [Ott].[Movies] VALUES('Zack and Miri', 2008, 0);
INSERT INTO [Ott].[Movies] VALUES('Youth in Revolt', 2010, 0);
INSERT INTO [Ott].[Movies] VALUES('You Will Meet a Tall Dark Stranger', 2010, 0);
INSERT INTO [Ott].[Movies] VALUES('When in Rome', 2010, 0);
INSERT INTO [Ott].[Movies] VALUES('What Happens in Vegas', 2008, 0);
INSERT INTO [Ott].[Movies] VALUES('Water For Elephants', 2011, 0);
INSERT INTO [Ott].[Movies] VALUES('WALL-E', 2008, 0);
INSERT INTO [Ott].[Movies] VALUES('Waitress', 2007, 0);
INSERT INTO [Ott].[Movies] VALUES('Waiting For Forever', 2011, 0);
INSERT INTO [Ott].[Movies] VALUES('Twilight: Breaking Dawn', 2011, 0);

--inserting into Webseries
INSERT INTO Ott.WebSeries(Name, WebSeriesYear, Rating, TotalSeasons) VALUES('Virgin River', 2007, 0, 4);
INSERT INTO Ott.WebSeries(Name, WebSeriesYear, Rating, TotalSeasons) VALUES('Stranger Things', 2013, 0, 4);
INSERT INTO Ott.WebSeries(Name, WebSeriesYear, Rating, TotalSeasons) VALUES('Resident Evil', 2010, 0, 3);
INSERT INTO Ott.WebSeries(Name, WebSeriesYear, Rating, TotalSeasons) VALUES('Manifest', 2010, 0, 2);
INSERT INTO Ott.WebSeries(Name, WebSeriesYear, Rating, TotalSeasons) VALUES(' The Rain', 2019, 0, 1);
INSERT INTO Ott.WebSeries(Name, WebSeriesYear, Rating, TotalSeasons) VALUES('Sherlock', 2021, 0, 2);
INSERT INTO Ott.WebSeries(Name, WebSeriesYear, Rating, TotalSeasons) VALUES('Sacred Games', 2020, 0, 3);
INSERT INTO Ott.WebSeries(Name, WebSeriesYear, Rating, TotalSeasons) VALUES('The Walking Dead', 2015, 0, 6);
INSERT INTO Ott.WebSeries(Name, WebSeriesYear, Rating, TotalSeasons) VALUES('Little Things', 2017, 0, 8);
INSERT INTO Ott.WebSeries(Name, WebSeriesYear, Rating, TotalSeasons) VALUES('Mirzapur', 2022, 0, 2);

--inserting into Actors
insert into ott.Actors values('Denzel','Washington','1954-12-28','Male','Movie');
insert into ott.Actors values('Meghan','Markle','1981-08-04','Female','Webseries');
insert into ott.Actors values('Jennifer','Aniston','1969-02-11','Female','Webseries');
insert into ott.Actors values('Scarlett','Johansson','1984-11-22','Female','Movie');
insert into ott.Actors values('Benedict','Cumberbatch','1976-07-17','Male','Both');
insert into ott.Actors values('Julia','Roberts','1967-10-28','Female','Movie');
insert into ott.Actors values('Josh','Dallas','1978-12-18','Male','Webseries');
insert into ott.Actors values('Aaron','Paul','1979-08-27','Male','Both');
insert into ott.Actors values('Tom','Cruise','1962-07-03','Male','Movie');
insert into ott.Actors values('Matt','Long','1980-05-18','Male','Webseries');
insert into ott.Actors values('Rachel','McAdams','1978-11-17','Female','Both');
insert into ott.Actors values('Emma','Stone','1988-11-06','Female','Both');
insert into ott.Actors values('SRK','Khan','1996-08-14','Male','Both');

--inserting into Genre
insert into ott.Genre values('Adventure','Adventure');
insert into ott.Genre values('Romance','Romance');
insert into ott.Genre values('Biography','Biography');
insert into ott.Genre values('Thriller','Thriller');
insert into ott.Genre values('History','History');
insert into ott.Genre values('Family','Family');
insert into ott.Genre values('Crime','Crime');
insert into ott.Genre values('Sci-Fi','Sci-Fi');
insert into ott.Genre values('Animation','Animation');
insert into ott.Genre values('Comedy','Comedy');
insert into ott.Genre values('Drama','Drama');
insert into ott.Genre values('Horror','Horror');


--inserting into Format table
insert into ott.Format values('WebM', 'WebM');
insert into ott.Format values('Matroska', 'Matroska');
insert into ott.Format values('Flash Video', 'Flash Video');
insert into ott.Format values('F4V', 'F4V');
insert into ott.Format values('Vob', 'Vob');
insert into ott.Format values('M4V', 'M4V');
insert into ott.Format values('mp4', 'mp4');
insert into ott.Format values('MOV', 'MOV');
insert into ott.Format values('AVI', 'AVI');
insert into ott.Format values('MKV', 'MKV');

--inserting into MovieFormat Table
insert into ott.MovieFormat values(1,1);
insert into ott.MovieFormat values(2,1);
insert into ott.MovieFormat values(7,1);
insert into ott.MovieFormat values(8,1);
insert into ott.MovieFormat values(1,2);
insert into ott.MovieFormat values(3,2);
insert into ott.MovieFormat values(4,2);
insert into ott.MovieFormat values(7,2);
insert into ott.MovieFormat values(1,3);
insert into ott.MovieFormat values(5,3);
insert into ott.MovieFormat values(6,3);
insert into ott.MovieFormat values(7,3);
insert into ott.MovieFormat values(10,3);
insert into ott.MovieFormat values(1,4);
insert into ott.MovieFormat values(6,4);
insert into ott.MovieFormat values(7,4);
insert into ott.MovieFormat values(8,4);
insert into ott.MovieFormat values(9,4);
insert into ott.MovieFormat values(1,5);
insert into ott.MovieFormat values(2,5);
insert into ott.MovieFormat values(7,5);
insert into ott.MovieFormat values(10,5);
insert into ott.MovieFormat values(9,5);
insert into ott.MovieFormat values(1,6);
insert into ott.MovieFormat values(2,6);
insert into ott.MovieFormat values(4,6);
insert into ott.MovieFormat values(6,6);
insert into ott.MovieFormat values(8,6);
insert into ott.MovieFormat values(10,6);
insert into ott.MovieFormat values(1,7);
insert into ott.MovieFormat values(3,7);
insert into ott.MovieFormat values(5,7);
insert into ott.MovieFormat values(7,7);
insert into ott.MovieFormat values(9,7);
insert into ott.MovieFormat values(1,8);
insert into ott.MovieFormat values(4,8);
insert into ott.MovieFormat values(7,8);
insert into ott.MovieFormat values(10,8);
insert into ott.MovieFormat values(1,9);
insert into ott.MovieFormat values(2,9);
insert into ott.MovieFormat values(5,9);
insert into ott.MovieFormat values(7,9);
insert into ott.MovieFormat values(1,10);
insert into ott.MovieFormat values(5,10);
insert into ott.MovieFormat values(8,10);
insert into ott.MovieFormat values(10,10);

--inserting into WebSeriesFormat table
insert into ott.WebSeriesFormat values(1,1);
insert into ott.WebSeriesFormat values(3,1);
insert into ott.WebSeriesFormat values(4,1);
insert into ott.WebSeriesFormat values(8,1);
insert into ott.WebSeriesFormat values(1,2);
insert into ott.WebSeriesFormat values(2,2);
insert into ott.WebSeriesFormat values(8,2);
insert into ott.WebSeriesFormat values(7,2);
insert into ott.WebSeriesFormat values(1,3);
insert into ott.WebSeriesFormat values(4,3);
insert into ott.WebSeriesFormat values(6,3);
insert into ott.WebSeriesFormat values(9,3);
insert into ott.WebSeriesFormat values(10,3);
insert into ott.WebSeriesFormat values(1,4);
insert into ott.WebSeriesFormat values(3,4);
insert into ott.WebSeriesFormat values(5,4);
insert into ott.WebSeriesFormat values(8,4);
insert into ott.WebSeriesFormat values(10,4);
insert into ott.WebSeriesFormat values(1,5);
insert into ott.WebSeriesFormat values(5,5);
insert into ott.WebSeriesFormat values(7,5);
insert into ott.WebSeriesFormat values(10,5);
insert into ott.WebSeriesFormat values(9,5);
insert into ott.WebSeriesFormat values(1,6);
insert into ott.WebSeriesFormat values(2,6);
insert into ott.WebSeriesFormat values(4,6);
insert into ott.WebSeriesFormat values(6,6);
insert into ott.WebSeriesFormat values(8,6);
insert into ott.WebSeriesFormat values(10,6);
insert into ott.WebSeriesFormat values(1,7);
insert into ott.WebSeriesFormat values(3,7);
insert into ott.WebSeriesFormat values(5,7);
insert into ott.WebSeriesFormat values(7,7);
insert into ott.WebSeriesFormat values(9,7);
insert into ott.WebSeriesFormat values(1,8);
insert into ott.WebSeriesFormat values(4,8);
insert into ott.WebSeriesFormat values(7,8);
insert into ott.WebSeriesFormat values(10,8);
insert into ott.WebSeriesFormat values(1,9);
insert into ott.WebSeriesFormat values(4,9);
insert into ott.WebSeriesFormat values(7,9);
insert into ott.WebSeriesFormat values(10,9);
insert into ott.WebSeriesFormat values(1,10);
insert into ott.WebSeriesFormat values(6,10);
insert into ott.WebSeriesFormat values(7,10);
insert into ott.WebSeriesFormat values(9,10);

--inserting into Awards table
INSERT INTO OTTDatabase.Ott.Awards (AwardYear, AwardName, AwardCategory) VALUES(2010, 'Africa Digital Awards', 'Both');
INSERT INTO OTTDatabase.Ott.Awards (AwardYear, AwardName, AwardCategory) VALUES(2011, 'AIMIA (AMY) Awards', 'Both');
INSERT INTO OTTDatabase.Ott.Awards (AwardYear, AwardName, AwardCategory) VALUES(2012, 'Canadian Screen Awards', 'Both');
INSERT INTO OTTDatabase.Ott.Awards (AwardYear, AwardName, AwardCategory) VALUES(2013, 'Indie Series Awards', 'Web Series');
INSERT INTO OTTDatabase.Ott.Awards (AwardYear, AwardName, AwardCategory) VALUES(2014, 'Net Awards', 'Movies');
INSERT INTO OTTDatabase.Ott.Awards (AwardYear, AwardName, AwardCategory) VALUES(2015, 'The Streamer Awards', 'Both');
INSERT INTO OTTDatabase.Ott.Awards (AwardYear, AwardName, AwardCategory) VALUES(2016, 'Web Awards', 'Both');
INSERT INTO OTTDatabase.Ott.Awards (AwardYear, AwardName, AwardCategory) VALUES(2017, 'Yuri Rubinsky Memorial Award', 'Web Series');
INSERT INTO OTTDatabase.Ott.Awards (AwardYear, AwardName, AwardCategory) VALUES(2018, 'Clickies', 'Web Series');
INSERT INTO OTTDatabase.Ott.Awards (AwardYear, AwardName, AwardCategory) VALUES(2019, 'EPpy Awards', 'Movies');


----inserting into MovieAwards table
insert into ott.MovieAwards values (1,1);
insert into ott.MovieAwards values (2,1);
insert into ott.MovieAwards values (7,1);
insert into ott.MovieAwards values (10,1);
insert into ott.MovieAwards values (1,2);
insert into ott.MovieAwards values (3,2);
insert into ott.MovieAwards values (5,2);
insert into ott.MovieAwards values (7,2);
insert into ott.MovieAwards values (1,3);
insert into ott.MovieAwards values (5,3);
insert into ott.MovieAwards values (6,3);
insert into ott.MovieAwards values (7,3);
insert into ott.MovieAwards values (10,3);
insert into ott.MovieAwards values (1,4);
insert into ott.MovieAwards values (6,4);
insert into ott.MovieAwards values (7,4);
insert into ott.MovieAwards values (1,6);
insert into ott.MovieAwards values (7,9);
insert into ott.MovieAwards values (1,10);

--inserting into WebSeriesAwards table
insert into ott.WebSeriesAwards values(1,1);
insert into ott.WebSeriesAwards values(2,1);
insert into ott.WebSeriesAwards values(4,1);
insert into ott.WebSeriesAwards values(8,1);
insert into ott.WebSeriesAwards values(1,4);
insert into ott.WebSeriesAwards values(3,4);
insert into ott.WebSeriesAwards values(8,4);
insert into ott.WebSeriesAwards values(4,5);
insert into ott.WebSeriesAwards values(8,5);
insert into ott.WebSeriesAwards values(2,6);
insert into ott.WebSeriesAwards values(4,6);
insert into ott.WebSeriesAwards values(1,7);
insert into ott.WebSeriesAwards values(3,7);
insert into ott.WebSeriesAwards values(7,7);
insert into ott.WebSeriesAwards values(9,7);
insert into ott.WebSeriesAwards values(1,8);
insert into ott.WebSeriesAwards values(4,8);
insert into ott.WebSeriesAwards values(7,8);
insert into ott.WebSeriesAwards values(1,9);
insert into ott.WebSeriesAwards values(4,9);
insert into ott.WebSeriesAwards values(7,9);
insert into ott.WebSeriesAwards values(10,9);

--inserting into MovieFavorite table
INSERT INTO OTTDatabase.Ott.MovieFavorite(MovieID, SubscriberID) VALUES(2, 2);
INSERT INTO OTTDatabase.Ott.MovieFavorite(MovieID, SubscriberID) VALUES(4, 4);
INSERT INTO OTTDatabase.Ott.MovieFavorite(MovieID, SubscriberID) VALUES(6, 6);
INSERT INTO OTTDatabase.Ott.MovieFavorite(MovieID, SubscriberID) VALUES(8, 8);
INSERT INTO OTTDatabase.Ott.MovieFavorite(MovieID, SubscriberID) VALUES(10, 10);
INSERT INTO OTTDatabase.Ott.MovieFavorite(MovieID, SubscriberID) VALUES(5, 11);
INSERT INTO OTTDatabase.Ott.MovieFavorite(MovieID, SubscriberID) VALUES(5, 13);
INSERT INTO OTTDatabase.Ott.MovieFavorite(MovieID, SubscriberID) VALUES(5, 15);
INSERT INTO OTTDatabase.Ott.MovieFavorite(MovieID, SubscriberID) VALUES(5, 17);
INSERT INTO OTTDatabase.Ott.MovieFavorite(MovieID, SubscriberID) VALUES(2, 19);

--inserting into WebSeriesFavorite table

INSERT INTO OTTDatabase.Ott.WebSeriesFavorite(SubscriberID, WebSeriesID) VALUES(20, 3);
INSERT INTO OTTDatabase.Ott.WebSeriesFavorite(SubscriberID, WebSeriesID) VALUES(19, 6);
INSERT INTO OTTDatabase.Ott.WebSeriesFavorite(SubscriberID, WebSeriesID) VALUES(2, 6);
INSERT INTO OTTDatabase.Ott.WebSeriesFavorite(SubscriberID, WebSeriesID) VALUES(18, 9);
INSERT INTO OTTDatabase.Ott.WebSeriesFavorite(SubscriberID, WebSeriesID) VALUES(5, 1);
INSERT INTO OTTDatabase.Ott.WebSeriesFavorite(SubscriberID, WebSeriesID) VALUES(16, 2);
INSERT INTO OTTDatabase.Ott.WebSeriesFavorite(SubscriberID, WebSeriesID) VALUES(3, 2);
INSERT INTO OTTDatabase.Ott.WebSeriesFavorite(SubscriberID, WebSeriesID) VALUES(8, 2);
INSERT INTO OTTDatabase.Ott.WebSeriesFavorite(SubscriberID, WebSeriesID) VALUES(4, 2);
INSERT INTO OTTDatabase.Ott.WebSeriesFavorite(SubscriberID, WebSeriesID) VALUES(11, 4);

--inserting into MovieGenre table
insert into ott.MovieGenre values(1,10);
insert into ott.MovieGenre values(2,7);
insert into ott.MovieGenre values(3,5);
insert into ott.MovieGenre values(4,4);
insert into ott.MovieGenre values(5,6);
insert into ott.MovieGenre values(6,10);
insert into ott.MovieGenre values(7,1);
insert into ott.MovieGenre values(8,2);
insert into ott.MovieGenre values(9,6);
insert into ott.MovieGenre values(10,12);
insert into ott.MovieGenre values(1,11);
insert into ott.MovieGenre values(5,7);
insert into ott.MovieGenre values(8,8);
insert into ott.MovieGenre values(4,10);

--inserting into WebSeriesGenre table
insert into ott.WebSeriesGenre values(1,7);
insert into ott.WebSeriesGenre values(2,6);
insert into ott.WebSeriesGenre values(3,5);
insert into ott.WebSeriesGenre values(4,3);
insert into ott.WebSeriesGenre values(5,2);
insert into ott.WebSeriesGenre values(6,10);
insert into ott.WebSeriesGenre values(7,1);
insert into ott.WebSeriesGenre values(8,12);
insert into ott.WebSeriesGenre values(9,8);
insert into ott.WebSeriesGenre values(10,4);
insert into ott.WebSeriesGenre values(1,2);
insert into ott.WebSeriesGenre values(8,7);
insert into ott.WebSeriesGenre values(3,8);
insert into ott.WebSeriesGenre values(9,10);

--inserting into MoviesActors table
insert into ott.MovieActors values(1,4);
insert into ott.MovieActors values(1,9);
insert into ott.MovieActors values(1,5);
insert into ott.MovieActors values(2,6);
insert into ott.MovieActors values(2,12);
insert into ott.MovieActors values(2,11);
insert into ott.MovieActors values(2,1);
insert into ott.MovieActors values(3,4);
insert into ott.MovieActors values(3,11);
insert into ott.MovieActors values(3,9);
insert into ott.MovieActors values(3,8);
insert into ott.MovieActors values(4,4);
insert into ott.MovieActors values(4,9);
insert into ott.MovieActors values(5,11);
insert into ott.MovieActors values(5,8);
insert into ott.MovieActors values(5,12);
insert into ott.MovieActors values(6,6);
insert into ott.MovieActors values(6,9);
insert into ott.MovieActors values(7,8);
insert into ott.MovieActors values(8,9);
insert into ott.MovieActors values(8,1);
insert into ott.MovieActors values(8,4);
insert into ott.MovieActors values(8,11);
insert into ott.MovieActors values(8,12);
insert into ott.MovieActors values(9,6);
insert into ott.MovieActors values(9,1);
insert into ott.MovieActors values(9,11);
insert into ott.MovieActors values(10,12);
insert into ott.MovieActors values(10,6);
insert into ott.MovieActors values(10,4);
insert into ott.MovieActors values(10,1);

--inserting into WebSeriesActors table
insert into ott.WebSeriesActors values(1,2);
insert into ott.WebSeriesActors values(1,10);
insert into ott.WebSeriesActors values(1,7);
insert into ott.WebSeriesActors values(2,3);
insert into ott.WebSeriesActors values(2,12);
insert into ott.WebSeriesActors values(2,11);
insert into ott.WebSeriesActors values(2,2);
insert into ott.WebSeriesActors values(3,3);
insert into ott.WebSeriesActors values(3,11);
insert into ott.WebSeriesActors values(3,7);
insert into ott.WebSeriesActors values(3,8);
insert into ott.WebSeriesActors values(4,3);
insert into ott.WebSeriesActors values(4,5);
insert into ott.WebSeriesActors values(5,11);
insert into ott.WebSeriesActors values(5,8);
insert into ott.WebSeriesActors values(5,12);
insert into ott.WebSeriesActors values(6,3);
insert into ott.WebSeriesActors values(6,7);
insert into ott.WebSeriesActors values(7,8);
insert into ott.WebSeriesActors values(8,3);
insert into ott.WebSeriesActors values(8,2);
insert into ott.WebSeriesActors values(8,10);
insert into ott.WebSeriesActors values(8,11);
insert into ott.WebSeriesActors values(8,12);
insert into ott.WebSeriesActors values(9,7);
insert into ott.WebSeriesActors values(9,3);
insert into ott.WebSeriesActors values(9,11);
insert into ott.WebSeriesActors values(10,12);
insert into ott.WebSeriesActors values(10,3);
insert into ott.WebSeriesActors values(10,7);
insert into ott.WebSeriesActors values(10,5);

--inserting into MovieWatchHistory table
insert into ott.MovieWatchHistory values(1,1,8);
insert into ott.MovieWatchHistory values(1,3,6);
insert into ott.MovieWatchHistory values(1,4,9);
insert into ott.MovieWatchHistory values(1,7,7);
insert into ott.MovieWatchHistory values(1,10,8);
insert into ott.MovieWatchHistory values(2,1,9);
insert into ott.MovieWatchHistory values(2,2,10);
insert into ott.MovieWatchHistory values(2,5,7);
insert into ott.MovieWatchHistory values(2,8,5);
insert into ott.MovieWatchHistory values(3,1,9);
insert into ott.MovieWatchHistory values(3,6,8);
insert into ott.MovieWatchHistory values(3,9,9);
insert into ott.MovieWatchHistory values(4,1,8);
insert into ott.MovieWatchHistory values(4,6,7);
insert into ott.MovieWatchHistory values(4,7,5);
insert into ott.MovieWatchHistory values(4,3,9);
insert into ott.MovieWatchHistory values(5,9,7);
insert into ott.MovieWatchHistory values(5,1,10);
insert into ott.MovieWatchHistory values(6,6,9);
insert into ott.MovieWatchHistory values(6,1,8);
insert into ott.MovieWatchHistory values(7,2,8);
insert into ott.MovieWatchHistory values(8,5,6);
insert into ott.MovieWatchHistory values(8,8,6);
insert into ott.MovieWatchHistory values(9,10,9);
insert into ott.MovieWatchHistory values(10,10,9);
insert into ott.MovieWatchHistory values(10,2,9);
insert into ott.MovieWatchHistory values(11,6,8);
insert into ott.MovieWatchHistory values(11,1,9);
insert into ott.MovieWatchHistory values(12,2,6);
insert into ott.MovieWatchHistory values(13,5,7);
insert into ott.MovieWatchHistory values(13,8,9);
insert into ott.MovieWatchHistory values(14,10,8);
insert into ott.MovieWatchHistory values(14,4,7);
insert into ott.MovieWatchHistory values(14,2,7);
insert into ott.MovieWatchHistory values(15,6,6);
insert into ott.MovieWatchHistory values(15,9,9);
insert into ott.MovieWatchHistory values(16,1,6);
insert into ott.MovieWatchHistory values(17,6,8);
insert into ott.MovieWatchHistory values(17,1,8);
insert into ott.MovieWatchHistory values(17,3,6);
insert into ott.MovieWatchHistory values(18,9,10);
insert into ott.MovieWatchHistory values(19,10,9);
insert into ott.MovieWatchHistory values(19,6,10);
insert into ott.MovieWatchHistory values(20,1,9);
insert into ott.MovieWatchHistory values(20,2,6);
insert into ott.MovieWatchHistory values(20,5,9);

--inserting into WebSeriesWatchHistory table
insert into ott.WebSeriesWatchHistory values(1,3,8);
insert into ott.WebSeriesWatchHistory values(1,5,7);
insert into ott.WebSeriesWatchHistory values(1,6,10);
insert into ott.WebSeriesWatchHistory values(1,8,7);
insert into ott.WebSeriesWatchHistory values(1,10,8);
insert into ott.WebSeriesWatchHistory values(2,4,9);
insert into ott.WebSeriesWatchHistory values(2,6,10);
insert into ott.WebSeriesWatchHistory values(2,7,7);
insert into ott.WebSeriesWatchHistory values(2,5,5);
insert into ott.WebSeriesWatchHistory values(3,9,9);
insert into ott.WebSeriesWatchHistory values(3,8,8);
insert into ott.WebSeriesWatchHistory values(3,5,9);
insert into ott.WebSeriesWatchHistory values(4,4,8);
insert into ott.WebSeriesWatchHistory values(4,10,7);
insert into ott.WebSeriesWatchHistory values(4,7,5);
insert into ott.WebSeriesWatchHistory values(4,3,9);
insert into ott.WebSeriesWatchHistory values(5,9,7);
insert into ott.WebSeriesWatchHistory values(5,1,10);
insert into ott.WebSeriesWatchHistory values(6,6,9);
insert into ott.WebSeriesWatchHistory values(6,1,8);
insert into ott.WebSeriesWatchHistory values(7,2,8);
insert into ott.WebSeriesWatchHistory values(8,5,6);
insert into ott.WebSeriesWatchHistory values(8,8,6);
insert into ott.WebSeriesWatchHistory values(9,10,9);
insert into ott.WebSeriesWatchHistory values(10,10,9);
insert into ott.WebSeriesWatchHistory values(10,2,9);
insert into ott.WebSeriesWatchHistory values(11,6,8);
insert into ott.WebSeriesWatchHistory values(11,10,9);
insert into ott.WebSeriesWatchHistory values(12,2,6);
insert into ott.WebSeriesWatchHistory values(13,10,7);
insert into ott.WebSeriesWatchHistory values(13,9,9);
insert into ott.WebSeriesWatchHistory values(14,4,8);
insert into ott.WebSeriesWatchHistory values(14,5,7);
insert into ott.WebSeriesWatchHistory values(14,3,7);
insert into ott.WebSeriesWatchHistory values(15,5,6);
insert into ott.WebSeriesWatchHistory values(15,6,9);
insert into ott.WebSeriesWatchHistory values(16,9,6);
insert into ott.WebSeriesWatchHistory values(17,8,8);
insert into ott.WebSeriesWatchHistory values(17,7,8);
insert into ott.WebSeriesWatchHistory values(17,3,6);
insert into ott.WebSeriesWatchHistory values(18,1,10);
insert into ott.WebSeriesWatchHistory values(19,2,9);
insert into ott.WebSeriesWatchHistory values(19,4,10);
insert into ott.WebSeriesWatchHistory values(20,5,9);
insert into ott.WebSeriesWatchHistory values(20,6,6);
insert into ott.WebSeriesWatchHistory values(20,10,9);

-- Insert Values For PromotionalOffers
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (1,10.5, '6-1-2023');
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (2,8.0, '6-1-2020');
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (4,5.0, '12-31-2022');
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (5,11.0, '3-1-2023');
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (6,12.25, '12-31-2022');
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (7,10.5, '3-1-2023');
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (8,6.25, '3-1-2023');
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (10,8, '9-30-2023');
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (11,10.5, '6-1-2023');
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (14,9, '12-31-2021');
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (15,7.5, '9-30-2023');
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (16,8, '9-30-2023');
INSERT INTO Ott.PromotionalOffers(SubscriberID, Discount, OfferExpiryDate) VALUES (17,2.5, '12-31-2023');


-- Insert Values for Stream Plan
INSERT INTO Ott.StreamPlan (PlanName,Price,PlanDuration) VALUES ('Monthly',20.0,'1');
INSERT INTO Ott.StreamPlan (PlanName,Price,PlanDuration) VALUES ('Quarterly',50.0,'3');
INSERT INTO Ott.StreamPlan (PlanName,Price,PlanDuration) VALUES ('Half-yearly',100.0,'6');
INSERT INTO Ott.StreamPlan (PlanName,Price,PlanDuration) VALUES ('Yearly',200.0,'12');


-- Insert Values For Subscriptions
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (1,1,'1-1-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (1,1,'7-1-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (2,2,'8-1-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (3,3,'6-15-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (4,1,'3-12-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (5,2,'2-18-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (6,1,'12-12-2021');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (7,4,'7-6-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (8,4,'12-24-2021');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (9,3,'11-26-2021');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (10,1,'6-9-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (11,4,'10-22-2021');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (12,1,'3-14-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (13,2,'2-12-2021');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (13,2,'8-1-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (14,2,'12-25-2021');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (15,1,'10-15-2021');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (16,3,'1-1-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (17,3,'6-30-2021');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (17,4,'4-16-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (18,3,'1-16-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (19,1,'6-4-2022');
INSERT INTO Ott.Subscriptions (SubscriberID,PlanID,SubscriptionDate) VALUES (20,3,'9-17-2021');   

-- Insert values for Payments
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('CreditCard','1-1-2022',NULL,20,1,1);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('CreditCard','7-1-2022','8-1-2022',20,1,1);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('DebitCard','8-1-2022','8-2-2022',50,2,2);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('CreditCard','6-15-2022','6-20-2022',100,3,3);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('Others','3-12-2022','3-14-2022',20,4,1);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('CreditCard','2-18-2022','2-28-2022',50,5,2);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('Others','12-12-2021','12-13-2021',20,6,1);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('CreditCard','7-6-2022',NULL,200,7,4);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('DebitCard','12-24-2021','12-25-2021',200,8,4);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('CreditCard','11-26-2021','11-26-2021',100,9,3);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('Others','6-9-2022',NULL,20,10,1);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('CreditCard','10-22-2021','10-23-2021',200,11,4);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('DebitCard','3-14-2022','3-14-2022',20,12,1);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('CreditCard','2-12-2021','2-14-2021',50,13,2);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('DebitCard','8-1-2022',NULL,50,13,2);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('CreditCard','12-25-2021','1-1-2022',50,14,2);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('CreditCard','10-15-2021','10-16-2021',20,15,1);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('Others','1-1-2022','1-3-2022',100,16,3);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('DebitCard','6-30-2021','7-1-2021',100,17,3);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('DebitCard','1-16-2022','1-16-2022',200,17,4);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('CreditCard','1-16-2022','1-16-2022',200,18,4);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('Others','6-4-2022','6-5-2022',20,19,1);
INSERT INTO Ott.Payment (PaymentMethod, InitiatedTimestamp, CompletedTimestamp, Amount, SubscriberID, PlanID) VALUES ('DebitCard','9-17-2021','9-18-2021',100,20,3);

------------------------------------------------------------------------------------- VIEWS	------------------------------------------------------------------------------------------------

--View to display Most watched web series/movie
Go
CREATE VIEW [ott].[Most Watched Movie] AS
with temp as
(select m.MovieID, Name, count(m.MovieID) as MovieWatchCount,
rank() over(order by  count(m.MovieID) desc) as rank
from ott.MovieWatchHistory mwh
inner join 
ott.Movies m
on m.MovieID = mwh.MovieID
group by m.MovieID, Name)
select MovieID, Name, MovieWatchCount from temp where rank = 1;


--View to display Top 3 rated web series
Go
CREATE VIEW [ott].[Top Rated Web Series] AS
With temp AS (
	SELECT ws.Name, ws.Rating,
	DENSE_RANK () OVER (ORDER BY ws.Rating DESC) AS 'Rank'
	FROM ott.WebSeries ws)
SELECT Name, Rating from temp
WHERE [Rank] <=3;


-- View to display Stream plan and it's Total Revenue for month and Year
Go
CREATE VIEW [ott].[Highest Revenue] AS
with temp as
(Select sp.PlanName, format(p.completedtimestamp, 'yyyy') as [Calender Year], 
SUM(amount) as TotalAmount
from ott.Payment p JOIN ott.StreamPlan sp on p.PlanID = sp.PlanID
where p.status = 'Completed' and CompletedTimestamp is not null
group by format(p.completedtimestamp, 'yyyy'), sp.PlanName)
select [Calender Year],[Monthly], [Quarterly], [Half-Yearly], [Yearly] from
(select PlanName, [Calender Year], TotalAmount  from temp) selectedTable
pivot
(max(TotalAmount) for 
PlanName in ([Monthly], [Quarterly], [Half-Yearly], [Yearly])) as PivotTable;


-- View to display Most Award Winning Movie
Go
CREATE VIEW [ott].[Most Award Winning Movie] AS
Select distinct m.Name as [Most Award Winning Movie]
from ott.Movies m 
JOIN ott.MovieAwards ma  ON m.MovieID = ma.MovieID 
where m.MovieID in (
	SELECT  MovieID FROM ott.MovieAwards
	GROUP BY MovieID
	HAVING   COUNT(MovieID)=
	(
		SELECT MAX(t1.award_count) 
		FROM 
			(SELECT COUNT(MovieID)  AS award_count 
			FROM  ott.MovieAwards
			GROUP BY  MovieID)t1
	)
);
Go

