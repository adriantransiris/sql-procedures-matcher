-- 12.1.0.4 to 12.1.1 ---------------------------------------------------------

ALTER TABLE JourneyReports add createdDateEpoch NUMBER add lastModifiedDateEpoch NUMBER add publishDateEpoch NUMBER add pausedDateEpoch NUMBER add completedDateEpoch NUMBER add journeyCreatedDateEpoch NUMBER;
ALTER TABLE PointReports add createdDateEpoch NUMBER;
ALTER TABLE AudienceReports add createdDateEpoch NUMBER add eventRequestDateEpoch NUMBER;
ALTER TABLE AudienceResponseReports add createdDateEpoch NUMBER add eventResponseDateEpoch NUMBER;
ALTER TABLE AudienceRespMetaDataReports add createdDateEpoch NUMBER;
ALTER TABLE AudienceRespInteractionReports add createdDateEpoch NUMBER;
ALTER TABLE EmailPerformanceSent add sentTimeStampEpoch NUMBER;
ALTER TABLE EmailPerformanceDelivery add deliveryTimeStampEpoch NUMBER;
ALTER TABLE EmailPerformanceOpen add openTimeStampEpoch NUMBER;
ALTER TABLE EmailPerformanceLinkClick add clickTimeStampEpoch NUMBER;
ALTER TABLE SmsPerformanceSent add sentTimeStampEpoch NUMBER;
ALTER TABLE SmsPerformanceDelivery add deliveryTimeStampEpoch NUMBER;
ALTER TABLE SmsPerformanceLinkClick add clickTimeStampEpoch NUMBER;

CREATE OR REPLACE FUNCTION get_utc_epoch ( p_date IN TIMESTAMP ) RETURN NUMBER AS
BEGIN
    RETURN ( CAST ( p_date AT TIME ZONE 'UTC' AS DATE ) - DATE '1970-01-01' ) * 86400000;
END get_utc_epoch;
/

UPDATE JourneyReports SET createdDateEpoch = get_utc_epoch(createdDate) WHERE createdDateEpoch IS NULL AND createdDate IS NOT NULL;
UPDATE JourneyReports SET lastModifiedDateEpoch = get_utc_epoch(lastModifiedDate) WHERE lastModifiedDateEpoch IS NULL AND lastModifiedDate IS NOT NULL;
UPDATE JourneyReports SET publishDateEpoch = get_utc_epoch(publishDate) WHERE publishDateEpoch IS NULL AND publishDate IS NOT NULL;
UPDATE JourneyReports SET pausedDateEpoch = get_utc_epoch(pausedDate) WHERE pausedDateEpoch IS NULL AND pausedDate IS NOT NULL;
UPDATE JourneyReports SET completedDateEpoch = get_utc_epoch(completedDate) WHERE completedDateEpoch IS NULL AND completedDate IS NOT NULL;
UPDATE JourneyReports SET journeyCreatedDateEpoch = get_utc_epoch(journeyCreatedDate) WHERE journeyCreatedDateEpoch IS NULL AND journeyCreatedDate IS NOT NULL;
UPDATE PointReports SET createdDateEpoch = get_utc_epoch(createdDate) WHERE createdDateEpoch IS NULL AND createdDate IS NOT NULL;
UPDATE AudienceReports SET createdDateEpoch = get_utc_epoch(createdDate) WHERE createdDateEpoch IS NULL AND createdDate IS NOT NULL;
UPDATE AudienceReports SET eventRequestDateEpoch = get_utc_epoch(eventRequestDate) WHERE eventRequestDateEpoch IS NULL AND eventRequestDate IS NOT NULL;
UPDATE AudienceResponseReports SET createdDateEpoch = get_utc_epoch(createdDate) WHERE createdDateEpoch IS NULL AND createdDate IS NOT NULL;
UPDATE AudienceResponseReports SET eventResponseDateEpoch = get_utc_epoch(eventResponseDate) WHERE eventResponseDateEpoch IS NULL AND eventResponseDate IS NOT NULL;
UPDATE AudienceRespMetaDataReports SET createdDateEpoch = get_utc_epoch(createdDate) WHERE createdDateEpoch IS NULL AND createdDate IS NOT NULL;
UPDATE AudienceRespInteractionReports SET createdDateEpoch = get_utc_epoch(createdDate) WHERE createdDateEpoch IS NULL AND createdDate IS NOT NULL;
UPDATE EmailPerformanceSent SET sentTimeStampEpoch = get_utc_epoch(sentTimeStamp) WHERE sentTimeStampEpoch IS NULL AND sentTimeStamp IS NOT NULL;
UPDATE EmailPerformanceDelivery SET deliveryTimeStampEpoch = get_utc_epoch(deliveryTimeStamp) WHERE deliveryTimeStampEpoch IS NULL AND deliveryTimeStamp IS NOT NULL;
UPDATE EmailPerformanceOpen SET openTimeStampEpoch = get_utc_epoch(openTimeStamp) WHERE openTimeStampEpoch IS NULL AND openTimeStamp IS NOT NULL;
UPDATE EmailPerformanceLinkClick SET clickTimeStampEpoch = get_utc_epoch(clickTimeStamp) WHERE clickTimeStampEpoch IS NULL AND clickTimeStamp IS NOT NULL;
UPDATE SmsPerformanceSent SET sentTimeStampEpoch = get_utc_epoch(sentTimeStamp) WHERE sentTimeStampEpoch IS NULL AND sentTimeStamp IS NOT NULL;
UPDATE SmsPerformanceDelivery SET deliveryTimeStampEpoch = get_utc_epoch(deliveryTimeStamp) WHERE deliveryTimeStampEpoch IS NULL AND deliveryTimeStamp IS NOT NULL;
UPDATE SmsPerformanceLinkClick SET clickTimeStampEpoch = get_utc_epoch(clickTimeStamp) WHERE clickTimeStampEpoch IS NULL AND clickTimeStamp IS NOT NULL;

BEGIN
    execute immediate 'ALTER TABLE AudienceRespInteractionReports RENAME COLUMN primaryAudienceRespInteractionId TO PRIMARYAUDIENCERESPINTID';
EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('NO primaryAudienceRespInteractionId Found');
END;
/

commit;



-- 12.1.1 to 12.1.2 -----------------------------------------------------------

ALTER TABLE EmailPerformanceSent ADD active Number DEFAULT 1 NOT NULL;
ALTER TABLE EmailPerformanceOpen ADD active Number DEFAULT 1 NOT NULL;
ALTER TABLE EmailPerformanceLinkClick ADD active Number DEFAULT 1 NOT NULL;
ALTER TABLE EmailPerformanceDelivery ADD active Number DEFAULT 1 NOT NULL;
ALTER TABLE SmsPerformanceSent ADD active Number DEFAULT 1 NOT NULL;
ALTER TABLE SmsPerformanceDelivery ADD active Number DEFAULT 1 NOT NULL;
ALTER TABLE SmsPerformanceLinkClick ADD active Number DEFAULT 1 NOT NULL;

	CREATE TABLE PushPerformanceSent (
      	id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	  	journeyId NUMBER(20,0),
	  	pointId Number(20),
	  	pointName VARCHAR2(250 CHAR),
      	audienceId NUMBER(20),
      	audienceMobileNumber VARCHAR(20),
	  	template VARCHAR2(100 CHAR),
	  	channel  VARCHAR2(50 CHAR),
      	sentTimeStamp TIMESTAMP,
      	sentTimeStampEpoch NUMBER,
      	active Number DEFAULT 1 NOT NULL ENABLE,
      	PRIMARY KEY (id),
      	CONSTRAINT unique_pushperf_sent UNIQUE(audienceId, pointId)
	);                

	CREATE TABLE PushPerformanceDelivery (
      	id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	  	journeyId NUMBER(20,0),
	  	pointId Number(20),
	  	pointName VARCHAR2(250 CHAR),
      	audienceId NUMBER(20),
      	audienceMobileNumber VARCHAR(20),
	  	template VARCHAR2(100 CHAR),
	  	channel  VARCHAR2(50 CHAR),
      	deliveryTimeStamp TIMESTAMP,
      	deliveryTimeStampEpoch NUMBER,
      	active Number DEFAULT 1 NOT NULL ENABLE,
      	PRIMARY KEY (id),
      	CONSTRAINT unique_pushperf_delivery UNIQUE(audienceId, pointId)
	);

	CREATE TABLE PushPerformanceOpen (
      	id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	  	journeyId NUMBER(20,0),
	  	pointId Number(20),
	  	pointName VARCHAR2(250 CHAR),
      	audienceId NUMBER(20),
      	audienceMobileNumber VARCHAR(20),
	  	template VARCHAR2(100 CHAR),
	  	channel  VARCHAR2(50 CHAR),
      	openTimeStamp TIMESTAMP,
      	openTimeStampEpoch NUMBER,
      	averageOpenInteractionTime NUMBER,
      	active Number DEFAULT 1 NOT NULL ENABLE,
      	PRIMARY KEY (id),
      	CONSTRAINT unique_pushperf_open UNIQUE(audienceId, pointId)
	);
	
	CREATE INDEX  PPO_POINTID ON 
	PushPerformanceOpen(pointId);
	
	CREATE INDEX  PPD_POINTID ON 
	PushPerformanceDelivery(pointId);
	
	CREATE INDEX  PPS_POINTID ON 
	PushPerformanceSent(pointId);
	
	CREATE INDEX  PPO_JOURNEYID ON 
	PushPerformanceOpen(JOURNEYID);
	
	CREATE INDEX  PPD_JOURNEYID ON 
	PushPerformanceDelivery(JOURNEYID);
	
	CREATE INDEX  PPS_JOURNEYID ON 
	PushPerformanceSent(JOURNEYID);
