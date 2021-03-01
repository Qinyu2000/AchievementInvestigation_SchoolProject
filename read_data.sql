SET SEARCH_PATH TO change;

-- Import Data for Board
\Copy Board FROM './Board.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for School
\Copy School FROM './School.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for Household
\Copy Household FROM './Household.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for Enrollment
\Copy Enrolment FROM './Enrollment.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for Language
\Copy Language FROM './Language.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for ElementaryAchievement
\Copy ElementaryAchievement FROM './ElementaryAchievement.csv' With CSV DELIMITER ',' HEADER;

-- Import Data for SecondaryAchievement
\Copy SecondaryAchievement FROM './SecondaryAchievement.csv' With CSV DELIMITER ',' HEADER;