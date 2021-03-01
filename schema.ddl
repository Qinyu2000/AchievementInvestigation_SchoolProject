drop schema if exists change cascade; -- You can choose a different schema name.
create schema change;
set search_path to change;

CREATE TYPE change.school_type AS ENUM (
	'Public', 'Catholic', 'Hospital', 'Protestant Separate', 'Provincial'
);

-- we only invastigate in elementary and secondary achievement
CREATE TYPE change.level_type AS ENUM(
    'Elementary', 'Secondary'
);

-- The board that schools belong to 
-- each row represents the name and type of the board of this id
CREATE Table Board(
    -- the id of the board. Since all the board id has 6 characters, we add
    -- char(6) constraint
    boardID char(6) PRIMARY KEY NOT NULL,
    -- the name of the board
    name text NOT NULL,
    -- the type of the board
    type text NOT NULL);

-- The schools 
-- each row represents the contact information and some basic information 
-- about the school of this school id
CREATE Table School(
    -- the id of the school, this is the most important data which refers
    -- to many other table
    school int PRIMARY KEY NOT NULL,
    -- the phone number of the school. 
    phoneNum text,
    -- the name of the school
    name text NOT NULL,
    -- the type of the school
    type school_type NOT NULL,
    -- the level of the school
    level level_type NOT NULL,
    -- the main language of the school
    language text NOT NULL,
    -- the boardID of the board that the school belongs to 
    boardID text NOT NULL,
    -- the city that school is in 
    city text NOT NULL,
    -- the postcode of the school
    postCode text NOT NULL,
    FOREIGN KEY(boardID) references Board(boardID) on delete cascade);

-- the enrolment of the school
-- each row represents the percentage of talented students enrolled in this
-- school with this amount of students
CREATE Table Enrolment(
    -- the id of the school
    school int PRIMARY KEY NOT NULL,
    -- the number of students enrolled in that school
    eNum int NOT NULL,
    -- the percentage of students is talent at that school
    giftPercentage int NOT NULL,
    FOREIGN KEY(school) references School on delete cascade);

-- the students' household of that school
-- each row represents the students' household information at this school
CREATE Table Household(
    -- the id of the school
    school int PRIMARY KEY NOT NULL ,
    -- the percentage of school-aged children who live in low-income households
    lowIncome int NOT NULL,
    -- the percentage of students whose parents have some university education
    parentEdu int NOT NULL,
    FOREIGN KEY(school) references School on delete cascade);

-- the students' first language 
-- each row represents this school has this percentage of students whose 
-- first language is notEnglish or notFrench
CREATE Table Language(
    -- the id of the school
    school int PRIMARY KEY NOT NULL,
    -- percentage of students whose first language is not English
    notEnglish int NOT NULL,
    -- percentage of students who comes from non-English speaking country
    fromNonEnglish int NOT NULL,
    -- percentage of students whose first language is not French
    notFrench int NOT NULL,
    -- percentage of students who comes from non-french speaking country
    fromNonFrench int NOT NULL,
    FOREIGN KEY(school) references School on delete cascade);

-- the achievements in the elementary school
-- each row represents this school has this percentage of students achieve
-- in the reading/writing/math with this amount change in grades over 3 years 
CREATE Table ElementaryAchievement(
    -- the id of the school 
    school int PRIMARY KEY,
    -- percentage of students achieve the provinical standard in reading
    readingAchieve float NOT NULL,
    -- the change (in percentage points) of achievement in reading over 3 years
    readingChange int NOT NULL,
    -- percentage of students achieve the provinical standard in writing
    writingAchieve float NOT NULL,
    -- the change (in percentage points) of achievement in writing over 3 years
    writingChange int NOT NULL,
    -- percentage of students achieve the provinical standard in math
    mathAchieve float NOT NULL,
    -- the change (in percentage points) of achievement in math over 3 years
    mathChange int NOT NULL,
    FOREIGN KEY(school) references School on delete cascade);

-- the achievements in the secondary school 
-- each row represents this school has this percentage of students achieve
-- in academicMath/appliedMath/osslt with this amount change in grades over 3
-- years
CREATE Table SecondaryAchievement(
    -- the id of the school 
    school int PRIMARY KEY NOT NULL,
    -- percentage of students achieve the provinical standard in academic math
    academicMathAchieve float NOT NULL,
    -- the change (in percentage points) of achievement in math over 3 years
    academicMathChange int NOT NULL,
    -- percentage of students achieve the provinical standard in applied math
    appliedMathAchieve float ,
    -- the change (in percentage points) of achievement in appmath over 3 years
    appliedMathChange float ,
    -- percentage of students pass the osslt test 
    ossltPass float NOT NULL,
    -- the change (in percentage points) of students pass osslt over 3 years
    ossltChange int NOT NULL,
    FOREIGN KEY(school) references School on delete cascade);