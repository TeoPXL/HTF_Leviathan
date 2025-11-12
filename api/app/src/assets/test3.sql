-- ───────────────────────────────────────────────────────────────
-- Seed: Ships
-- ───────────────────────────────────────────────────────────────
INSERT INTO ships (ship_name, home_port)
VALUES ('Horatio', 'New Bedford')
ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);

-- Capture ship id
SET @ship_id := LAST_INSERT_ID();

-- ───────────────────────────────────────────────────────────────
-- Seed: Voyages (Horatio, C. Grant)
-- ───────────────────────────────────────────────────────────────
INSERT INTO voyages (
  ship_id,
  starting_port,
  destination_port,
  captain_name,
  crew_count,
  casualties,
  start_date
) VALUES (
  @ship_id,
  'At sea near Macauley Island (Kermadecs)',
  'Vasquez Ground via Bay of Islands (NZ)',
  'Charles Grant',
  0,
  0,
  '1880-03-24 00:00:00'
);

-- Capture voyage id
SET @voyage_id := LAST_INSERT_ID();

-- ───────────────────────────────────────────────────────────────
-- Seed: Events (with lat / long from log; E positive, W negative)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1880-03-24 00:00:00','Near Macauley Island (Kermadecs)',-30.24,-178.34,'cruising; island in sight','strong breezes','WSW','WNW',JSON_ARRAY(),JSON_OBJECT(),'Macauley Island in sight; 2 sails in sight; Bar. 30.05',0,0),
(@voyage_id,'1880-03-25 00:00:00','Macauley Island & Curtis Rocks (in sight)',-29.56,-178.60,'calms; islands in sight','','','','[]','{}','Curtis Rocks bearing ESE ~15 miles; Bar. 29.90',0,0),
(@voyage_id,'1880-03-26 00:00:00','SW of Kermadecs',-29.59,-178.40,'spoke ships; calm later','light SE','','',JSON_ARRAY(
  JSON_OBJECT('name','California','home_port',NULL,'months_out',40,'barrels',2300),
  JSON_OBJECT('name','Canton','home_port',NULL,'captain','J. Sherman','months_out',18,'barrels',725)
),JSON_OBJECT(),'Beef & Pork; Bar. 29.90',0,0),
(@voyage_id,'1880-03-27 00:00:00','Goat Island (in sight)',-30.24,-179.10,'calms; thick weather','','','','[]','{}','Goat Island bearing E ~25 miles; 1 sail in sight; Bar. 30.05',0,0),
(@voyage_id,'1880-03-28 00:00:00','Cruising WSW of Kermadecs',-30.23,-179.35,'whale sighted','light breezes','S','WSW','[]',JSON_OBJECT('type','sperm','action','sighted','range_mi',4,'result',NULL),'2 sails in sight',0,0),
(@voyage_id,'1880-03-29 00:00:00','SW of Kermadecs',-29.45,-179.55,'lowered & chased; took whale','moderate','SW','',JSON_ARRAY(
  JSON_OBJECT('name','California','home_port',NULL)
),JSON_OBJECT('type','sperm','action','struck & killed','barrels',40,'result','successful'),'Mated with California; AM whales 1 mile SW heading SE',0,0),
(@voyage_id,'1880-03-30 00:00:00','SW of Kermadecs',-30.19,-179.10,'cutting; commenced boiling','moderate','','SW',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','cutting in / boiling','result','processing'),'Took whale alongside 1 pm; finished cutting by 6 am; Bar. 30.10',0,0),
(@voyage_id,'1880-03-31 00:00:00','Near Goat Island',-30.16,-179.10,'finished boiling; struck & killed','light','SE','S',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','lowered; struck & killed','result','successful'),'Finished boiling 33 bbl; took alongside at noon; Goat Island in sight',0,0),
(@voyage_id,'1880-04-01 00:00:00','SW of Kermadecs',-30.20,-178.59,'cutting; boiling','strong','ESE','made NNE at midnight',JSON_ARRAY(
  JSON_OBJECT('name','California','home_port',NULL)
),JSON_OBJECT('type','sperm','action','cutting / trying out','result','processing'),'Macaulay Island bearing E by N ~25 miles; Bar. 30.40',0,0),
(@voyage_id,'1880-04-02 00:00:00','Cruising SW of Curtis Rocks',-30.17,-179.10,'cruising on both tacks','moderate','ESE','',JSON_ARRAY(),JSON_OBJECT(),'1 ship in sight',0,0),
(@voyage_id,'1880-04-03 00:00:00','Off Goat Island',-30.111,-179.00,'stowing down oil (starboard after hold)','moderate','ENE','SE',JSON_ARRAY(),JSON_OBJECT(),'Goat Island in sight; Bar. 30.40',0,0),
(@voyage_id,'1880-04-04 00:00:00','SW of Kermadecs',-30.50,-179.10,'stowed 47 bbl; wore ship N then SE','moderate','ENE','SE',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','watching','result',NULL),'Finished stowing 47 bbl; Bar. 30.11',0,0),
(@voyage_id,'1880-04-05 00:00:00','SW of Kermadecs',-30.39,-179.40,'spoke ship','strong','','NNE',JSON_ARRAY(
  JSON_OBJECT('name','California','home_port',NULL,'months_out',42,'barrels',2250)
),JSON_OBJECT(),'Bar. 30.40',0,0),
(@voyage_id,'1880-04-06 00:00:00','W by S of Kermadecs',-31.00,-179.59,'short sail; 1 sail in sight','moderate','ENE','W by S',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-04-07 00:00:00','SE of 180th meridian',-31.14,179.65,'fitting rigging; California in sight','moderate','ENE','SE',JSON_ARRAY(
  JSON_OBJECT('name','California','home_port',NULL)
),JSON_OBJECT(),'Bar. 30.50',0,0),
(@voyage_id,'1880-04-08 00:00:00','South of 180th meridian',-31.26,-179.50,'in company with California','moderate','ENE','SSE',JSON_ARRAY(
  JSON_OBJECT('name','California','home_port',NULL)
),JSON_OBJECT(),'Bar. 30.119',0,0),
(@voyage_id,'1880-04-09 00:00:00','Cruising',-33.24,-179.42,'cruising; California in sight SW','moderate','NE','SSE',JSON_ARRAY(
  JSON_OBJECT('name','California','home_port',NULL)
),JSON_OBJECT(),'Bar. 30.40',0,0),
(@voyage_id,'1880-04-10 00:00:00','Cruising',-33.26,-179.36,'shortened sail; killed 2 pigs','moderate','NE','SSE',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-04-11 00:00:00','Cruising',-33.26,-179.36,'by the wind; later N & E','moderate','ENE','',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-04-12 00:00:00','Cruising',-33.25,-179.37,'shortened for night; NE','brisk','WSW','NE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.15',0,0),
(@voyage_id,'1880-04-13 00:00:00','South of French Rock',-32.55,-179.27,'lowered 4 boats; lost whale in squall','moderate','','NE; then N; boats down',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','chased; alongside ~100 bbl whale','result','no fast'),'Thunder, lightning, rain; Bar. 29.80',0,0),
(@voyage_id,'1880-04-14 00:00:00','South of French Rock',-32.44,-179.16,'boats in chase; later gale from S','dark & rainy','S','run S; then WSW; SE',JSON_ARRAY(),JSON_OBJECT(),'Harsh gales overnight; Bar. 29.70',0,0),
(@voyage_id,'1880-04-15 00:00:00','South of French Rock',-32.375,-179.15,'saw whales; down 4 boats; no success','strong gales','S','ESE; WSW',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','boats down; whale to windward','result','no success'),'Bar. 30.20',0,0),
(@voyage_id,'1880-04-16 00:00:00','South of French Rock',-32.24,-179.18,'whales seen; no catch','strong','S','',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','sightings','result','no success'),'Pleasant later; 1 sail in sight',0,0),
(@voyage_id,'1880-04-17 00:00:00','South of French Rock',-32.28,-179.00,'down 4 boats; whale avoided','moderate','SE','',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','lowered; whale saw boats & went to windward','result','no success'),'Repaired mizzen t’gallant sail',0,0),
(@voyage_id,'1880-04-18 00:00:00','South of French Rock',-32.26,-179.15,'steering S; then NE','moderate','SE','',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-04-19 00:00:00','South of French Rock',-31.55,-179.00,'repairing fore topsails','moderate','ESE','SSW / NE','[]','{}','French Rock N by W ~8 mi; Bar. 30.34',0,0),
(@voyage_id,'1880-04-20 00:00:00','South of French Rock',-32.10,-179.56,'repairing mainsail; looking for sperm whales','strong','SE','SSW / NE',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-04-21 00:00:00','South of French Rock',-31.55,-179.58,'repairing main t’gallant sail','moderate','SE','SSW / ENE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.60',0,0),
(@voyage_id,'1880-04-22 00:00:00','South of French Rock',-31.57,-179.60,'steering SW under short sail','strong','S','SW',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-04-23 00:00:00','South of French Rock',-31.40,-179.65,'repairing jib; short sail','strong','S','both tacks',JSON_ARRAY(),JSON_OBJECT(),'Longitude in log appears “189.65 W”; normalized to 179.65 W',0,0),
(@voyage_id,'1880-04-24 00:00:00','South of French Rock',-31.16,-179.16,'breaking out water & provisions','strong','SE','NE by E',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-04-25 00:00:00','South of French Rock',-31.04,-179.65,'spoke ship','strong','SE','NE',JSON_ARRAY(
  JSON_OBJECT('name','James Arnold','home_port',NULL,'captain','Tilson','months_out',18.5,'barrels',950)
),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-04-26 00:00:00','South of French Rock',-31.26,-179.66,'in company with above ship','strong','SE','NE & SSW',JSON_ARRAY(
  JSON_OBJECT('name','James Arnold','home_port',NULL)
),JSON_OBJECT(),'Bar. 30.30',0,0),
(@voyage_id,'1880-04-27 00:00:00','South of French Rock',-31.37,-179.57,'strong winds; short sail','strong','SE','NE by E / S',JSON_ARRAY(),JSON_OBJECT(),'Longitude in log “179.W57”; parsed as 179.57 W',0,0),
(@voyage_id,'1880-04-28 00:00:00','South of French Rock',-32.17,178.59,'strong ESE; steering NE','strong','ESE','S -> NE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.60',0,0),
(@voyage_id,'1880-04-29 00:00:00','South of French Rock',-32.27,178.59,'cleaning ship inside','moderate','ESE','NE; wore S at night',JSON_ARRAY(
  JSON_OBJECT('name','James Arnold','home_port',NULL)
),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-04-30 00:00:00','South of French Rock',-32.17,179.10,'cruising NE','moderate','ESE','NE',JSON_ARRAY(
  JSON_OBJECT('name','James Arnold','home_port',NULL)
),JSON_OBJECT(),'Bar. 30.40',0,0),
(@voyage_id,'1880-05-01 00:00:00','En route toward New Zealand',-32.27,179.01,'painting inside; looking for sperm whales','moderate','ESE','S then SW by W',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.60',0,0),
(@voyage_id,'1880-05-02 00:00:00','En route toward New Zealand',-33.41,177.31,'fresh breeze; SW by W','breezes','ESE','SW by W',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.30',0,0),
(@voyage_id,'1880-05-03 00:00:00','Off Cape Brett (NZ)',-36.52,176.37,'made Cape Brett; painting inside','strong','ENE','SW by S',JSON_ARRAY(),JSON_OBJECT(),'Cape Brett bearing SW by S ~40 miles; Bar. 30.30',0,0),
(@voyage_id,'1880-05-04 00:00:00','Bay of Islands (NZ)',-35.23,174.12,'came to anchor (7 fathoms)','moderate','NE->calms','SW','[]','{}','Estimated Bay of Islands coords; got anchors off chains en route',0,0),
(@voyage_id,'1880-06-17 00:00:00','Depart Bay of Islands (NZ)',-35.24,174.25,'got underway; steered out to sea (WSW)','calm -> light','WSW','out to sea',JSON_ARRAY(),JSON_OBJECT(),'Cape Brett bearing NE ~7 miles',0,0),
(@voyage_id,'1880-06-18 00:00:00','NE of NZ coast',-31.25,176.40,'squally; split fore topsail & main t’gallant','light -> squalls','SW -> NNW -> SE','NNE / NE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.05',0,0),
(@voyage_id,'1880-06-19 00:00:00','E of NZ',-33.39,178.06,'strong winds; fitting boats; unbent fore topsail','strong','NNW -> SW','NE by N',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.90',0,0),
(@voyage_id,'1880-06-20 00:00:00','E of NZ',-32.20,179.10,'steering NE by N; issued slops','moderate','SW','NE by N',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.10',0,0),
(@voyage_id,'1880-06-21 00:00:00','Bound to Vasquez Ground',-31.60,-178.65,'shortened sail; thick weather','moderate','W','NE by N / ENE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.00',0,0),
(@voyage_id,'1880-06-22 00:00:00','W of 180th meridian',-30.45,-177.18,'strong winds; under short sail; later made sail','strong','N','E / ENE',JSON_ARRAY(),JSON_OBJECT(),'Clear later',0,0),
(@voyage_id,'1880-06-23 00:00:00','W of 180th meridian',-29.21,-176.15,'short sail; sail work','strong','NW','NNE',JSON_ARRAY(),JSON_OBJECT(),'Thick weather; Bar. 29.95',0,0),
(@voyage_id,'1880-06-24 00:00:00','W of 180th meridian',-28.50,-175.40,'repairing sails; by the wind NNE','strong','NW','NNE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.95',0,0),
(@voyage_id,'1880-06-25 00:00:00','W of 180th meridian',-27.60,-175.00,'squally; started on cask/bread','moderate','N & W','',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.95',0,0),
(@voyage_id,'1880-06-26 00:00:00','W of 180th meridian',-26.50,-175.15,'light winds; thunder & lightning at night','light','NW','NE & NNE',JSON_ARRAY(),JSON_OBJECT(),'Pleasant later; wind W in AM; Bar. 30.05',0,0),
(@voyage_id,'1880-06-27 00:00:00','W of 180th meridian',-26.00,-175.55,'repairing sail; bent main topsail','light','WSW','both tacks',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.00',0,0),
(@voyage_id,'1880-06-28 00:00:00','W of 180th meridian',-25.55,-175.18,'light winds; steering ENE','light','SW & S','ENE',JSON_ARRAY(),JSON_OBJECT(),'Looking sharp for sperm whales; Bar. 30.10',0,0),
(@voyage_id,'1880-06-29 00:00:00','W of 180th meridian',-25.40,-176.00,'moderate breezes S; coopered bread; launched starboard boat','moderate','S','WSW',JSON_ARRAY(),JSON_OBJECT(),'Sea made her & sent her out; Bar. 30.10',0,0),
(@voyage_id,'1880-06-30 00:00:00','W of 180th meridian',-25.40,-175.02,'calm; head in on both tacks','calm','','both tacks',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.10',0,0);


-- ───────────────────────────────────────────────────────────────
-- Events: July 1880 — Horatio (C. Grant) on the Vasquez Ground
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1880-07-01 00:00:00','Vasquez Ground (W of 180°)',-25.11,-175.10,'painting starboard boat; tobacco issued','light breezes','N→NW→S','NE then E',JSON_ARRAY(),JSON_OBJECT(),'Monthly tobacco; “Same time” note in margin.',0,0),
(@voyage_id,'1880-07-02 00:00:00','Vasquez Ground',-25.15,-174.40,'repairing fore/main topsail','light breezes','S','E by N; WSW (AM)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.15',0,0),
(@voyage_id,'1880-07-03 00:00:00','Vasquez Ground',-25.00,-174.22,'finished topsail; cruising','moderate','S','WSW',JSON_ARRAY(),JSON_OBJECT(),'Date normalized from “Saturday 2” → Saturday, July 3.',0,0),
(@voyage_id,'1880-07-04 00:00:00','Vasquez Ground',-25.08,-175.10,'cruising; changed tacks','moderate','ENE?','WSW → N → WSW',JSON_ARRAY(),JSON_OBJECT(),'Lat read “By DA 2508 S”. Interpreted as 25.08°S. Bar. 30.15',0,0),
(@voyage_id,'1880-07-05 00:00:00','Vasquez Ground',-25.50,-175.50,'cruising; rainy at times','moderate','NE','WSW → SSE → WSW',JSON_ARRAY(),JSON_OBJECT(),'“Water 9 am.”',0,0),
(@voyage_id,'1880-07-06 00:00:00','Vasquez Ground',-26.17,-175.24,'whales seen (no lowering noted)','strong winds','N','WSW (short sail); both tacks later',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','sighted','range_mi',2,'result','bound S'),'',0,0),
(@voyage_id,'1880-07-07 00:00:00','Vasquez Ground',-26.40,-175.27,'cruising; looking sharp for whales','strong','SW','both tacks',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.05',0,0),
(@voyage_id,'1880-07-08 00:00:00','Vasquez Ground',-26.41,-176.10,'cruising; weather eased later','strong → light & fine','S','',JSON_ARRAY(),JSON_OBJECT(),'Longitude “76 10 W” normalized to 176.10 W. “10 Beef” (provisions). Bar. 30.25',0,0),
(@voyage_id,'1880-07-09 00:00:00','Vasquez Ground',-26.50,-175.29,'bent fore topgallant; cruising E','light','S','E',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.15',0,0),
(@voyage_id,'1880-07-10 00:00:00','Vasquez Ground',-25.45,-175.40,'shortened for night; cruising','moderate','SE','E',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.10',0,0),
(@voyage_id,'1880-07-11 00:00:00','Vasquez Ground',-25.37,-175.18,'changed tacks; made all sail AM','moderate','SE','SW → N',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.1x (illegible last digit).',0,0),
(@voyage_id,'1880-07-12 00:00:00','Vasquez Ground',-24.40,-174.59,'provisioned (flour, sugar, water); cruising','moderate','SE','NNE',JSON_ARRAY(),JSON_OBJECT(),'Longitude “194.59 W” corrected to 174.59 W.',0,0),
(@voyage_id,'1880-07-13 00:00:00','Vasquez Ground',-24.28,-175.00,'looking sharp for sperm whales','moderate → strong → fine','ENE→N','N → S (night)',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','watching','result',NULL),'—',0,0),
(@voyage_id,'1880-07-14 00:00:00','Vasquez Ground',-24.41,-175.00,'shortened for night; strong winds later','moderate → strong','N','S',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-07-15 00:00:00','Vasquez Ground',-25.45,-175.50,'short sail; mizzen topsail work','strong breezes','SE','SW',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-07-16 00:00:00','Vasquez Ground',-26.12,-176.25,'short sail; finbacks seen','strong winds','SE','SW → NE (AM)',JSON_ARRAY(),JSON_OBJECT('type','finback','action','sighted','result',NULL),'“leent the Mizzen Topsail” (bent).',0,0),
(@voyage_id,'1880-07-17 00:00:00','Vasquez Ground',-26.03,-176.11,'opening sail; varied courses','strong breezes','SE','NE (PM) → S (evening)',JSON_ARRAY(),JSON_OBJECT(),'Longitude “196.11 W” corrected to 176.11 W; unclear “hog 160” note retained in margin.',0,0),
(@voyage_id,'1880-07-18 00:00:00','Vasquez Ground',-25.55,-176.50,'made all sail; pleasant','strong breezes easing','SE','NNE',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-07-19 00:00:00','Vasquez Ground',-25.29,-177.15,'lowered 4 boats; took 4 whales; cutting','moderate','ESE','NNE → S (AM)',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','lowered; struck 4; took 4 alongside','whales',4,'result','successful'),'Finished cutting by ~12; bread issued.',0,0),
(@voyage_id,'1880-07-20 00:00:00','Vasquez Ground',-25.49,-176.48,'commenced boiling','moderate','ESE→E','SSE (short sail) → NE (AM)',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','trying out','result','processing'),'—',0,0),
(@voyage_id,'1880-07-21 00:00:00','Vasquez Ground',-25.17,-176.37,'finished boiling 60 bbl; made sail','moderate','ESE','NE; both tacks',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','finished boiling','barrels',60,'result','on board'),'Longitude in log “170.37 W” likely 176.37 W (sequence). Bar. 30.20',0,0),
(@voyage_id,'1880-07-22 00:00:00','Vasquez Ground',-25.11,-176.35,'shortened for night; altered course with wind shift','light','E→NE','S → ESE → SW by S',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.15',0,0),
(@voyage_id,'1880-07-23 00:00:00','Vasquez Ground',-25.11,-176.30,'coopering & stowing oil (port side main hold)','light','NE','SW by S',JSON_ARRAY(),JSON_OBJECT(),'Beef 11 pm note; shortened for night.',0,0),
(@voyage_id,'1880-07-24 00:00:00','Vasquez Ground',-25.11,-176.35,'finished stowing 55 bbl; sighted large steamship; strong gale later','moderate → strong gale','N → SW','WSW (short) → SE/NW → SSE (stern sail)',JSON_ARRAY(JSON_OBJECT('name','large steam ship','home_port',NULL,'direction','SW')),JSON_OBJECT(),'Entry labeled “Saturday 26” normalized to Saturday, July 24. Bar. 29.80',0,0),
(@voyage_id,'1880-07-25 00:00:00','Vasquez Ground',-25.19,-176.37,'hard gale; bosun’s boat stove by sea; recovered wreck','hard gale; heavy sea','WSW','S (stern sail)',JSON_ARRAY(),JSON_OBJECT(),'Log shows longitude “N.” corrected to W; recovered boat wreck with whale meat & bread.',0,0),
(@voyage_id,'1880-07-26 00:00:00','Vasquez Ground',-25.01,-175.35,'fitting a new boat; land made (noted)','strong → moderate','SW','SSE',JSON_ARRAY(JSON_OBJECT('name','unknown sail','home_port',NULL,'relative_bearing','NNW')),JSON_OBJECT(),'Provisions issued: flour, molasses, vinegar. Bar. 30.10',0,0),
(@voyage_id,'1880-07-27 00:00:00','Vasquez Ground',-25.18,-174.50,'carpenter making new ______ and boat sail; both tacks','strong → moderate','SE','NNE',JSON_ARRAY(),JSON_OBJECT(),'Illegible item (spar/beam?) noted as “new ____”. Bar. 30.10',0,0),
(@voyage_id,'1880-07-28 00:00:00','Vasquez Ground',-25.30,-174.19,'cut out new boat; fitting new boat','strong breezes','ESE','NE (short sail)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.15',0,0),
(@voyage_id,'1880-07-29 00:00:00','Vasquez Ground',-25.01,-173.30,'both tacks; cruising ENE under all sail','moderate','S→E','ENE; both tacks',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-07-30 00:00:00','Vasquez Ground',-24.45,-173.33,'shortened for night; then SW','moderate','ENE','NW → SW',JSON_ARRAY(),JSON_OBJECT(),'“Water 11 am 31” marginal note.',0,0),
(@voyage_id,'1880-07-31 00:00:00','Vasquez Ground',-24.40,-174.00,'changed between NNW/S/ NW; routine cruising','moderate','ENE','NNW → S → NW',JSON_ARRAY(),JSON_OBJECT(),'Cask/Pork/12 am notes in margin; Bar. 30.15',0,0);


-- ───────────────────────────────────────────────────────────────
-- Events: August 1880 — Horatio (C. Grant)
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1880-08-01 00:00:00','Vasquez Ground',-25.09,-175.15,'routine cruising; shortened at night; weather shifts','moderate; rainy early','NE→N→S','NW → ESE → SW',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-08-02 00:00:00','Vasquez Ground',-25.17,-176.29,'making a new mast; routine cruising','moderate','SSE','SW',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-08-03 00:00:00','Vasquez Ground',-25.25,-176.25,'new bow boat noted; cruising SSW','moderate','SE','SSW',JSON_ARRAY(),JSON_OBJECT(),'Text “DUSIL…with halyards” unclear; recorded as new bow boat seen/rigged.',0,0),
(@voyage_id,'1880-08-04 00:00:00','Vasquez Ground',-25.27,-177.00,'shipped the new mast; bread issued 10am','moderate','ESE','SSW → SW (AM)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.15',0,0),
(@voyage_id,'1880-08-05 00:00:00','Vasquez Ground (estimated)',-25.30,-176.80,'fine weather; provisions (beef) 2pm','strong breezes last 4 days; fine now','NE','',JSON_ARRAY(),JSON_OBJECT(),'No position in log; estimated from track between 8/4 and 8/6.',0,0),
(@voyage_id,'1880-08-06 00:00:00','Vasquez Ground',-26.29,-176.30,'strong gales; hand rudder for topsail','moderate → strong gales; rainy','NE → strong','NNW → ESE (night); short sail',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.85',0,0),
(@voyage_id,'1880-08-07 00:00:00','Vasquez Ground',-26.40,-176.00,'made sail; steering NE after gale','strong gales; rain; then W winds','N → W','NE',JSON_ARRAY(),JSON_OBJECT(),'Longitude “76.00 W” normalized to 176.00 W. Bar. 29.75',0,0),
(@voyage_id,'1880-08-08 00:00:00','Vasquez Ground',-25.50,-174.59,'topsails; strong SW gusts; then moderate','moderate → strong gusts → moderate','W → SW','NE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.80',0,0),
(@voyage_id,'1880-08-09 00:00:00','Vasquez Ground',-25.01,-173.45,'made all sail; pleasant later','strong → moderate & pleasant','WSW','NNW → N',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.95',0,0),
(@voyage_id,'1880-08-10 00:00:00','Vasquez Ground',-24.08,-174.35,'shortened for night; then NNW','moderate','SW','NNW',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.1x',0,0),
(@voyage_id,'1880-08-11 00:00:00','Near ‘Eua (Tonga)',-21.29,-174.50,'made ‘Eua (island) in sight ~35 mi','moderate','SW','NNW → ENE/E (night)',JSON_ARRAY(),JSON_OBJECT(),'Saw Island of ‘Eua bearing NW ~35 miles.',0,0),
(@voyage_id,'1880-08-12 00:00:00','Off Tongatapu (approaches)',-21.20,-175.00,'boarded by canoe; trading produce; bound in','moderate','ESE → NE','NW → N',JSON_ARRAY(JSON_OBJECT('name','local canoe','home_port','Tongatapu','crew',3,'goods','coconuts, potatoes, “mom apples”')),JSON_OBJECT(),'Position estimated near Tongatapu approaches.',0,0),
(@voyage_id,'1880-08-13 00:00:00','Tongatapu (Nuku‘alofa Harbor)',-21.14,-175.20,'entered & anchored; bent chain; anchor off bow','strong breezes','E','N → W (maneuvering)',JSON_ARRAY(),JSON_OBJECT(),'Anchored in “Tonga harbor” ~12 fathoms.',0,0),
(@voyage_id,'1880-08-14 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'coopering oil; trading for yams & barrels','strong winds','ESE','at anchor',JSON_ARRAY(),JSON_OBJECT(),'Day label in log “Saturday 24.” normalized to Sat Aug 14.',0,0),
(@voyage_id,'1880-08-15 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'at anchor; fine weather','fine','ESE','',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-08-16 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'coopering oil (ongoing)','fine','—','',JSON_ARRAY(),JSON_OBJECT(),'Some text illegible; summarized.',0,0),
(@voyage_id,'1880-08-17 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'coopering oil; trading','fine','—','',JSON_ARRAY(),JSON_OBJECT(),'Illegible quantities; trading for produce.',0,0),
(@voyage_id,'1880-08-18 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'coopering oil; trading for yams','fine','—','',JSON_ARRAY(),JSON_OBJECT(),'Quantities (e.g., “50”) unclear.',0,0),
(@voyage_id,'1880-08-19 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'coopering oil; (illegible: hotel? jack? yams?)','fine','—','',JSON_ARRAY(),JSON_OBJECT(),'Text largely illegible; recorded as coopering & trading.',0,0),
(@voyage_id,'1880-08-20 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'at anchor; fine weather','fine','—','',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-08-21 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'coopering oil (ongoing)','fine','—','',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-08-22 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'at anchor; fine weather','fine','—','',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-08-23 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'at anchor; fine weather','fine','—','',JSON_ARRAY(),JSON_OBJECT(),'Date has “?” in log; normalized by calendar.',0,0),
(@voyage_id,'1880-08-24 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'(illegible) emptied / filled? goods in hold?','fine','—','',JSON_ARRAY(),JSON_OBJECT(),'Log says “Tuesday 23?”; set to Tue Aug 24 by calendar.',0,0),
(@voyage_id,'1880-08-25 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'fine weather; work about ship','fine','—','',JSON_ARRAY(),JSON_OBJECT(),'Header “at Tongataboo Friendly Islands.”',0,0),
(@voyage_id,'1880-08-26 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'got hats; discharged Thomas (sick); paid $45; advanced $20','fine','—','',JSON_ARRAY(),JSON_OBJECT(),'Log line labeled “Thursday 25” corrected to Thu Aug 26.',0,0),
(@voyage_id,'1880-08-27 00:00:00','Tongatapu (anchored)',-21.14,-175.20,'fine weather; shipped water/wood (illegible qty)','fine','—','',JSON_ARRAY(),JSON_OBJECT(),'Log labeled “Friday 26”; corrected to Fri Aug 27. Many terms illegible; summarized.',0,0),
(@voyage_id,'1880-08-28 00:00:00','Depart Tongatapu',-21.14,-175.20,'got under way; made out to sea; reefed; steering SW','strong wind; cloudy','E','departed harbor; SW',JSON_ARRAY(),JSON_OBJECT(),'Departure aligns with calendar Sun Aug 28.',0,0),
(@voyage_id,'1880-08-29 00:00:00','South of Tonga',-22.10,-175.50,'strong winds; changed course SSE; made all sail; picked up boat','strong; cloudy','E','SW → SSE',JSON_ARRAY(),JSON_OBJECT(),'Lat “22,,1 S”; Lon “17,,-,,5 W” interpreted as 22.1 S, 175.5 W.',0,0),
(@voyage_id,'1880-08-30 00:00:00','South of Tonga',-23.50,-175.00,'strong ENE→SSE; steering SE→E','strong','ENE→SSE','SE → E',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.10',0,0),
(@voyage_id,'1880-08-31 00:00:00','South of Tonga',-24.00,-175.29,'repairing the stern boat; on various tacks','strong','S','both tacks',JSON_ARRAY(),JSON_OBJECT(),'Log says “Wednesday 31”; actual 1880-08-31 was Tuesday. Bar. 30.15',0,0);


-- ───────────────────────────────────────────────────────────────
-- Events: September 1880 — Horatio (C. Grant)
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
-- Thu "7" → Thu Sep 2 by calendar
(@voyage_id,'1880-09-02 00:00:00','Vasquez Ground',-23.51,-175.09,'provisioned beef, pork & mats; steering SSW','strong wind','E','SSW (all sail)',JSON_ARRAY(),JSON_OBJECT(),'Log shows “Lng 17,,09” → 175.09 W.',0,0),
(@voyage_id,'1880-09-03 00:00:00','Vasquez Ground',-24.58,-174.41,'repairing sails; under studdingsails','strong breezes','E','S by W',JSON_ARRAY(),JSON_OBJECT(),'Longitude “114 41 W” corrected to 174.41 W. Bar. 30.25',0,0),
(@voyage_id,'1880-09-04 00:00:00','Vasquez Ground',-26.00,-175.29,'unbent & repaired fore/main topsail; bent same','strong breezes','ESE','S (short sail)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.41',0,0),
(@voyage_id,'1880-09-05 00:00:00','Vasquez Ground',-26.25,-175.45,'hove to under main topsail; made sail later','strong breeze; cloudy','ESE','S by E; later N (made sail)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.30',0,0),
(@voyage_id,'1880-09-06 00:00:00','Vasquez Ground',-26.27,-175.59,'changed between NNW/SE; shortened for night','strong breezes','ENE','NNW → SE (hove to) → N',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.15',0,0),
(@voyage_id,'1880-09-07 00:00:00','Vasquez Ground',-27.11,-176.10,'hove to under fore/main topsail & staysails; hard gales; cleared by 11:30','strong → hard gales','NE','N → SE (hove to)',JSON_ARRAY(),JSON_OBJECT(),'Barometer written “19.82”; normalized to gale conditions.',0,0),
(@voyage_id,'1880-09-08 00:00:00','Vasquez Ground',-26.50,-170.30,'made all sail; sugar issued 11 am','strong breezes','N→NNW','NE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.88',0,0),
(@voyage_id,'1880-09-09 00:00:00','Vasquez Ground',-26.27,-176.10,'repairing sails; short sail','strong breezes','N→NW','N (short sail)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.98',0,0),
(@voyage_id,'1880-09-10 00:00:00','Vasquez Ground',-26.09,-175.25,'unbent foresail to repair; steering E','strong breezes','S','E (all sail)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.20',0,0),
(@voyage_id,'1880-09-11 00:00:00','Vasquez Ground',-26.22,-175.45,'bent foresail; wore S and shortened; repaired mainsail and bent it','strong breezes; squally later','S','E; wore S (night)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.25',0,0),
-- "Wednesday crossed out" → Sunday Sep 12
(@voyage_id,'1880-09-12 00:00:00','Vasquez Ground',-26.13,-176.00,'repairing fly jib; short sail on both tacks','strong breezes','SSE','both tacks (short)',JSON_ARRAY(),JSON_OBJECT(),'Lat in log “2013 S” → 26.13 S. Bar. 30.10',0,0),
(@voyage_id,'1880-09-13 00:00:00','Vasquez Ground',-26.15,-175.35,'hove ship to the NE in evening','strong breezes','SE','SSW → hove to NE',JSON_ARRAY(),JSON_OBJECT(),'Longitude “195.35 W” corrected to 175.35 W. Bar. 30.10',0,0),
(@voyage_id,'1880-09-14 00:00:00','Vasquez Ground',-25.39,-175.25,'finished spinnaker & fly jib; hove ship to S at 6 pm','strong winds','ESE','NE (day) → S (night)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.10',0,0),
(@voyage_id,'1880-09-15 00:00:00','Vasquez Ground',-25.19,-175.16,'hove ship to S at 5 am; set foresail; varied courses','strong winds','ESE','S → NE (man ship) → S (AM)',JSON_ARRAY(),JSON_OBJECT(),'Lat “25.119” → 25.19 S. Bar. 30.10',0,0),
(@voyage_id,'1880-09-16 00:00:00','Vasquez Ground',-25.58,-170.00,'backed out after hold—oil leak check; issued beef & pork','strong breezes (short sail)','ESE','S → NE (evening) → S (AM)',JSON_ARRAY(),JSON_OBJECT(),'Leak search: “all good” at moment. Bar. 30.10',0,0),
(@voyage_id,'1880-09-17 00:00:00','Vasquez Ground',-26.09,-176.08,'varied courses; strong breezes continue','strong breezes','ESE','S → NE → SE',JSON_ARRAY(),JSON_OBJECT(),'Line contains unclear “this 21”; left note only. Bar. 30.10',0,0),
(@voyage_id,'1880-09-18 00:00:00','Vasquez Ground',-26.32,-176.27,'saw large steamship steering SW; cooper working casks','strong breezes → moderate','E then NE','S by E; later SE by S (all sail)',JSON_ARRAY(JSON_OBJECT('name','large steam ship','home_port',NULL,'direction','SW')),JSON_OBJECT(),'Bar. 30.12',0,0),
(@voyage_id,'1880-09-19 00:00:00','Vasquez Ground',-27.24,-176.30,'made all sail; steering SEly','strong breezes','ENE','SEly S (short → all sail)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.25',0,0),
(@voyage_id,'1880-09-20 00:00:00','Vasquez Ground',-28.21,-171.35,'shortened for night; under all sail AM; new main t’gallant braces','moderate','ENE → NNE','SEly E → E → SEly',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.02',0,0),
(@voyage_id,'1880-09-21 00:00:00','Vasquez Ground',-30.06,-173.07,'broke out after hold; found leaking cask (buckled head); recovered ~100 gal','strong breezes → rain → fine','N → W → N','SEly E; then made all sail',JSON_ARRAY(),JSON_OBJECT('cargo','oil','action','found leak & coopered','leak_gal',100),'“800 lbs oil” soaked out to find faulty cask; rest good. Bar. 30.08',0,0),
(@voyage_id,'1880-09-22 00:00:00','Vasquez Ground',-30.44,-172.18,'light breezes later; made all sail','moderate → light','SW → S','SEly S → ESE',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-09-23 00:00:00','Vasquez Ground',-30.51,-171.51,'by the wind ENE; shortened night; wore S at 10 am','moderate','SE → E → NE','by the wind ENE → S',JSON_ARRAY(),JSON_OBJECT(),'Longitude “171.511 W” → 171.51 W. Bar. 30.25',0,0),
(@voyage_id,'1880-09-24 00:00:00','Vasquez Ground',-31.11,-172.05,'by the wind to the South','strong wind','E','S',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.25',0,0),
(@voyage_id,'1880-09-25 00:00:00','Vasquez Ground',-33.22,-172.45,'shortened night; made sail AM; finback & porpoises seen','strong breezes','E','S (under fore topsail & courses)',JSON_ARRAY(),JSON_OBJECT('type','finback/porpoise','action','sighted','result',NULL),'—',0,0),
(@voyage_id,'1880-09-26 00:00:00','Vasquez Ground',-33.50,-172.30,'various wears; made all sail later','strong breezes','E','S ↔ NNE ↔ S → NE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.18',0,0),
(@voyage_id,'1880-09-27 00:00:00','Vasquez Ground',-33.34,-171.35,'cloudy; multiple course changes; made all sail','strong breeze','SE→S→SW','NE by E → E → ESE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.02',0,0),
(@voyage_id,'1880-09-28 00:00:00','Vasquez Ground',-34.29,-169.40,'clear AM; strong gale mid-morning','strong winds → strong gale','SW','ESE (all sail); shortened at night',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.00',0,0),
(@voyage_id,'1880-09-29 00:00:00','Vasquez Ground',-35.14,-168.40,'more moderate by morning; made sail; beef & pork 4 pm','strong breeze easing','SW → SE','SE by S; later NE',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-09-30 00:00:00','Vasquez Ground',-35.15,-168.14,'setting up S-hooks; calm evening','light → calm → light N','S & E','E (all sail); calm; then light N',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.45',0,0);


-- ───────────────────────────────────────────────────────────────
-- Events: October 1880 — Horatio (C. Grant)
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1880-10-01 00:00:00','Cruising for right whales',-36.39,-167.15,'setting up S-hooks; routine cruising','moderate','NNW','SSE → ESE → SE',JSON_ARRAY(),JSON_OBJECT(),'Log “157.15 W” corrected to 167.15 W (track consistency). Bar. 30.30',0,0),
(@voyage_id,'1880-10-02 00:00:00','Cruising for right whales',-36.45,-167.20,'short sail; sick with asthma at midnight','strong; cloudy → rainy','NNW','SE → W (short) → NE (hove) → NE',JSON_ARRAY(),JSON_OBJECT(),'Flour issued “4 50 bags”. Bar. 30.00',0,0),
(@voyage_id,'1880-10-03 00:00:00','Cruising for right whales',-37.02,-167.29,'short sail; wore to NNE; later steered North','moderate; plenty of rain; later W wind','NW → W','WSW → NNE → N',JSON_ARRAY(),JSON_OBJECT(),'Water noted. Bar. 30.00',0,0),
(@voyage_id,'1880-10-04 00:00:00','Cruising for right whales',-36.12,-165.11,'made & shortened sail; “letting up hooks”; wore SSW','moderate → strong','W','N by W → N; then SSW',JSON_ARRAY(),JSON_OBJECT(),'Longitude “165.11.1” normalized. Bar. 30.5',0,0),
(@voyage_id,'1880-10-05 00:00:00','Cruising for right whales',-36.40,-166.19,'shortened for night; fair weather','moderate','W','SSW',JSON_ARRAY(),JSON_OBJECT(),'Latitude missing in log—interpolated from 10/4 & 10/6 track. Bar. 30.12',0,0),
(@voyage_id,'1880-10-06 00:00:00','Cruising for right whales',-37.09,-167.07,'finished setting up hooks; right whales sighted','moderate','WNW→NW','SW by W; later NNW','[]',JSON_OBJECT('type','right whale','action','sighted','range_mi',1,'heading','to windward','result',NULL),'Butter issued “for this time”. Bar. 30.10',0,0),
(@voyage_id,'1880-10-07 00:00:00','Cruising for right whales',-37.02,-167.10,'down boats; whales took to NW','strong','WNW','SW (PM/AM)',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','lowered; gallied','result','no fast'),'— Bar. 30.05',0,0),
(@voyage_id,'1880-10-08 00:00:00','Cruising for right whales',-37.03,-167.20,'down boats; struck & killed 1; sunk for the night; boiling prep','light → night ops','N','varied; shortened night',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','struck & killed','result','sunk for night'),'Sugar & 1 pr ev gun; sail to NW seen; Bar. 30.10',0,0),
(@voyage_id,'1880-10-09 00:00:00','Cruising for right whales',-37.12,-167.20,'down 2 boats AM; gallied; later struck & killed 1','moderate; fine','W→N','N; later WNW',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','AM lowered (no); PM struck & killed','result','secured'),'Log “107.20 W” corrected to 167.20 W.',0,0),
(@voyage_id,'1880-10-10 00:00:00','Cruising for right whales',-37.03,-167.36,'cutting; commenced boiling; gale later','moderate → gale','SSE','varied; wore SW AM',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','processing; sightings to windward','result','trying out'),'Recovered sunk whale from fore-noon. Bar. 30.05',0,0),
(@voyage_id,'1880-10-11 00:00:00','Cruising for right whales',-36.60,-167.55,'boiling; wore ENE at 11 am','strong gales','SE','SSW → ENE',JSON_ARRAY(),JSON_OBJECT(),'Beef & pork noted. Bar. 30.06',0,0),
(@voyage_id,'1880-10-12 00:00:00','Cruising for right whales',-36.55,-168.19,'finished boiling (~70 bbl?); wore ENE 8am','strong gales','SE','SSW → ENE',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','trying out','barrels',70,'result','finished'),'Bar. 30.00',0,0),
(@voyage_id,'1880-10-13 00:00:00','Cruising for right whales',-36.41,-167.11,'stowing down oil (starboard main hold)','strong gusts → moderate','SSE','ENE (short) → more sail',JSON_ARRAY(),JSON_OBJECT(),'Longitude “167.114 N” corrected to 167.11 W. Bar. 30.20',0,0),
(@voyage_id,'1880-10-14 00:00:00','Cruising for right whales',-37.02,-167.15,'finished stowing 65 bbl; down for whales at noon','moderate','NW','SE → E by S',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','boats down (midday)','result',NULL),'Bar. 30.20',0,0),
(@voyage_id,'1880-10-15 00:00:00','Cruising for right whales',-36.59,-166.14,'struck & killed 1; took alongside; cutting; commenced boiling','moderate','N?→SW','varied; then NW (6am)',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','struck & killed','result','processing'),'Flour noted. Bar. 30.15',0,0),
(@voyage_id,'1880-10-16 00:00:00','Cruising for right whales',-36.44,-166.50,'boiling; varied courses NNW↔S','moderate','W','NNW → S (boiling)',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','trying out','result','ongoing'),'Bar. 30.32',0,0),
(@voyage_id,'1880-10-17 00:00:00','Cruising for right whales (NZ grounds)',-36.37,-166.44,'finished boiling (72 bbl); many whales in sight; no catch','moderate','WSW','S','[]',JSON_OBJECT('type','right whale','action','lowered; gallied; whales out of sight','result','no success'),'Bar. 30.40',0,0),
(@voyage_id,'1880-10-18 00:00:00','Cruising for right whales',-36.50,-166.36,'stirring down oil (starboard main hold)','light','WSW','S by W',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.40',0,0),
(@voyage_id,'1880-10-19 00:00:00','Cruising for right whales',-36.40,-167.19,'finished stirring down (67 bbl); sick crew; whales gallied','light → N wind','WSW→N','S → WNW',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','down boats; gallied','result','no fast'),'2 men sick; 2nd mate with “chits & fever”. Bar. 30.40',0,0),
(@voyage_id,'1880-10-20 00:00:00','Cruising for right whales',-36.51,-167.50,'after right whale; down boats; cleaned bone','brisk; strong later','N','varied: E then WNW at midnight',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','chased; boats down','result','no success'),'Seen whales “11 times… struck 3, sunk 1” (running tally). Bar. 30.20',0,0),
(@voyage_id,'1880-10-21 00:00:00','Cruising for right whales',-35.55,-169.15,'hove to under main topsail; later made all sail','strong; thick; later fine','N → W','WNW (short) → S → made sail',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.20',0,0),
(@voyage_id,'1880-10-22 00:00:00','Cruising for right whales',-37.07,-167.20,'shortened for night; line handled in port boat tub','light → moderate','NW → W','WSW → N',JSON_ARRAY(),JSON_OBJECT(),'Issued 2 casks beef & 8 pork. Bar. 30.20',0,0),
(@voyage_id,'1880-10-23 00:00:00','Cruising for right whales',-37.03,-166.58,'shortened for night; wore SSW; rainy then clear','moderate','W','N → SSW',JSON_ARRAY(),JSON_OBJECT(),'Molasses & vinegar noted. Bar. 30.12',0,0),
(@voyage_id,'1880-10-24 00:00:00','Cruising for right whales',-36.55,-169.15,'hove to at night; made sail AM; on E tack','strong → moderate','SSE','E by wind; hove to; then E (made sail)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.10',0,0),
(@voyage_id,'1880-10-25 00:00:00','Cruising for right whales',-37.02,-166.50,'varied winds; near ship to S; looking sharp','moderate','S → E','N → S',JSON_ARRAY(),JSON_OBJECT(),'Butter noted. Bar. 30.30',0,0),
(@voyage_id,'1880-10-26 00:00:00','Cruising for right whales',-37.40,-167.00,
 'shortened for night; sickness aboard (dropsy)','moderate → rainy','NNW',
 'S by W; then S (AM)',JSON_ARRAY(),                      -- ships_encountered
 JSON_OBJECT(),                                           -- whale_activity (empty)
 JSON_OBJECT('crew_health','master & Antone sick (dropsy)'), -- notes
 0,0),
(@voyage_id,'1880-10-27 00:00:00','Cruising for right whales',-37.40,-166.55,'thick rainy weather; calm/light; sickness persists','light & calm; thick rain','—','—',JSON_ARRAY(),JSON_OBJECT('crew_health','master & Antone sick (dropsy)'),'Bar. 29.80',0,0),
(@voyage_id,'1880-10-28 00:00:00','Cruising for right whales',-38.10,-167.00,'calm & thick rain; most sails furled','calm; thick rain','—','hove/lying under main topsail',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.70',0,0),
(@voyage_id,'1880-10-29 00:00:00','Cruising for right whales',-37.54,-166.04,'both tacks; later moderate & clear','light → moderate & clear','WNW','both tacks',JSON_ARRAY(),JSON_OBJECT(),'Margin “Bredy 1 sum”.',0,0),
(@voyage_id,'1880-10-30 00:00:00','Cruising for right whales',-37.45,-167.09,'short sail; steering NNE','strong breeze','NW','NNE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.0',0,0),
(@voyage_id,'1880-10-31 00:00:00','Cruising for right whales',-37.10,-167.10,'on both tacks; watching for whales; Antone “no worse”','light','WSW','both tacks',JSON_ARRAY(),JSON_OBJECT('crew_health','Antone condition stable'),'Bar. 30.50',0,0);


-- ───────────────────────────────────────────────────────────────
-- Events: November 1880 — Horatio (C. Grant)
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1880-11-01 00:00:00','Cruising for right whales',-37.24,-167.24,'repairing old sail; routine cruising','moderate','SE','S',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-11-02 00:00:00','Cruising for right whales',-37.17,-167.17,'lowered & took one; finished cutting by 11 a.m.','moderate','SE','S',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','struck & took','result','cut in'), 'Ship seen to the south; Bar. 30.46',0,0),
(@voyage_id,'1880-11-03 00:00:00','Cruising for right whales',-37.21,-167.20,'commenced boiling; took another; cutting finished 7 p.m.','moderate; cloudy later','ESE→NNE','S → SE by E / ENE',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','struck & took','result','cut in'), 'Longitude not given; estimated from track. Whales seen SW (AM) and NE (AM next day); Bar. 30.30',0,0),
(@voyage_id,'1880-11-04 00:00:00','Cruising for right whales',-37.33,-167.24,'boiling; hove/altered; strong wind & rain late','moderate → strong with rain','NE→NNE','E / ENE → NW',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','trying out','result','processing'),'Bar. 30.15',0,0),
(@voyage_id,'1880-11-05 00:00:00','Cruising for right whales',-37.33,-167.24,'finished boiling 171 bbl; whales in sight','strong; thick then moderating','NNW','—',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','trying out','barrels',171,'result','finished'),'Position estimated (no coords in log). Bar. 30.30',0,0),
(@voyage_id,'1880-11-06 00:00:00','Cruising for right whales',-37.44,-167.38,'stowing oil; boats down to windward; took up','moderate','W','both tacks',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','boats down','result','no fast'),'—',0,0),
(@voyage_id,'1880-11-07 00:00:00','Cruising for right whales',-37.47,-167.25,'stowing down oil; whales 3 mi NW bound to windward','moderate','WNW','—',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','sighted','range_mi',3,'heading','to windward'),'Bar. 30.20',0,0),
(@voyage_id,'1880-11-08 00:00:00','Cruising for right whales',-37.59,-166.59,'finished stowing 161 bbl; strong gale & high sea later','strong breezes → gale','NW','—',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','none','result',NULL),'Bar. 30.00',0,0),
(@voyage_id,'1880-11-09 00:00:00','Cruising for right whales',-37.50,-166.20,'making casks for oil; moderated later','strong → moderate','SW','short sail',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.00',0,0),
(@voyage_id,'1880-11-10 00:00:00','Cruising for right whales',-37.44,-167.10,'WNW/SW courses; right whale seen 11:50 a.m.','strong → light','S→NW→SW','WNW → SW (AM)',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','sighted','range_mi',2,'bearing','S'),'Bar. 30.00',0,0),
(@voyage_id,'1880-11-11 00:00:00','Cruising for right whales',-37.37,-167.20,'down boats; struck & killed 1; cut in; commenced boiling; heavy rain then calm','strong → calm','NW→SW','—',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','struck & took; cutting; trying out','result','processing'),'Bar. 29.80',0,0),
(@voyage_id,'1880-11-12 00:00:00','Cruising for right whales',-37.17,-167.30,'boiling; hove up N under short sail; later W heading','strong gale then S wind','NW→S','N (short) → W',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','trying out','result','processing'),'Bar. 29.80',0,0),
(@voyage_id,'1880-11-13 00:00:00','Cruising for right whales',-37.37,-166.58,'finished boiling 77 bbl; repairs and scraping bone','strong gales easing','S→SW','W → hove SSE',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','trying out','barrels',77,'result','finished'),'— Bar. 30.20',0,0),
(@voyage_id,'1880-11-14 00:00:00','Cruising for right whales',-37.31,-166.51,'wore WSW at midnight; made all sail later','strong breezes; later made sail','SW','SE → WSW → made sail',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.20',0,0),
(@voyage_id,'1880-11-15 00:00:00','Cruising for right whales',-37.31,-166.51,'whale alongside at 5 a.m. but no success; stowing down oil (port aft hold)','moderate → strong winds','SW','S; later ESE whale going quick',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','boats down','result','no success'),'Bar. 30.20',0,0),
(@voyage_id,'1880-11-16 00:00:00','Cruising for right whales',-38.01,-166.36,'finished stowing 72 bbl; getting casks ready','strong → light','W','SSW → NW',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.25',0,0),
(@voyage_id,'1880-11-17 00:00:00','Cruising for right whales',-38.00,-166.31,'light airs; calm AM; 2 right whales seen SW bound ESE (lost at night)','light → calm','SE→SW','WNW (all sail)',JSON_ARRAY(),JSON_OBJECT('type','right whale','action','sighted','count',2,'bearing','SW','heading','ESE','result','lost at dark'),'Bar. 30.20',0,0),
(@voyage_id,'1880-11-18 00:00:00','Cruising for right whales',-38.01,-167.00,'on both tacks; scraping bone; crew illness','light','SW','both tacks',JSON_ARRAY(),JSON_OBJECT(),'One man with dropsy; Beef 8 / Pork 3 pm noted. Bar. 30.15',0,0),
(@voyage_id,'1880-11-19 00:00:00','Cruising for right whales',-38.31,-165.58,'finished scraping 1850 slabs whalebone; variable weather','moderate → thick rainy → clear → strong','NW→SW','SW (all sail) → shortened night → made sail',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.10',0,0),
(@voyage_id,'1880-11-20 00:00:00','Cruising for right whales',-38.24,-166.06,'split fore topsail; bent & repaired','strong gales','S','SE by E (short)',JSON_ARRAY(),JSON_OBJECT(),'Margin: “Ham”. Bar. 30.15',0,0),
(@voyage_id,'1880-11-21 00:00:00','Cruising for right whales',-38.14,-166.10,'WSW then ESE; made sail at midnight; crew illnesses','strong gale; high sea','S','WSW → ESE',JSON_ARRAY(),JSON_OBJECT('crew_health','Antora Sparkes dropsy; Reips about same'),'Bar. 30.40',0,0),
(@voyage_id,'1880-11-22 00:00:00','Cruising for right whales',-38.40,-164.20,'bent top & mainsail; cloudy later; crew very ill','strong winds','S','SE (all sail)',JSON_ARRAY(),JSON_OBJECT('crew_health','Antone De Montors very ill (“not long”)'),'Longitude “164.20 W” assumed W. Position westward of track.',0,0),
(@voyage_id,'1880-11-23 00:00:00','Cruising for right whales',-38.31,-165.45,'started new sail from cask; wore; bent new main (spencer?); finbacks seen','strong breezes','S→SW','SE (short) → W (night) → SSE (AM)',JSON_ARRAY(),JSON_OBJECT('type','finback','action','sighted','result',NULL),'Margin: “1 cask Tak 4 pm”. Bar. 30.30',0,0),
(@voyage_id,'1880-11-24 00:00:00','Cruising for right whales',-38.36,-166.06,'by the wind; wore; repairing upper fore topsail','strong breezes','WSW→SW','WNW → SSE → S',JSON_ARRAY(),JSON_OBJECT('crew_health','Antone De Montors about the same'),'Bar. 30.30',0,0),
(@voyage_id,'1880-11-25 00:00:00','Cruising for right whales',-39.31,-167.04,'bent fore topsail; two crew sick (chills/fever)','moderate','W→WNW','SSW → SW (all sail)',JSON_ARRAY(),JSON_OBJECT('crew_health','Antone De Montors & Mr. Piras sick'),'Bar. 30.10',0,0),
(@voyage_id,'1880-11-26 00:00:00','Cruising for right whales',-40.00,-168.40,'variable winds incl. calm; steering SW by W AM','moderate → rain → calm → SE wind','W→SW→SE','SSW → SW by W',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1880-11-27 00:00:00','Cruising for right whales',-40.37,-170.34,'spoke bark Ivah (Godffeary), 9 days from Tongatabu, bound “June town” for [stores?]','moderate; cloudy later','SE & NE','SW',JSON_ARRAY(JSON_OBJECT('name','Ivah (bark)','home_port',NULL,'captain','Godffeary','last_port','Tongatabu','days_out',9,'bound_for','“June town” (illegible)')),JSON_OBJECT(),'Spelling uncertain; recorded as heard. Bar. 30.05',0,0),
(@voyage_id,'1880-11-28 00:00:00','Cruising for right whales',-40.49,-172.49,'shortened for night; made sail later','strong breezes','SSE & WNW','SW (all sail)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.80',0,0),
(@voyage_id,'1880-11-29 00:00:00','Cruising for right whales',-40.00,-174.30,'short sail; thick & rainy; NW later','strong breezes','N→NW','WSW (short)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.30',0,0);


-- ───────────────────────────────────────────────────────────────
-- Events: December 1880 — Horatio (C. Grant)
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1880-12-01 00:00:00','Off Chatham Islands (NZ)',-42.29,-174.15,'by the wind under short sail','strong gale; rainy','SW','SSE',JSON_ARRAY(),JSON_OBJECT(),'Margin: Beef 4 pm. Bar. 29.80',0,0),
(@voyage_id,'1880-12-02 00:00:00','Off Chatham Islands',-42.30,-174.00,'short sail; wore several times; squally later','strong gale','SW','SSE → WSW → SE',JSON_ARRAY(JSON_OBJECT('name','sail in sight','home_port',NULL,'bearing','NW','course','ESE')),JSON_OBJECT(),'Bar. 29.90',0,0),
(@voyage_id,'1880-12-03 00:00:00','Off Chatham Islands',-42.30,-173.45,'on both tacks','strong winds','SW','both tacks',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.95',0,0),
(@voyage_id,'1880-12-04 00:00:00','Off Chatham Islands',-43.00,-174.15,'short sail; wore; then moderate & made sail','strong gales easing','SW by S','SSE → NW/WWN → SE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.00',0,0),
(@voyage_id,'1880-12-05 00:00:00','Off Chatham Islands',-43.45,-176.09,'land in sight; hove to in WSW gale; chronometer error noted','strong breezes → strong gales','WNW→WSW','S → N&W (hove) → S (AM)',JSON_ARRAY(),JSON_OBJECT(),'Chronometer ~70 miles too far east; “Chron 174.40”. Bar. —',0,0),
(@voyage_id,'1880-12-06 00:00:00','Off Chatham Islands',-43.47,-175.55,'under topsails & courses; island in sight','strong → moderate','W','S',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.00',0,0),
(@voyage_id,'1880-12-07 00:00:00','Off Chatham Islands',-43.49,-175.56,'changed course NE; land SW ~8 mi','moderate','WSW','S → NE',JSON_ARRAY(),JSON_OBJECT(),'Bread issued 10 a.m. Bar. 30.35',0,0),
(@voyage_id,'1880-12-08 00:00:00','Off Chatham Islands',-43.27,-175.22,'washing whalebone; all sail','light','SW','NE by N',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.40',0,0),
(@voyage_id,'1880-12-09 00:00:00','Off Chatham Islands',-43.13,-175.14,'washing bone; grampuses sighted; tally noted','light airs then calm → light NE','NE','NE → ESE',JSON_ARRAY(),JSON_OBJECT('type','grampus','action','sighted','result',NULL),'“40 months out with 2160 lbs [sperm?] & 5600 lb whalebone.” Bar. 30.40',0,0),
(@voyage_id,'1880-12-10 00:00:00','Off Chatham Islands',-43.24,-174.20,'bundled 2020 lb lean (23 bundles); sperm whale alongside at night; wore to west','light NE','NE','ESE; wore W',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','came alongside at 10 pm','result','watched'), 'Finished bundling 2020 lb lean. Bar. —',0,0),
(@voyage_id,'1880-12-11 00:00:00','Off Chatham Islands',-43.13,-173.30,'making spun-yarn; variable fog/clear','moderate','NW','NE',JSON_ARRAY(),JSON_OBJECT(),'Antone De Morus very poorly; Dates 4 pm. Bar. 30.10',0,0),
(@voyage_id,'1880-12-12 00:00:00','Off Chatham Islands',-42.50,-173.85,'short sail; foggy','strong breezes','N→NNW','SW (short)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.80',0,0),
(@voyage_id,'1880-12-13 00:00:00','Off Chatham Islands',-43.15,-173.20,'wore to WSW; strong gale & fog later','strong breezes → strong gale','NW','NE → WSW',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.80',0,0),
(@voyage_id,'1880-12-14 00:00:00','Off Chatham Islands',-42.57,-173.13,'wore NW at midnight; moderate & pleasant later','strong gale easing','NNW→WSW','SW (short) → NW; then made sail',JSON_ARRAY(),JSON_OBJECT(),'Longitude in log “183.13 W” corrected to 173.13 W. Beef 4 pm. Bar. 30.15',0,0),
(@voyage_id,'1880-12-15 00:00:00','Off Chatham Islands',-42.37,-174.30,'by the wind WNW; shortened for night; made sail AM','moderate','SW','by the wind WNW',JSON_ARRAY(),JSON_OBJECT(),'Flour 150 lb at 4 pm.',0,0),
(@voyage_id,'1880-12-16 00:00:00','Off Chatham Islands',-42.80,-174.70,'spoke bark Canton (Capt. Sherman); one sail in sight','moderate','NW','SW',JSON_ARRAY(JSON_OBJECT('name','Canton (bark)','home_port',NULL,'captain','Sherman','months_out',27,'sperm_oil_lb',1030)),JSON_OBJECT(),'Coords estimated from track between 12/15 and 12/17.',0,0),
(@voyage_id,'1880-12-17 00:00:00','Off Chatham Islands',-43.20,-175.15,'Canton in company; her boats down; later took whale; strong wind & rain','strong breezes; thick fog','NW','S → E & N; both tacks',JSON_ARRAY(JSON_OBJECT('name','Canton (bark)','home_port',NULL,'status','took whale alongside')),JSON_OBJECT(),'Antone De Montar very sick. Margin notes unclear. ',0,0),
(@voyage_id,'1880-12-18 00:00:00','Off Chatham Islands',-43.44,-175.15,'both tacks; Antone died; committed body to the deep; Canton cutting','strong winds; rainy → moderate','—','both tacks',JSON_ARRAY(JSON_OBJECT('name','Canton (bark)','home_port',NULL,'status','cutting')),JSON_OBJECT(),'Crew death: Antone (dropsy). Bar. 30.00',0,0),
(@voyage_id,'1880-12-19 00:00:00','Off Chatham Islands',-43.35,-175.45,'var. winds; shortened at 8 pm; made sail 5 am; wore to ENE','moderate; fog → S wind','NW→S','W by S → ENE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.05',0,0),
(@voyage_id,'1880-12-20 00:00:00','Off Chatham Islands',-43.24,-175.15,'wore S & E; Canton in sight boiling','moderate','SE','NE by E (all sail)',JSON_ARRAY(JSON_OBJECT('name','Canton (bark)','home_port',NULL,'status','boiling')),JSON_OBJECT(),'Issued 6 am Dates, Beef & Butter. Bar. 30.05',0,0),
(@voyage_id,'1880-12-21 00:00:00','Off Chatham Islands',-43.20,-175.00,'mizzen topsail repaired & bent; wore; short sail night','moderate','ESE→SE','NE → SSW → NE; then E',JSON_ARRAY(),JSON_OBJECT(),'— Bar. 30.05',0,0),
(@voyage_id,'1880-12-22 00:00:00','Off Chatham Islands',-42.39,-174.37,'short sail; one sail in sight SE; both tacks','strong breezes','SE','ENE (short) → both tacks',JSON_ARRAY(JSON_OBJECT('name','Bark Canton','home_port',NULL,'bearing','WSW','status','in sight')),JSON_OBJECT(),'Bar. 30.00',0,0),
(@voyage_id,'1880-12-24 00:00:00','Off Chatham Islands',-42.30,-175.08,'squally; later made sail; sail in sight','strong winds','S','ESE (short); then made sail',JSON_ARRAY(JSON_OBJECT('name','sail in sight','home_port',NULL)),JSON_OBJECT(),'Bar. 29.90',0,0),
(@voyage_id,'1880-12-25 00:00:00','Off Chatham Islands (Christmas Day)',-43.44,-175.25,'topsails & courses; wore; shortened for night; calm later; killed hog (150 lb)','moderate → light & calm','S','SW → ESE (wore) → calm',JSON_ARRAY(),JSON_OBJECT(),'“Merry Christmas… & a large sperm whale for us.” Bar. 29.50',0,0),
(@voyage_id,'1880-12-26 00:00:00','Off Chatham Islands',-42.40,-175.15,'barometer falling; light airs','light → calm → light N','E → SW','SW → N (light)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.50',0,0),
(@voyage_id,'1880-12-27 00:00:00','Off Chatham Islands',-42.18,-174.48,'thunder & lightning; hove to under storm staysail','moderate → strong gales','NW→WNW→SW','— (hove to)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.30',0,0),
(@voyage_id,'1880-12-28 00:00:00','Off Chatham Islands',-42.38,-174.40,'made sail; washing bone; stowed 37 bundles (3399 lb)','strong gale → moderating','SW','NW → SSE → made sail',JSON_ARRAY(JSON_OBJECT('name','sail in sight','home_port',NULL,'bearing','NW','course','ESE')),JSON_OBJECT('type','right whale','action','none','result',NULL),'Margin: “Stowed in the ___ 37 bundles whalebone, 3399 lbs”. Bar. 29.60',0,0),
(@voyage_id,'1880-12-29 00:00:00','Off Chatham Islands',-43.14,-175.15,'finished washing & bundling bone (37 bundles, 3399 lb)','strong breezes; fog; wind shifts','WSW→NNW→NW','S → NE (night) → SW',JSON_ARRAY(),JSON_OBJECT(),'Margin: “4 bbls water in butt” at 6 am. Bar. 29.30',0,0),
(@voyage_id,'1880-12-30 00:00:00','Off Chatham Islands',-43.20,-173.45,'hove to; heavy thunder & rain; then set fore & main topsails','moderate → strong; storms','NW→NNW→W','SW → NNE (hove) → E (AM)',JSON_ARRAY(),JSON_OBJECT(),'Bar. ~29.05 (very low)',0,0),
(@voyage_id,'1880-12-31 00:00:00','Off Chatham Islands',-43.10,-173.18,'short sail; light NE; dark clouds','moderate → light','NW→NE','E (short)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.23',0,0);


-- ───────────────────────────────────────────────────────────────
-- Events: January 1881 — Horatio (C. Grant)
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1881-01-01 00:00:00','Off Chatham Islands (NZ)',-43.83,-174.00,'breaking out water, bread, beef & pork; New Year note','strong breezes; clearing AM','S (veering all around)','W; then SW (made sail)',JSON_ARRAY(),JSON_OBJECT(),'“Happy New Year”; Bar. 29.40→rising; margin Beef & Pork & Bread 10am.',0,0),
(@voyage_id,'1881-01-02 00:00:00','Off Chatham Islands',-43.38,-174.30,'cruising; breach seen 10 miles S; nothing more','moderate','WNW','SW; various wears',JSON_ARRAY(JSON_OBJECT('name','Canton (bark)','home_port',NULL,'bearing','NW','status','in sight')),JSON_OBJECT('type','right/sperm?','action','breach sighted','range_mi',10,'bearing','S','result','no further sign'),'— Bar. 29.35',0,0),
(@voyage_id,'1881-01-03 00:00:00','Off Chatham Islands',-43.18,-174.00,'spoke Canton; shortened for night; strong gale later','moderate → strong gale','WNW→N','—',JSON_ARRAY(JSON_OBJECT('name','Canton (bark)','captain','James Sherman','months_out',28,'sperm_lb',1130,'report','all well')),JSON_OBJECT(),'1 sail in sight; Bar. 29.40',0,0),
(@voyage_id,'1881-01-04 00:00:00','Off Chatham Islands',-43.55,-174.40,'cleaning down bark; gale with rain then fine/calm','strong gale → calm & fine','NW→W','N; then—',JSON_ARRAY(),JSON_OBJECT(),'Margin: apples & beans. Bar. 29.90',0,0),
(@voyage_id,'1881-01-05 00:00:00','Off Chatham Islands',-43.44,-174.50,'cleaning & scraping stanchions; calm later','moderate → calm','SW','both tacks',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.05',0,0),
(@voyage_id,'1881-01-06 00:00:00','Off Chatham Islands',-43.47,-175.35,'making a waist board; routine cruising','light','SE→SSE','SW by W',JSON_ARRAY(),JSON_OBJECT(),'— Bar. 30.30',0,0),
(@voyage_id,'1881-01-07 00:00:00','Off Chatham Islands (B—— Rocks & Chatham in sight)',-43.48,-176.00,'islands in sight; varied tacks day/night','moderate','SSE→E','SW/ESE→S/NNE',JSON_ARRAY(),JSON_OBJECT(),'“Bister/Baston” Rocks noted. Bar. 30.30',0,0),
(@voyage_id,'1881-01-08 00:00:00','Off Chatham Islands',-43.18,-174.29,'repairing mainsail; cruising E/ENE','moderate','SE','E & ENE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.35',0,0),
(@voyage_id,'1881-01-09 00:00:00','Off Chatham Islands',-43.02,-173.45,'down for blackfish; struck 4; secured 1; took up boats 11:30','moderate','SE','ENE/NE',JSON_ARRAY(),JSON_OBJECT('type','blackfish','action','lowered; struck 4','result','1 secured'), '41 months from home; hopes for +500 bbl sperm within 6 months.',0,0),
(@voyage_id,'1881-01-10 00:00:00','Off Chatham Islands',-42.51,-173.00,'repairing fore/main topsail; routine courses','moderate','S','ENE → WNW',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.25',0,0),
(@voyage_id,'1881-01-11 00:00:00','Off Chatham Islands',-42.28,-173.48,'light airs then calm; broke out dates, bread & pork','light → calm','SW','WNW',JSON_ARRAY(),JSON_OBJECT(),'Margin: Bread & Pork & Dates 11am. Bar. 30.10',0,0),
(@voyage_id,'1881-01-12 00:00:00','Off Chatham Islands',-42.31,-174.30,'butter (new keg); repairing fore topsail; 2 sails in sight','light','N→SE','W→SW',JSON_ARRAY(),JSON_OBJECT(),'— Bar. 30.25',0,0),
(@voyage_id,'1881-01-13 00:00:00','Off Chatham Islands',-42.33,-174.30,'spoke bark Splendid (Capt. J. Earle); 2 sails in sight later','moderate','S','W',JSON_ARRAY(JSON_OBJECT('name','Splendid (bark)','captain','J. Earle','months_out',3,'cargo_report',400)),JSON_OBJECT(),'Bar. 30.15',0,0),
(@voyage_id,'1881-01-14 00:00:00','Off Chatham Islands',-43.21,-174.33,'spoke Splendid again; strong ESE; SSW under sail','strong breezes','ESE','SSW',JSON_ARRAY(JSON_OBJECT('name','Splendid (bark)','captain','J. Earle')),JSON_OBJECT(),'Bar. 30.00',0,0),
(@voyage_id,'1881-01-15 00:00:00','Off Chatham Islands',-43.33,-174.37,'strong gale; split foresail; 1–2 sails in sight','strong gale','SW','both tacks (short)',JSON_ARRAY(),JSON_OBJECT(),'— Bar. 30.05',0,0),
(@voyage_id,'1881-01-16 00:00:00','Off Chatham Islands',-43.34,-174.33,'strong wind; short sail on both tacks','strong','SW','both tacks (short)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.95',0,0),
(@voyage_id,'1881-01-17 00:00:00','Off Chatham Islands',-44.02,-174.17,'repairing old foresail; 1 sail seen SE','strong','SW','SSE ↔ WNW ↔ SSW',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.05',0,0),
(@voyage_id,'1881-01-18 00:00:00','Off Chatham Islands',-44.08,-174.50,'variable winds; “Beef” noted','strong → light → strong','SW→NW→N','SW → W',JSON_ARRAY(),JSON_OBJECT(),'Margin: Beef. Bar. 29.90',0,0),
(@voyage_id,'1881-01-19 00:00:00','Off Chatham Islands',-44.07,-175.30,'various wears; thick then clear','strong → moderate & clear','N→NW','W; hove ENE; then SW',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.80',0,0),
(@voyage_id,'1881-01-20 00:00:00','Off Chatham Islands',-44.25,-176.01,'Chatham Island bearing W ~29 miles','moderate','W','SSW; then NNW (wear); short night',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.5',0,0),
(@voyage_id,'1881-01-21 00:00:00','Off Chatham Islands',-44.35,-176.10,'spoke Canton again; strong gales later; land in sight','strong wind → gales','SW→NW','S',JSON_ARRAY(JSON_OBJECT('name','Canton (bark)','captain','James Sherman','months_out',28,'sperm_oil',1100)),JSON_OBJECT(),'— Bar. 29.80',0,0),
(@voyage_id,'1881-01-22 00:00:00','Off Chatham Islands',-44.25,-176.25,'short sail in gales; land & 2 sails in sight','strong gales→moderate','NW→WSW','NW',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1881-01-23 00:00:00','Off Chatham Islands (Star— Reef sighted)',-44.15,-176.16,'spoke Splendid; reef bearing NE ~2 mi; varied courses','strong → light N later','SW→N','SE → NW → S',JSON_ARRAY(JSON_OBJECT('name','Splendid (bark)','captain','Earle')),JSON_OBJECT(),'Reef name partly illegible (“Starquery?”).',0,0),
(@voyage_id,'1881-01-24 00:00:00','Off Chatham Islands',-44.45,-175.60,'varied courses with wind shift','strong','N→SW','SSE → NW',JSON_ARRAY(),JSON_OBJECT(),'Longitude “175.60 W” as written.',0,0),
(@voyage_id,'1881-01-25 00:00:00','SE Island (Chatham) vicinity',-45.15,-176.00,'sent 2 boats to fish at SE Island; returned with 500 fin fish','moderate → light → N','NW→NE→N','SW; then out SE',JSON_ARRAY(),JSON_OBJECT('type','fishery','action','fishing','catch','500 fin fish'),'Land out of sight later.',0,0),
(@voyage_id,'1881-01-26 00:00:00','Off Chatham Islands',-45.25,-176.00,'spoke Canton; steered W by N later; fine weather','strong → fine','N→SW','W by N',JSON_ARRAY(JSON_OBJECT('name','Canton (bark)','status','spoke')),JSON_OBJECT(),'Bar. 30.25',0,0),
(@voyage_id,'1881-01-27 00:00:00','Hansen(s) Bay, Chatham Island (anchored)',-44.03,-176.30,'came to anchor in ~14 ft (1.5 mi off); Alaska & Splendid at anchor; took aboard provisions','strong SW','SW','anchored',JSON_ARRAY(
  JSON_OBJECT('name','Alaska (bark)','home_port',NULL,'status','at anchor'),
  JSON_OBJECT('name','Splendid (bark)','home_port',NULL,'status','at anchor')
),JSON_OBJECT(),'Got 60 lb ham & ~2 tons potatoes. Coords estimated for Hanson Bay anchorage.',0,0),
(@voyage_id,'1881-01-28 00:00:00','Hansen(s) Bay, Chatham Island (anchored)',-44.03,-176.30,'stowing water; took items from shore; ready for sea','strong breezes','SW','anchored',JSON_ARRAY(),JSON_OBJECT(),'“took off 14 [____] from the shore” (illeg.).',0,0),
(@voyage_id,'1881-01-29 00:00:00','Off Chatham Islands (underway)',-44.00,-175.90,'got under way 7 pm; steering ENE; Beston Rock in sight SSW ~7 mi at 6 am','strong breezes','SW','ENE',JSON_ARRAY(),JSON_OBJECT(),'Position approximated along track toward 1/30.',0,0),
(@voyage_id,'1881-01-30 00:00:00','Off Chatham Islands',-43.47,-175.15,'routine ship duty; light breeze; Beston rocks out of sight by 11 am','light','S','E by N',JSON_ARRAY(),JSON_OBJECT(),'Calendar-corrected: this is Sunday, Jan 30, 1881. Bar. 30.45',0,0),
(@voyage_id,'1881-01-31 00:00:00','Off Chatham Islands',-43.33,-174.50,'repairing old sail; both tacks','light','S','both tacks',JSON_ARRAY(),JSON_OBJECT(),'—',0,0);


-- ───────────────────────────────────────────────────────────────
-- Events: February 1881 — Horatio (C. Grant)
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1881-02-01 00:00:00','Off Chatham Islands (NZ)',-43.33,-174.42,'both tacks; routine cruising','light breezes','SE','both tacks',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1881-02-02 00:00:00','Off Chatham Islands',-43.19,-174.40,'painting the boats; NE later','light; then N','SE → N','NE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.50',0,0),
(@voyage_id,'1881-02-03 00:00:00','Off Chatham Islands',-43.35,-173.40,'spoke bark Alaska (Capt. Fisher); sail in sight','light','NNE','E ↔ NW ↔ E (var.)',JSON_ARRAY(JSON_OBJECT('name','Alaska (bark)','captain','Fisher','months_out',5,'report','“400” (qty unclear)')),JSON_OBJECT(),'Shortened night; Dates 6am. Course changes per log.',0,0),
(@voyage_id,'1881-02-04 00:00:00','Bound toward French Rock',-42.40,-172.44,'NNW under all sail; shortened night','moderate','WNW','NNW',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.15',0,0),
(@voyage_id,'1881-02-05 00:00:00','Bound toward French Rock',-41.44,-172.37,'by the wind to NE; calm mid-day; ship duty','light','NW','NE (by the wind)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 29.90',0,0),
(@voyage_id,'1881-02-06 00:00:00','Bound toward French Rock',-39.37,-174.00,'NW courses; fair SE/SSE breezes','light → fine','E→S→SSE','NW',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.20',0,0),
(@voyage_id,'1881-02-07 00:00:00','Bound toward French Rock',-38.21,-174.25,'WNW under all sail; light variable later','moderate → light','E/SE→N','WNW',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.20',0,0),
(@voyage_id,'1881-02-08 00:00:00','Bound toward French Rock',-37.30,-175.34,'set up bobstays; cleared iron work; sharp for sperm','light','N','WNW → NW',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','watching','result',NULL),'Flour 2 bags at 4 pm. Bar. 30.30',0,0),
(@voyage_id,'1881-02-09 00:00:00','Bound toward French Rock',-36.34,-176.55,'ship’s duty; fair weather','moderate','N','NW by W',JSON_ARRAY(),JSON_OBJECT(),'Beef at 6 am. Bar. 30.40',0,0),
(@voyage_id,'1881-02-10 00:00:00','Bound toward French Rock',-36.08,-177.38,'cleaning/painting iron work','moderate → light','N → ESE','WSW (by wind)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.45',0,0),
(@voyage_id,'1881-02-11 00:00:00','Bound toward French Rock',-34.51,-178.05,'NNW under all sail; fine weather','light → fine','ESE','NNW',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.40',0,0),
(@voyage_id,'1881-02-12 00:00:00','Approaching French Rock / Kermadecs',-32.55,-178.29,'shortened night; sail to E seen','moderate → strong later','ESE','NNW',JSON_ARRAY(JSON_OBJECT('name','sail in sight','home_port',NULL,'bearing','E','course','S')),JSON_OBJECT(),'Bar. 30.30',0,0),
(@voyage_id,'1881-02-13 00:00:00','Near French Rock (L’Esperance Rock)',-31.09,-179.20,'French Rock bearing NNW ~12 mi at dawn; made sail & steered NW','strong breezes','ESE','NNW → NW',JSON_ARRAY(),JSON_OBJECT(),'Margin: F Rock bearing SE 25 (later). Bar. 30.25',0,0),
(@voyage_id,'1881-02-14 00:00:00','Near French Rock',-31.09,-179.25,'making new jib pennants; rig work; varied tacks','strong breezes','ESE','NW → N → SSE (night) → made sail',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.30',0,0),
(@voyage_id,'1881-02-15 00:00:00','Dateline area (E/W flips)',-31.40,179.46,'setting some riggers; short night; made sail AM','moderate','E','SSE (night) → made sail',JSON_ARRAY(),JSON_OBJECT(),'Longitude in log “179.46 E”—dateline crossed; preserved E value.',0,0),
(@voyage_id,'1881-02-16 00:00:00','Dateline area (E/W flips)',-31.20,179.48,'both tacks; looking sharp for sperm','moderate','SE→SSE','both tacks; SW (AM) → made sail',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','watching','result',NULL),'Water at 6 am. Bar. 30.10',0,0),
(@voyage_id,'1881-02-17 00:00:00','Near French Rock region',-31.14,-179.25,'varied courses; short night; strong breezes late','moderate → strong later','S→SE','WSW → ESE → ENE',JSON_ARRAY(),JSON_OBJECT(),'Bread 10 am; caulking noted. Bar. 30.12',0,0),
(@voyage_id,'1881-02-18 00:00:00','French Rock (L’Esperance) vicinity',-30.48,-178.38,'E by N under fore topsail & courses; French Rock ESE ~27 mi; shortened night, then made sail','strong breezes','SSE','E by N',JSON_ARRAY(),JSON_OBJECT(),'Log “Long 128 38” corrected to 178.38 W (South Pacific).',0,0),
(@voyage_id,'1881-02-19 00:00:00','Curtis & Macauley (Goat) Islands area',-30.55,-179.05,'Curtis Rocks & Goat Island in sight; stood WNW; made all sail AM','light','S→NW','NW → SW → WNW',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.25',0,0),
(@voyage_id,'1881-02-20 00:00:00','Near French Rock',-30.59,-179.25,'short night; varied courses; French Rock bearing E later','light','NW','W by N → SW → S',JSON_ARRAY(),JSON_OBJECT(),'Sugar “56” noted (issue?). Bar. 30.30',0,0),
(@voyage_id,'1881-02-21 00:00:00','French Rock region',-31.20,-179.36,'fitting rigging; SSW under all sail','light','SE','SSW',JSON_ARRAY(),JSON_OBJECT(),'Week-end note in log.',0,0),
(@voyage_id,'1881-02-22 00:00:00','French Rock region',-31.38,-179.11,'short night; made all sail; fitting rigging','light','SE→N','S',JSON_ARRAY(),JSON_OBJECT(),'Longitude as written; dateline proximity.',0,0),
(@voyage_id,'1881-02-23 00:00:00','French Rock region (E side)',-32.04,179.26,'ESE winds with rain late; otherwise fine','light → strong with rain','ESE→SE','S',JSON_ARRAY(),JSON_OBJECT(),'Longitude “179.26 E” kept (E of 180). Bar. 30.30',0,0),
(@voyage_id,'1881-02-24 00:00:00','Cruising about French Rock (NZ)',-31.56,-179.59,'tacked ENE at night; made all sail AM; searching for sperm','moderate','SE→S','SSW → ENE (night) → E (AM)',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','searching','bounty','“$20 up” noted'),'“We want 400 bbl to fill.” Bar. 30.30',0,0),
(@voyage_id,'1881-02-25 00:00:00','Cruising about French Rock',-31.37,-179.59,'fitting rigging; steering N','light','E','N',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.25',0,0),
(@voyage_id,'1881-02-26 00:00:00','Cruising about French Rock',-31.49,-179.59,'short night; made all sail; steering ESE; hoping for whales','light → NE later','E→NE','N → ESE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.10',0,0),
(@voyage_id,'1881-02-27 00:00:00','Cruising about French Rock',-32.22,-179.70,'down 4 boats; struck & killed a large sperm; took alongside','moderate','N','SSE → SE (AM)',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','struck & killed','result','alongside','range_mi',4,'bearing','ENE'),'—',0,0),
(@voyage_id,'1881-02-28 00:00:00','Cruising about French Rock',-32.30,-178.44,'cutting head & body; finished by late morning','strong breezes; rain then fine','N → W','E (wore) → cutting',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','cut in','result','finished'),'Bar. 29.90',0,0);


-- ───────────────────────────────────────────────────────────────
-- Events: March 1881 — Horatio (C. Grant)
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1881-03-01 00:00:00','South of French Rock (NZ)',-32.20,-178.18,'commenced boiling; finished cutting; wore SSE; boiling continues','strong breezes','WNW → SW','NNE (short) → SSE',JSON_ARRAY(),JSON_OBJECT(),'Margin: Beef 2 pm. Bar. 30.00',0,0),
(@voyage_id,'1881-03-02 00:00:00','South of French Rock',-32.09,-178.01,'boiling under short sail','strong breezes','SSE','WNW (short)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.00',0,0),
(@voyage_id,'1881-03-03 00:00:00','South of French Rock',-32.17,-178.45,'finished boiling 105 bbl; cleaning up','moderate','SSE','WSW (short)',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.10',0,0),
(@voyage_id,'1881-03-03 12:00:00','South of French Rock',-32.15,-178.49,'stowing down oil (starboard side fore hold)','moderate','S','SW (all sail)',JSON_ARRAY(),JSON_OBJECT(),'Day/date confusion in log (“Thursdy [[FRIDAY?]] 3?4”). Bar. 30.15',0,0),
(@voyage_id,'1881-03-04 00:00:00','South of French Rock',-32.30,-178.45,'finished stowing 101 bbl','moderate','SE','SSW (short)',JSON_ARRAY(),JSON_OBJECT(),'Margin: Pork. Bar. 30.10',0,0),
(@voyage_id,'1881-03-05 00:00:00','South of French Rock',-32.30,-178.45,'ship’s duty','strong breezes easing','SE','SSW',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.10',0,0),
(@voyage_id,'1881-03-06 00:00:00','South of French Rock',-32.20,-179.35,'repaired casks; wore NE; made all sail NE','moderate','SE','NE',JSON_ARRAY(),JSON_OBJECT(),'Hoping to see whales. Bar. 30.15',0,0),
(@voyage_id,'1881-03-07 00:00:00','South of French Rock',-32.50,-179.15,'fitting rigging; ENE under all sail','light','SE & SW','ENE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.20',0,0),
(@voyage_id,'1881-03-08 00:00:00','Near French Rock (L’Esperance)',-31.80,-179.20,'French Rock bearing NE by N 30 mi (PM) then NE 12 mi (AM); shortened night','moderate','SE','NE → NNE (night) → NNE (AM)',JSON_ARRAY(),JSON_OBJECT(),'Position estimated from bearings/distances and adjacent days.',0,0),
(@voyage_id,'1881-03-09 00:00:00','Near French Rock',-31.30,-179.40,'both tacks under short sail','strong breezes','E','both tacks',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.20',0,0),
(@voyage_id,'1881-03-10 00:00:00','Near French Rock',-32.38,-179.40,'short sail; wore to south','strong winds','E','N → S',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.25',0,0),
(@voyage_id,'1881-03-11 00:00:00','Dateline area (E side)',-32.01,179.40,'short sail; wore to NNE','strong breeze','E','SSE → NNE',JSON_ARRAY(),JSON_OBJECT(),'Longitude east of 180 per log. Bar. 30.20',0,0),
(@voyage_id,'1881-03-12 00:00:00','Dateline area (E side)',-32.37,179.27,'hove to for night; thick & rainy; bad weather','strong breezes; rain','ENE','N → SSE (hove) → N',JSON_ARRAY(),JSON_OBJECT(),'Margin: “10 crates”. Bar. 29.95',0,0),
(@voyage_id,'1881-03-13 00:00:00','Near French Rock',-33.01,-179.40,'fog → clear; varied wears; short sail','strong gales easing','ENE → E','N → SE (eve) → clear late',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.30',0,0),
(@voyage_id,'1881-03-14 00:00:00','Near French Rock',-32.43,-179.15,'made all sail; fitting rigging','strong → SW shift','SE → SW','NE → E',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.10',0,0),
(@voyage_id,'1881-03-15 00:00:00','Near French Rock',-32.35,-179.20,'short night; made sail AM; steered North','moderate','SSW','ENE → N',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.20',0,0),
(@voyage_id,'1881-03-16 00:00:00','Near French Rock',-31.13,-178.50,'French Rock bearing NW (~15 mi); short night','moderate','S','NNE → NW (sighting)',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1881-03-17 00:00:00','Outer Rocks / Macauley (Goat) vicinity',-30.90,179.30,'outer rocks N by E 25 mi; Macauley N by E 35→20 mi; Goat & “Custers” rock in sight','moderate','SSE','N by W → NNW',JSON_ARRAY(),JSON_OBJECT(),'Position estimated; dateline E side retained per bearings.',0,0),
(@voyage_id,'1881-03-18 00:00:00','French Rock region (E side)',-30.23,179.50,'saw a sail to the North; routine','moderate','SE','NW & SW',JSON_ARRAY(JSON_OBJECT('name','sail in sight','home_port',NULL,'bearing','N')),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1881-03-19 00:00:00','French Rock region (E side)',-30.20,179.47,'down 4 boats for sperm; large whale alongside briefly but not fast; small schooner seen','moderate → calm later','SE','SSW; chase; calm late',JSON_ARRAY(JSON_OBJECT('name','small schooner','home_port',NULL,'course','W')),JSON_OBJECT('type','sperm','action','lowered; chase','range_mi',4,'result','no fast'),'Bar. 30.30',0,0),
(@voyage_id,'1881-03-20 00:00:00','French Rock region (W side)',-30.52,-179.44,'short night; made sail AM; mate “in trouble about masting”','light','SW','SSE',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.20',0,0),
(@voyage_id,'1881-03-21 00:00:00','French Rock region (W side)',-31.06,-179.50,'rubbing down rigging; hoped to see whales','moderate','SSW','E (AM) after night shortening',JSON_ARRAY(JSON_OBJECT('name','ship in sight','home_port',NULL,'bearing','SW by W')),JSON_OBJECT(),'Bar. 30.30',0,0),
(@voyage_id,'1881-03-22 00:00:00','French Rock region (W side)',-31.10,-179.32,'looking sharp for whales; all sail','light','S','E',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.25',0,0),
(@voyage_id,'1881-03-23 00:00:00','French Rock region (W side)',-31.48,-179.35,'rigging work; strong ESE late; pork issued 6 pm','light → strong','SE → ESE','E (all sail) → topsail & courses',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.30',0,0),
(@voyage_id,'1881-03-24 00:00:00','French Rock region (W side)',-31.10,-179.48,'short night; set jib/foresail/mainsail AM; hunting sperm','strong breezes','ESE','S → NE (midnight) → E (AM)',JSON_ARRAY(),JSON_OBJECT('type','sperm','action','searching','result',NULL),'“One large whale more then I am off for the lay of Island & home.” Bar. 30.40',0,0),
(@voyage_id,'1881-03-26 00:00:00','French Rock region (E side)',-31.23,179.49,'short night; repeated wearing; NE↔S','strong winds','ESE','NE → S',JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.40',0,0),
(@voyage_id,'1881-03-27 00:00:00','French Rock region (E side)',-31.70,179.70,'short sail; continued strong ESE','strong breezes','ESE','S (short)',JSON_ARRAY(),JSON_OBJECT(),'No coords in log—estimated between 3/26 and 3/28.',0,0),
(@voyage_id,'1881-03-28 00:00:00','French Rock region (E side)',-32.15,178.40,'by the wind SSW','strong winds','SE','SSW (by the wind)',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1881-03-29 00:00:00','French Rock region (E side)',-33.40,178.00,'SSW under short sail','strong gale','SE','SSW (short)',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1881-03-30 00:00:00','French Rock region (E side)',-34.00,178.00,'SSW under short sail','strong winds','SE','SSW (short)',JSON_ARRAY(),JSON_OBJECT(),'—',0,0),
(@voyage_id,'1881-03-31 00:00:00','French Rock region (E side)',-32.15,178.40,'SSW under short sail','strong breezes','SSE→ESE','SSW (short)',JSON_ARRAY(),JSON_OBJECT(),'Log shows another “Thursday 30” duplicating coords; captured here as Mar 31 with note.',0,0);


-- ───────────────────────────────────────────────────────────────
-- Events: April 1881 — Horatio (C. Grant)
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1881-04-01 00:00:00','Off Bay of Islands (NZ coast, Cape Brett in sight)',-35.00,174.28,
 'steering in for Bay of Islands','moderate breezes','NE','SSW',JSON_ARRAY(),JSON_OBJECT(),
 '“Cape Bult” read as Cape Brett; bearing SSW ~20 miles.',0,0),

(@voyage_id,'1881-04-02 00:00:00','Bay of Islands (anchored)',-35.23,174.12,
 'bent chains; anchored; received letters from home','moderate breeze','NE','in for the land',JSON_ARRAY(),JSON_OBJECT(),
 'Anchorage coords estimated for Bay of Islands (Russell/Paihia).',0,0),

(@voyage_id,'1881-04-25 00:00:00','Bay of Islands → outbound (pilot)',-35.20,174.18,
 'took anchor; towed out; took pilot; steamed out; discharged pilot','strong breeze early → light/calm','S','departing harbor',JSON_ARRAY(),JSON_OBJECT(),
 'Cape Brett E by N ~10 miles at noon; Lat 35°12′S Long 174°15′E.',0,0),

(@voyage_id,'1881-04-26 00:00:00','Off NZ (northbound departure made)',-33.28,175.25,
 'land out of sight; cleared chains & stowed anchors','moderate breeze','ESE','NNE',JSON_ARRAY(),JSON_OBJECT(),
 'Departure taken SSW of last landfall; Bar. 30.15',0,0),

(@voyage_id,'1881-04-27 00:00:00','Off NZ',-33.37,176.00,
 'NNE under all sail; bent ship to SSE at midnight','strong breeze','ESE','NNE → SSE (midnight)',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.20',0,0),

(@voyage_id,'1881-04-28 00:00:00','Off NZ',-34.00,176.20,
 'reefed light sail; took in upper topsail','strong breezes','ESE','SSE (all sail)',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.40',0,0),

(@voyage_id,'1881-04-29 00:00:00','Off NZ',-35.40,176.20,
 'clearing chain while under topsails & courses','strong breezes','ENE','SE',JSON_ARRAY(),JSON_OBJECT(),
 '—',0,0),

(@voyage_id,'1881-04-30 00:00:00','Approaching the dateline (E side)',-36.00,179.00,
 'reefed upper topsail; strong wind from NE','strong wind','NE','ESE (all sail)',JSON_ARRAY(),JSON_OBJECT(),
 'Longitude written “179 E” (W scored out). Bar. 30.15',0,0),

(@voyage_id,'1881-04-30 12:00:00','Dateline crossing (East → West)',-37.00,-179.00,
 'E by S under reefed topsail & courses; thick, rainy; crossed from East to West time','strong wind; thick & rainy','N','E by S',JSON_ARRAY(),JSON_OBJECT(),
 '“We has had 2 Saturdays”: dateline crossing noted; second 4/30 entry recorded at 12:00.',0,0);

-- ───────────────────────────────────────────────────────────────
-- Events: May 1881 — Horatio (C. Grant)
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1881-05-01 00:00:00','South Pacific (dateline just crossed W)',-37.00,-179.00,
 'steering ESE; wore NNW at midnight; made all sail','strong breeze; clear later',
 'N → W WNW','ESE → NNW → ESE',JSON_ARRAY(),JSON_OBJECT(),
 'Margin explains two Saturdays due to dateline: “gave 1 day by coming E about”. Bar. 29.80',0,0),

(@voyage_id,'1881-05-02 00:00:00','South Pacific',-39.44,-172.57,
 'ESE under all sail; light & calm later','strong → light/calm','WNW→NW→NW by N','ESE',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 29.80',0,0),

(@voyage_id,'1881-05-03 00:00:00','South Pacific',-39.40,-172.00,
 'E by S; strong gale from S midnight; short topsail','light → strong gale','SW→S','E by S',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 29.90',0,0),

(@voyage_id,'1881-05-04 00:00:00','South Pacific (est.)',-39.80,-169.60,
 'set fore & main topsail; then jib & mainsail; steering East','strong gale easing to fine',
 'S → SW','ESE → E',JSON_ARRAY(),JSON_OBJECT(),
 'Coords estimated between 5/3 (172.00 W) and 5/5 (167.18 W). Bar. 30.30',0,0),

(@voyage_id,'1881-05-05 00:00:00','South Pacific',-40.02,-167.18,
 'E under fore topsail, courses & jib','strong breezes','SSW','E',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.25',0,0),

(@voyage_id,'1881-05-06 00:00:00','South Pacific',-40.12,-165.01,
 'E by S under all sail; then took in light sail; about; wind SW','strong breezes; moderating',
 'S → SW','E by S → about',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.00',0,0),

(@voyage_id,'1881-05-07 00:00:00','South Pacific',-41.29,-161.35,
 'ESE course; slops issued; rainy at night; strong SW AM','strong → moderate → strong',
 'SW→NW→SW','ESE → E by S',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 29.45',0,0),

(@voyage_id,'1881-05-08 00:00:00','South Pacific',-41.45,-157.08,
 'E by S under all sail; then reduced; strong gale; set upper topsail, jib & mainsail AM',
 'strong wind & gale; moderating toward morning','SW','E by S → E by N → set topsails',
 JSON_ARRAY(),JSON_OBJECT(),'Bar rising ~29.90',0,0),

(@voyage_id,'1881-05-09 00:00:00','South Pacific',-43.15,-152.25,
 'ESE under all sail; moderating','strong → moderate','W by N','ESE',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 29.90',0,0),

(@voyage_id,'1881-05-10 00:00:00','South Pacific',-44.30,-149.06,
 'E by S under all sail; foggy later','strong breezes','WNW','E by S',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 29.80',0,0),

(@voyage_id,'1881-05-11 00:00:00','South Pacific',-45.50,-144.25,
 'E by S under all sail; thick weather; hove; then made all sail','strong winds; thick',
 'WNW','E by S',JSON_ARRAY(),JSON_OBJECT(),
 '“first cabin stove”; ship set S 7 miles (log note). Bar. 29.80',0,0),

(@voyage_id,'1881-05-12 00:00:00','South Pacific',-46.06,-141.30,
 'E by S under all sail; wind veered ESE → NE; heading NE','strong breezes improving',
 'WNW → ESE','E by S → NE',JSON_ARRAY(),JSON_OBJECT(),
 'Bread 8 am. Bar. 30.70',0,0),

(@voyage_id,'1881-05-13 00:00:00','South Pacific',-45.50,-139.55,
 'both tacks; heading SSE by morning','light breeze','E','both tacks → SSE',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.85',0,0),

(@voyage_id,'1881-05-14 00:00:00','South Pacific',-46.34,-138.20,
 'by the wind to SE; then NNE → E by S; light WSW later','light breezes; variable',
 'ESE → NNE → WSW','SE → E by S',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.80',0,0),

(@voyage_id,'1881-05-15 00:00:00','South Pacific',-46.50,-134.20,
 'E by S; winds shifted S then SE; heading ENE','light breezes','WNW→S→SE','E by S → ENE',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.75',0,0),

(@voyage_id,'1881-05-16 00:00:00','South Pacific',-46.40,-138.10,
 'ENE & NE under all sail; later SW wind, steered E by S','moderate','SE→SW','ENE/NE → E by S',JSON_ARRAY(),JSON_OBJECT(),
 'Water 10. Bar. 30.55',0,0),

(@voyage_id,'1881-05-17 00:00:00','South Pacific',-45.58,-131.30,
 'E by S under all sail; barometer falling slowly; fine later','moderate → light','SW','E by S',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.42',0,0),

(@voyage_id,'1881-05-18 00:00:00','South Pacific',-47.04,-129.55,
 'E by S; calm night; light S later','light; calm','— → S','E by S',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.42',0,0),

(@voyage_id,'1881-05-19 00:00:00','South Pacific',-46.12,-128.00,
 'E by S under all sail; wind ESE late, heading NE by E','light breezes','S → ESE','E by S → NE by E',JSON_ARRAY(),JSON_OBJECT(),
 'Vinegar 2 pm; Butter 10 am. Bar. 30.30',0,0),

(@voyage_id,'1881-05-20 00:00:00','South Pacific (by DR)',-45.25,-126.00,
 'by the wind to NE; took in light sails; strong & cloudy; snugged upper sails','moderate → strong',
 'ESE','NE (by wind)',JSON_ARRAY(),JSON_OBJECT(),
 'Lat by DR. Bar. 30.15',0,0),

(@voyage_id,'1881-05-21 00:00:00','South Pacific',-45.16,-123.27,
 'by the wind to NE under short sail; wore SSE; set jib & mainsail AM','strong breezes; dark & cloudy',
 'ESE','NE (short) → SSE → set',JSON_ARRAY(),JSON_OBJECT(),
 'Beef & Pork issued. Bar. 30.30',0,0),

(@voyage_id,'1881-05-22 00:00:00','South Pacific',-46.10,-124.00,
 'SSE by the wind under fore topsail & courses; beat to NE by 11 am','strong breezes; fine later',
 'E','SSE → NE (beat)',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.30',0,0),

(@voyage_id,'1881-05-23 00:00:00','South Pacific',-45.31,-123.35,
 'steering S under all sail; then about to NE; later about to S','light → moderate & pleasant',
 'ESE','S → NE → S',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.25',0,0),

(@voyage_id,'1881-05-24 00:00:00','South Pacific',-47.45,-123.15,
 'by the wind under all sail; saw a bark steering NE; later ENE/NE winds','moderate breezes',
 'ESE → ENE → NE','by the wind; later E by S',JSON_ARRAY(JSON_OBJECT('name','bark (unknown)','home_port',NULL,'bearing','W','course','NE')),
 JSON_OBJECT(),'Water 10 am. Bar. 30.30',0,0),

(@voyage_id,'1881-05-25 00:00:00','South Pacific',-47.45,-123.15,
 'E by S under all sail; wind NNW later','moderate breezes','NE → NNW','E by S',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.30',0,0),

(@voyage_id,'1881-05-26 00:00:00','South Pacific',-49.57,-117.40,
 'E by S under all sail; light N later','moderate → light','NW → N','E by S',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.40',0,0),

(@voyage_id,'1881-05-27 00:00:00','South Pacific',-51.01,-114.20,
 'E by S under all sail; fine, dry & clear; light winds later','light breezes','N → NE','ESE then E by S',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.40',0,0),

(@voyage_id,'1881-05-28 00:00:00','South Pacific',-52.01,-111.20,
 'E by S under all sail; light NE later','moderate → light','NNE → NE','E by S',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.50',0,0),

(@voyage_id,'1881-05-29 00:00:00','South Pacific',-52.05,-110.02,
 'heading SE; wind East; then NNE; then SSE near noon','light breezes','ENE→E→NNE→SSE','SE → NNE → SSE',
 JSON_ARRAY(),JSON_OBJECT(),'Bar. 30.50',0,0),

(@voyage_id,'1881-05-30 00:00:00','South Pacific',-53.35,-109.05,
 'SSE by the wind; later NE/NE by E; parted fly-jib stay & repaired','moderate breezes',
 'E → NE','SSE (by wind)',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.50',0,0),

(@voyage_id,'1881-05-31 00:00:00','South Pacific (by DR)',-51.10,-106.25,
 'heading East under topsails & courses; moderate, variable winds','moderate; by winds',
 'NNE','E (topsail & courses)',JSON_ARRAY(),JSON_OBJECT(),
 'Lat by DR; Flour 2 pm. Bar. 30.50',0,0);


-- ───────────────────────────────────────────────────────────────
-- Events: June 1881 — Horatio (C. Grant)
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1881-06-01 00:00:00','South Pacific (homeward bound)',-55.01,-103.26,
 'set fly-jib & main t’gallant; then made all sail','moderate','NNE→N','E by N (topsails & courses)',JSON_ARRAY(),JSON_OBJECT(),
 'Beef & Pork 1 pm. Bar. 30.60',0,0),

(@voyage_id,'1881-06-02 00:00:00','South Pacific',-52.235,-99.55,
 'large bark steering East seen; light fog later','moderate breezes','NNE→NE','E (all sail)',JSON_ARRAY(JSON_OBJECT('name','large bark','course','E')),JSON_OBJECT(),
 'Water & Bread 10 am. Bar. “30”',0,0),

(@voyage_id,'1881-06-03 00:00:00','South Pacific',-55.01,-98.35,
 'headed SE; then wore North; sail in sight SW; later ESE','moderate','ENE','SE → N → ESE',JSON_ARRAY(JSON_OBJECT('name','sail in sight','bearing','SW')),JSON_OBJECT(),
 'Thermometer noted (“3.7?”). Fine weather; head wind. Bar. 30.50',0,0),

(@voyage_id,'1881-06-04 00:00:00','South Pacific',-55.00,-98.15,
 'both tacks; light winds','light','NE','both tacks',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.70',0,0),

(@voyage_id,'1881-06-05 00:00:00','South Pacific',-54.45,-95.45,
 'NE by E under all sail; wind NW late','light → NW later','N→NNW→NW','NE by E',JSON_ARRAY(),JSON_OBJECT(),
 '—',0,0),

(@voyage_id,'1881-06-06 00:00:00','South Pacific (est.)',-54.55,-90.00,
 'ENE by compass under all sail; porpoise caught','moderate','NW','ENE (by compass)',JSON_ARRAY(),JSON_OBJECT('type','porpoise','action','caught'), 
 'Longitude estimated between 6/5 (95°45′W) and DR on 6/7 (84°W).',0,0),

(@voyage_id,'1881-06-07 00:00:00','South Pacific (by DR)',-54.46,-84.00,
 'ENE under all sail; sails in sight','moderate → strong','NW by W','ENE',JSON_ARRAY(JSON_OBJECT('name','sail','bearing','WNW'),JSON_OBJECT('name','ship in sight','course','E by N')),JSON_OBJECT(),
 'Lat/Long by DR.',0,0),

(@voyage_id,'1881-06-08 00:00:00','South Pacific',-55.58,-78.25,
 'E, then E by S; passed a 2000-ton ship within 1 mile; hove to later; SE by E late','strong; thick later','NW','E → E by S → SE by E',JSON_ARRAY(JSON_OBJECT('name','large ship (~2000 tons)','distance','~1 mile','sail','all set')),JSON_OBJECT(),
 'Bar. 30.20',0,0),

(@voyage_id,'1881-06-09 00:00:00','South Pacific',-57.10,-75.09,
 'SE by E; later East with NW wind','strong breeze','WSW→NW','SE by E → E',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 29.80',0,0),

(@voyage_id,'1881-06-10 00:00:00','South Pacific',-57.12,-70.00,
 'ENE by compass; strong & thick, then moderated','strong → moderate','NW','ENE (by compass)',JSON_ARRAY(),JSON_OBJECT(),
 '—',0,0),

(@voyage_id,'1881-06-11 00:00:00','South Pacific',-57.17,-64.20,
 'ENE under all sail; WSW then NE by E later; fine','moderate → fine','N → WSW → NE by E','ENE',JSON_ARRAY(),JSON_OBJECT(),
 'Long by chronometer 64°20′W (log also 66°00′W). Bar. 29.90',0,0),

(@voyage_id,'1881-06-12 00:00:00','South Pacific',-56.28,-60.18,
 'var.; shortened; strong NNW AM then moderate; calm later','moderate → calm','W→NNW','NE (under all sail) → light',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 29.40',0,0),

(@voyage_id,'1881-06-13 00:00:00','South Pacific',-56.15,-60.00,
 'NE by S under short sail','strong breezes','NW','NE by S',JSON_ARRAY(),JSON_OBJECT(),
 '—',0,0),

(@voyage_id,'1881-06-14 00:00:00','Approaching Cape Horn longitudes',-54.49,-55.00,
 'fog → WSW breeze; NNE under all sail','moderate; foggy then fine','SSW→WSW','NNE',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 29.55',0,0),

(@voyage_id,'1881-06-15 00:00:00','Off Cape Horn (by DR)',-53.17,-53.57,
 'WSW; later WNW → NW; NE by N under short sail','moderate','WSW→WNW→NW','NE by N (short)',JSON_ARRAY(),JSON_OBJECT(),
 'Lat/Long by DR. Bar. 29.20 (falling)',0,0),

(@voyage_id,'1881-06-16 00:00:00','Off Cape Horn',-52.01,-52.14,
 'NE (by wind); hard gale by night; short sail; sail in sight','strong breezes → hard gale; clear','NW','NE (by wind)',JSON_ARRAY(JSON_OBJECT('name','sail in sight','bearing','SW','course','NE')),JSON_OBJECT(),
 'Bar. 28.97',0,0),

(@voyage_id,'1881-06-17 00:00:00','South Atlantic (W of Horn)',-49.44,-50.18,
 'NNE under two topsails & foresail; heavy squalls (hail/snow?)','strong gales; squally','WSW','NNE',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 29.40',0,0),

(@voyage_id,'1881-06-18 00:00:00','South Atlantic',-46.37,-47.50,
 'N by E under topsails & courses; moderated; set t’gallants','strong gale → moderate','SW→WSW','N by E',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 29.65',0,0),

(@voyage_id,'1881-06-19 00:00:00','South Atlantic',-43.56,-45.50,
 'N by E to NNE under all sail; squally then pleasant','strong breezes → moderate','WSW','N by E → NNE',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 29.85',0,0),

(@voyage_id,'1881-06-20 00:00:00','South Atlantic',-41.37,-43.50,
 'NE by N under all sail; sail in sight SW','moderate','SW','NE by N',JSON_ARRAY(JSON_OBJECT('name','sail in sight','bearing','SW','course','NNE')),JSON_OBJECT(),
 'Bar. 29.95',0,0),

(@voyage_id,'1881-06-21 00:00:00','South Atlantic',-39.40,-40.29,
 'NNE by E under all sail; one sail in sight','moderate','SW','NNE by E',JSON_ARRAY(JSON_OBJECT('name','sail in sight')),JSON_OBJECT(),
 'Bar. 30.50',0,0),

(@voyage_id,'1881-06-22 00:00:00','South Atlantic',-38.18,-38.25,
 'NE under all sail; one sail in sight','moderate','NNW','NE',JSON_ARRAY(JSON_OBJECT('name','sail in sight')),JSON_OBJECT(),
 'Bar. 30.50',0,0),

(@voyage_id,'1881-06-23 00:00:00','South Atlantic (est.)',-37.50,-37.80,
 'ENE & NE under all sail; planing decks; two sails in sight','light breezes','N','ENE & NE',JSON_ARRAY(JSON_OBJECT('name','two sails','bearing',NULL)),JSON_OBJECT(),
 'Longitude estimated between 6/22 (38°25′W) and 6/24 (36°45′W).',0,0),

(@voyage_id,'1881-06-24 00:00:00','South Atlantic',-36.33,-36.45,
 'NE by N; spoke Belgian bark Mirinn (from Channel Islands to Falmouth for cedar); 3 sails in sight','light breezes','NNW','NE by N',JSON_ARRAY(JSON_OBJECT('name','Mirinn (Belgian bark)','route','Channel Islands → Falmouth','cargo','cedar')),JSON_OBJECT(),
 '—',0,0),

(@voyage_id,'1881-06-25 00:00:00','South Atlantic',-33.55,-35.08,
 'NE by N; several sails in company; spoke bark Elizabeth Childe (Sunderland) bound Boston','brisk breezes','NNW','NE by N',JSON_ARRAY(JSON_OBJECT('name','Elizabeth Childe (bark)','home_port','Sunderland','destination','Boston')),JSON_OBJECT(),
 'Three sails steering NE.',0,0),

(@voyage_id,'1881-06-26 00:00:00','South Atlantic',-32.45,-34.16,
 'NE by N; fine pleasant weather; later ENE heading North; 3 sails in sight','moderate → light','W → ENE','NE by N → N',JSON_ARRAY(JSON_OBJECT('name','3 sails in sight')),JSON_OBJECT(),
 'Bar. 30.40–30.50',0,0),

(@voyage_id,'1881-06-27 00:00:00','South Atlantic',-32.00,-36.02,
 'North under all sail; then on both tacks overnight','light breezes','ENE','N → both tacks',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.60',0,0),

(@voyage_id,'1881-06-28 00:00:00','South Atlantic',-31.40,-35.15,
 'NW under all sail; sail in sight SW','light breezes','NNE','NW',JSON_ARRAY(JSON_OBJECT('name','sail in sight','bearing','SW')),JSON_OBJECT(),
 '—',0,0),

(@voyage_id,'1881-06-29 00:00:00','South Atlantic',-31.25,-34.00,
 'by the wind to the East','light breezes','NNE','E (by the wind)',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.60',0,0),

(@voyage_id,'1881-06-30 00:00:00','South Atlantic',-30.59,-32.24,
 'East under all sail','light breezes','NNE','E',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.60',0,0);


-- ───────────────────────────────────────────────────────────────
-- Events: July 1881 — Horatio (C. Grant)
-- (Append to existing seed; uses the same @voyage_id)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id, date, location, latitude, longitude, activity, weather,
  wind_direction, course_direction, ships_encountered, whale_activity,
  notes, motivation_levels, casualties
) VALUES
(@voyage_id,'1881-07-01 00:00:00','South Atlantic (homeward bound)',-30.20,-30.00,
 'steering ENE under all sail','light breezes','N','ENE',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.55',0,0),

(@voyage_id,'1881-07-02 00:00:00','South Atlantic',-29.45,-28.15,
 'steering ENE; three sails in sight','moderate breezes','N','ENE',
 JSON_ARRAY(JSON_OBJECT('name','three sails','bearing',NULL)),JSON_OBJECT(),
 'Bar. 30.40',0,0),

(@voyage_id,'1881-07-03 00:00:00','South Atlantic',-29.30,-27.57,
 'steering ENE under all sail','moderate breezes','N','ENE',JSON_ARRAY(),JSON_OBJECT(),
 'Longitude written “2.157 W”; interpreted as 27°57′W based on track. Bar. 30.50',0,0),

(@voyage_id,'1881-07-04 00:00:00','South Atlantic',-28.01,-26.10,
 'by the wind to ENE; two sails in sight','light breeze','N','ENE',JSON_ARRAY(JSON_OBJECT('name','two sails')),JSON_OBJECT(),
 'Bar. 30.45',0,0),

(@voyage_id,'1881-07-05 00:00:00','South Atlantic',-27.40,-25.30,
 'heading ENE under all sail','moderate breeze','N','ENE',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.45',0,0),

(@voyage_id,'1881-07-06 00:00:00','South Atlantic',-26.30,-24.40,
 'steering ENE; later NE','—','N','ENE → NE',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.40',0,0),

(@voyage_id,'1881-07-07 00:00:00','South Atlantic',-24.01,-24.00,
 'steering NE under all sail','moderate breezes','NNE','NE',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.30',0,0),

(@voyage_id,'1881-07-08 00:00:00','South Atlantic',-21.10,-24.50,
 'steering NNE; wind South by evening; then N by W under all sail','moderate → fresh',
 'NW → S','NNE → N by W',JSON_ARRAY(),JSON_OBJECT(),
 'Position line given without “Lat/Long” labels; recorded as 21°10′S, 24°50′W.',0,0),

(@voyage_id,'1881-07-09 00:00:00','South Atlantic',-19.05,-24.45,
 'tarring down rigging while steering N by W','strong breezes','SSE','N by W',JSON_ARRAY(),JSON_OBJECT(),
 '—',0,0),

(@voyage_id,'1881-07-10 00:00:00','South Atlantic',-16.19,-26.25,
 'N by W under all sail; strong breeze','strong breeze','SSE','N by W',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.38',0,0),

(@voyage_id,'1881-07-11 00:00:00','South Atlantic',-14.20,-28.50,
 'NNW under all sail; sail to the north; tarring down rigging','strong breezes',
 'SSE','NNW',JSON_ARRAY(JSON_OBJECT('name','sail in sight','bearing','N')),JSON_OBJECT(),
 'Also noted alt. position “14.00 S 29.58 W”. Bar. 30.40',0,0),

(@voyage_id,'1881-07-12 00:00:00','South Atlantic',-11.45,-31.45,
 'N by WNW under all sail; fine pleasant weather; two sails in sight','brisk SE trade',
 'SE','N by WNW',JSON_ARRAY(JSON_OBJECT('name','two sails')),JSON_OBJECT(),
 'Started water. —',0,0),

(@voyage_id,'1881-07-13 00:00:00','South Atlantic',-8.58,-32.40,
 'N by W under all sail; saw two ships steering south','strong trade','SE','N by W',
 JSON_ARRAY(JSON_OBJECT('name','two ships','course','S')),JSON_OBJECT(),'—',0,0),

(@voyage_id,'1881-07-14 00:00:00','South Atlantic',-7.29,-33.40,
 'N by W; later ENE with rain; then N by E','moderate breezes; rainy later',
 'E → ENE','N by W → N by E',JSON_ARRAY(),JSON_OBJECT(),
 '—',0,0),

(@voyage_id,'1881-07-15 00:00:00','South Atlantic',-6.29,-33.34,
 'NNE under all sail; royals sent up and sails bent; calm & rainy late','moderate → light → calm',
 'E → S (late)','NNE',JSON_ARRAY(),JSON_OBJECT(),
 'Bar. 30.20',0,0),

(@voyage_id,'1881-07-16 00:00:00','South Atlantic (est.)',-6.00,-33.30,
 'light NW breezes with plenty of rain; Beef & Pork noted 2 pm','light; rainy','NW','—',JSON_ARRAY(),JSON_OBJECT(),
 'Coords estimated from track between 7/15 and later pages; log text truncated after ration note.',0,0);
