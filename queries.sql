SET SEARCH_PATH TO change, public;

-- below is the query addressing the Q1:
-- the table that compare high talent students' achievement with
-- low talent students' achievement in elementaryschool
DROP TABLE IF EXISTS elemenTalent CASCADE;
CREATE TABLE elemenTalent(
    talentType text,
    readingAchieveAvg float ,
    readingChangeAvg float ,
    writingAchieveAvg float ,
    writingChangeAvg float ,
    mathAchieveAvg float ,
    mathChangeAvg float,
    numSchool int
);

-- the table that compare high talent students' achievement with
-- low talent students' achievement in secondaryschool
DROP TABLE IF EXISTS secondaryTalent CASCADE;
CREATE TABLE secondaryTalent(
    talentType text,
    academicMathAchieveAvg float,
    academicMathChangeAvg float,
    appliedMathAchieveAvg float,
    appliedMathChangeAvg float,
    ossltPassAvg float,
    ossltChangeAvg float,
    numSchool int
);

-- record whether the school has the most amount of talent students or not
-- the talentType is high if giftpercentage > 0.75 * average
-- mediate if 0.75 * average =< giftpercentage <= 1.25 * average
-- low if giftpercentage is < 1.25 * average
DROP VIEW IF EXISTS TalentType CASCADE;
CREATE VIEW TalentType AS
     SELECT school, 
     CASE
     WHEN giftpercentage < 0.75 * giftavg
     THEN 'low'
     WHEN giftpercentage >= 0.75 * giftavg
         AND giftpercentage <= 1.25 * giftavg
     THEN 'mediate'
     WHEN giftpercentage > 1.25 * giftavg
     THEN 'high'
     ELSE NULL
     END AS talentType
     FROM enrolment, (
         SELECT avg(giftpercentage) as giftavg
         FROM enrolment
     ) as eleavg; 

INSERT INTO elemenTalent
       SELECT talentType, avg(readingAchieve), avg(readingChange), 
       avg(writingAchieve), avg(writingChange), avg(mathAchieve), 
       avg(mathChange), count(*)
       FROM TalentType JOIN ElementaryAchievement 
           ON TalentType.school = ElementaryAchievement.school
       GROUP BY talentType;

INSERT INTO secondaryTalent
       SELECT talentType, avg(academicMathAchieve), avg(academicMathChange),
       avg(appliedMathAchieve), avg(appliedMathChange), avg(ossltPass),
       avg(ossltChange), count(*)
       FROM TalentType JOIN SecondaryAchievement 
           ON TalentType.school = SecondaryAchievement.school
       GROUP BY talentType;

---------  Q1 queries --------
-- SELECT * FROM elemenTalent;
-- SELECT * FROM secondaryTalent;


-- below is the query addressing the Q2:
DROP VIEW IF EXISTS lowIncome_Ele_read cascade;
DROP VIEW IF EXISTS lowincome_ele_avg cascade;
DROP VIEW IF EXISTS lowIncome_Ele_low_lt_15_avg cascade;
DROP VIEW IF EXISTS lowIncome_Ele_low_gt_30_avg cascade;
DROP VIEW IF EXISTS lowIncome_Sec_read cascade;
DROP VIEW IF EXISTS lowincome_Sec_avg cascade;
DROP VIEW IF EXISTS lowIncome_Sec_low_lt_15_avg cascade;
DROP VIEW IF EXISTS lowIncome_Sec_low_gt_30_avg cascade;

-- Average achievements in Elementary Schools
CREATE VIEW lowIncome_Ele_avg AS 
  SELECT 'average' AS income, avg(E.readingachieve) AS read , 
         avg(E.writingachieve) AS write, avg(E.mathachieve) AS math 
  FROM Household H, Elementaryachievement E  
  WHERE H.school = E.school;

-- The achievements in Elementary Schools which have 
-- less than 15% low-income households
CREATE VIEW lowIncome_Ele_low_lt_15_avg AS 
  SELECT 'lowIncome < 15%' AS income, avg(E.readingachieve) AS read , 
         avg(E.writingachieve) AS write, avg(E.mathachieve) AS math 
  FROM Household H, Elementaryachievement E  
  WHERE H.school = E.school AND H.lowincome < 15;

-- The achievements in Elementary Schools which have 
-- greater than 30% low-income households
CREATE VIEW lowIncome_Ele_low_gt_30_avg AS 
  SELECT 'lowIncome > 30%' AS income, avg(E.readingachieve) AS read ,
         avg(E.writingachieve) AS write, avg(E.mathachieve) AS math 
  FROM Household H, Elementaryachievement E  
  WHERE H.school = E.school AND H.lowincome > 30;


-- Average achievements in Secondary Schools
CREATE VIEW lowIncome_Sec_avg AS 
  SELECT 'average' AS income, avg(S.academicmathachieve) AS acad , 
        avg(S.appliedmathachieve) AS applied, avg(S.ossltpass) AS osslt 
  FROM Household H, Secondaryachievement S  
  WHERE H.school = S.school;

-- The achievements in Secondary Schools which have 
-- less than 15% low-income households
CREATE VIEW lowIncome_Sec_low_lt_15_avg AS 
  SELECT 'lowIncome < 15%' AS income, avg(S.academicmathachieve) AS acad ,
         avg(S.appliedmathachieve) AS applied, avg(S.ossltpass) AS osslt 
  FROM Household H, Secondaryachievement S  
  WHERE H.school = S.school AND H.lowincome < 15;

-- The achievements in Secondary Schools which have 
-- greater than 30% low-income households
CREATE VIEW lowIncome_Sec_low_gt_30_avg AS 
  SELECT 'lowIncome > 30%' AS income, avg(S.academicmathachieve) AS acad , 
         avg(S.appliedmathachieve) AS applied, avg(S.ossltpass) AS osslt 
  FROM Household H, Secondaryachievement S  
  WHERE H.school = S.school AND H.lowincome > 30;

---------  Q2 queries --------
-- SELECT * FROM lowIncome_Ele_low_lt_15_avg E;
-- SELECT * FROM lowIncome_Ele_avg;
-- SELECT * FROM lowIncome_Ele_low_gt_30_avg;
-- SELECT * FROM lowIncome_Sec_low_lt_15_avg;
-- SELECT * FROM lowIncome_Sec_avg;
-- SELECT * FROM lowIncome_Sec_low_gt_30_avg;


-- below is the query addressing the Q3:
-- the table that compares English-speaking students' achievement with 
DROP TABLE IF EXISTS elementlanguagecompare CASCADE;
CREATE TABLE elementlanguagecompare(
    languageType text,
    readingAchieveAvg float ,
    readingChangeAvg float ,
    writingAchieveAvg float ,
    writingChangeAvg float ,
    mathAchieveAvg float ,
    mathChangeAvg float,
    numSchool int
);

DROP TABLE IF EXISTS secondarylanguagecompare CASCADE;
CREATE TABLE secondarylanguagecompare(
    languageType text,
    academicMathAchieveAvg float,
    academicMathChangeAvg float,
    appliedMathAchieveAvg float,
    appliedMathChangeAvg float,
    ossltPassAvg float,
    ossltChangeAvg float,
    numSchool int
);

-- record whether school is a english speaking school or multilanguage school
-- based on the information provided from language
DROP VIEW IF EXISTS languageType CASCADE;
CREATE VIEW languageType AS
     SELECT school,
     CASE
     WHEN notEnglish > 30 OR fromNonEnglish > 30
     THEN 'multiLanguage'
     WHEN notEnglish < 5 AND fromNonEnglish < 5
     THEN 'English'
     ELSE 'MostEnglish'
     END AS languageType
     FROM language;

INSERT INTO elementlanguagecompare
       SELECT languageType, avg(readingAchieve), avg(readingChange), 
       avg(writingAchieve), avg(writingChange), avg(mathAchieve), 
       avg(mathChange), count(*)
       FROM languageType JOIN ElementaryAchievement 
           ON languageType.school = ElementaryAchievement.school
       GROUP BY languageType;
       
INSERT INTO secondarylanguagecompare
       SELECT languageType, avg(academicMathAchieve), avg(academicMathChange),
       avg(appliedMathAchieve), avg(appliedMathChange), avg(ossltPass),
       avg(ossltChange), count(*)
       FROM languageType JOIN SecondaryAchievement  
           ON languageType.school = SecondaryAchievement.school
       GROUP BY languageType;

---------  Q3 queries --------
-- SELECT * FROM elementlanguagecompare;
-- SELECT * FROM secondarylanguagecompare;