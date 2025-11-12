-- ───────────────────────────────────────────────────────────────
-- Seed: Ships
-- ───────────────────────────────────────────────────────────────
INSERT INTO ships (ship_name, home_port)
VALUES ('Martha', NULL)
ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);

-- Capture ship id
SET @ship_id := LAST_INSERT_ID();

-- ───────────────────────────────────────────────────────────────
-- Seed: Voyages (Martha, Unknown Captain)
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
  'At sea',
  '',
  'Unknown',
  0,
  0,
  '1844-09-08 00:00:00'
);

-- Capture voyage id
SET @voyage_id := LAST_INSERT_ID();

-- ───────────────────────────────────────────────────────────────
-- Seed: Events — September 1844 (with lat/long from log; some estimated)
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id,
  date,
  location,
  latitude,
  longitude,
  activity,
  weather,
  wind_direction,
  course_direction,
  ships_encountered,
  whale_activity,
  notes,
  motivation_levels,
  casualties
) VALUES
-- 1844-09-08
(@voyage_id, '1844-09-08 00:00:00', 'Pacific Ocean (at sea, off S America)', -31.8500, -86.7833,
 'underway; strong SE winds; made sail',
 'strong SE winds; overcast; light winds AM',
 'SE',
 'S by W',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Captain quite unwell. Log mentions bending a topsail; “made sail.” Lat 31°51’ S, Long 86°47’ W.',
 0, 0),

-- 1844-09-09
(@voyage_id, '1844-09-09 00:00:00', 'Pacific Ocean (at sea)', -32.2500, -87.0000,
 'tacking; working ship; new rigging',
 'light winds; overcast',
 '',
 'various (E by E; N?; S by W; later E by E)',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Multiple tacks noted (E by E, N?, S & W). “New rigging.” Lat 32°15’ S, Long ~87°W (minutes unclear).',
 0, 0),

-- 1844-09-10
(@voyage_id, '1844-09-10 00:00:00', 'Pacific Ocean (at sea)', -32.2667, -86.4167,
 'lowered and chased sperm whale; no success',
 'light breeze; gales at times',
 'S',
 'ESE (steering); variable',
 JSON_ARRAY(),
 JSON_OBJECT('type','sperm whale','action','lowered and chased','result','no success'),
 'Sighted sperm whale at 5 AM; boats lowered, lost sight. Position uncertain in log; coords estimated between prior/next entries.',
 0, 0),

-- 1844-09-11
(@voyage_id, '1844-09-11 00:00:00', 'Pacific Ocean (at sea)', -32.9500, -85.6500,
 'boats in chase; no success; shortened sail; heavy wind',
 'fine weather early; gale later',
 '',
 'to the wind; N by W then E of E',
 JSON_ARRAY(),
 JSON_OBJECT('type','sperm whale','action','in chase; lost','result','no success'),
 'Boats off in chase; lost sight; came aboard; later heavy wind (“gail of wind”). Lat 32°57’ S, Long 85°39’ W.',
 0, 0),

-- 1844-09-18
(@voyage_id, '1844-09-18 00:00:00', 'Pacific Ocean (at sea)', -32.4167, -77.8500,
 'heave-to/backed yards; wore; cruising',
 'thick and rainy; light breeze later',
 'SE (later variable)',
 'SWE; N by W; SWE',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Waiting for weather to clear; captain directed course changes; wore ship. Lat 32°25’ S, Long 77°51’ W (chronometer).',
 0, 0),

-- 1844-09-19
(@voyage_id, '1844-09-19 00:00:00', 'Pacific Ocean (at sea)', -32.5833, -77.0667,
 'light airs; calm; wore ship; making sail',
 'light wind; thick and overcast',
 'ENE (later)',
 'S by E; SE by E',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Made/reefed topsail; calm periods; overcast. Lat 32°35’ S, Long 77°04’ W (by deck).',
 0, 0),

-- 1844-09-20
(@voyage_id, '1844-09-20 00:00:00', 'Pacific Ocean (at sea)', -33.5000, -75.5000,
 'light airs; calm; making sail',
 'light winds; calm spells',
 'N by E (later)',
 'E by S (earlier)',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Fore topmast steering sail noted; captain quite unwell. Lat 33°30’ S, Long 75°30’ W.',
 0, 0);


-- ───────────────────────────────────────────────────────────────
-- Seed: Events — October 1844
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id,
  date,
  location,
  latitude,
  longitude,
  activity,
  weather,
  wind_direction,
  course_direction,
  ships_encountered,
  whale_activity,
  notes,
  motivation_levels,
  casualties
) VALUES
-- 1844-10-10
(@voyage_id, '1844-10-10 00:00:00', 'Pacific Ocean (at sea)', -34.6000, -79.0500,
 'underway; by the wind',
 'strong winds; latter part still strong',
 'SE',
 'SW by S',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Lat 34°36′ S, Long 79°03′ W (chronometer). “Steering by the wind.”',
 0, 0),

-- 1844-10-14
(@voyage_id, '1844-10-14 00:00:00', 'Pacific Ocean (at sea)', -35.3333, -81.1667,
 'under double-reefed topsails; mending sail',
 'strong winds',
 'SSE',
 'SW by S',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Under double (reefed) topsails. Lat 35°20′ S, Long 81°10′ W.',
 0, 0),

-- 1844-10-15
(@voyage_id, '1844-10-15 00:00:00', 'Pacific Ocean (at sea)', -35.5167, -82.9667,
 'bending staysails; made all sail at 6 AM; mending spanker',
 'strong winds moderating',
 'SSE',
 'W by S',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Lat 35°31′ S, Long 82°58′ W.',
 0, 0),

-- 1844-10-16
(@voyage_id, '1844-10-16 00:00:00', 'Off Chile coast (made land)', -36.1500, -82.2500,
 'tacked; made land AM; mending sail',
 'light winds; light squalls of rain toward 3 AM',
 'SSW',
 'W by S (then SE by S after tacking)',
 JSON_ARRAY(JSON_OBJECT('name','unknown ship','home_port',NULL,'heading','SE')),
 JSON_OBJECT(),
 'Saw a ship heading into the S & E; tacked 6 PM to SE by S. “Made land” around 6 AM. Lat in log “56°09′” likely 36°09′ S; recorded here as −36.1500 with note. Long 82°15′ W.',
 0, 0),

-- 1844-10-17
(@voyage_id, '1844-10-17 00:00:00', 'Pacific Ocean (at sea)', -36.9667, -82.5500,
 'reefed/drafted topsails; gale at 2 AM; under reduced canvas',
 'strong SW winds; gale toward 2 AM',
 'SW',
 'E by S (later seen heading SW)',
 JSON_ARRAY(),
 JSON_OBJECT(),
 '“Draft the topsails”; under double-reefed topsail & foresail during gale; later noted ship heading SW. Lat “06°58′ S” likely 36°58′ S; captured here as −36.9667. Long 82°33′ W.',
 0, 0);


-- ───────────────────────────────────────────────────────────────
-- Seed: Events — November 1844
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id,
  date,
  location,
  latitude,
  longitude,
  activity,
  weather,
  wind_direction,
  course_direction,
  ships_encountered,
  whale_activity,
  notes,
  motivation_levels,
  casualties
) VALUES
-- 1844-11-09
(@voyage_id, '1844-11-09 00:00:00', 'Pacific Ocean (at sea)', -42.9667, -77.8333,
 'boiling oil; heavy seas; cooperage work',
 'strong WNW winds; heavy sea',
 'WNW',
 'SW by W; later North',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Finished boiling at 6 PM. Close-reefed fore and main topsails; wore ship at 6 AM heading north; later coopered oil. Lat 42°58′ S, Long 77°50′ W.',
 0, 0),

-- 1844-11-10
(@voyage_id, '1844-11-10 00:00:00', 'Pacific Ocean (at sea)', -43.2333, -78.2667,
 'sailing; gale; reduced sail; close-reefed main',
 'strong WNW winds; gales; overcast',
 'WNW',
 'N then SW by 6 PM',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Wore ship at 2 PM and 6 PM; took in fore & mizzen topsails during gale; captain likely still unwell. Lat 43°14′ S, Long 78°16′ W.',
 0, 0),

-- 1844-11-11
(@voyage_id, '1844-11-11 00:00:00', 'Pacific Ocean (at sea)', -42.6833, -78.3333,
 'gale from WNW; steering W by N; stowing down oil',
 'gale moderating; overcast',
 'WNW (then SW)',
 'W by N',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Braking out and stowing oil during variable gales; finished around noon. Lat 42°41′ S, Long 78°20′ W.',
 0, 0),

-- 1844-11-12
(@voyage_id, '1844-11-12 00:00:00', 'Pacific Ocean (at sea)', -41.9500, -78.6667,
 'gale; clearing ship; saw right whale; no success',
 'strong gale; more moderate later',
 'SW',
 'WNW',
 JSON_ARRAY(),
 JSON_OBJECT('type','right whale','action','boats lowered','result','no success'),
 'Right whale seen 11 AM; boats lowered, no catch. Lat 41°57′ S, Long 78°40′ W.',
 0, 0),

-- 1844-11-17
(@voyage_id, '1844-11-17 00:00:00', 'Pacific Ocean (at sea)', -41.3333, -79.1500,
 'boiling oil; wore ship; gale toward morning',
 'overcast; strong breeze; thick and squally later',
 'W',
 'N and W (then SSW at 5 PM)',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'All hands employed boiling; wore ship 5 PM heading SSW; gale toward morning. Lat 41°20′ S, Long 79°09′ W.',
 0, 0),

-- 1844-11-18
(@voyage_id, '1844-11-18 00:00:00', 'Pacific Ocean (at sea)', -41.4667, -79.3667,
 'boiling and coopering; gale of wind; wore ship',
 'gale; thick and rainy early; clearer AM',
 'WNW (later SSW)',
 'SW by W; later W by N',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Finished boiling 6 PM; wore ship 6 AM; clearer weather 11 AM. Lat 41°28′ S, Long 79°22′ W.',
 0, 0),

-- 1844-11-19
(@voyage_id, '1844-11-19 00:00:00', 'Pacific Ocean (at sea)', -41.4000, -79.4167,
 'stowing down oil; wore ship; fine weather AM',
 'gale early; overcast; fine later',
 'W (later)',
 'NW by W (then SSW)',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Finished stowing oil around 6 PM; fine weather by morning. Lat 41°24′ S, Long 79°25′ W.',
 0, 0),

-- 1844-11-20
(@voyage_id, '1844-11-20 00:00:00', 'Pacific Ocean (at sea)', -42.0167, -79.7500,
 'stowing oil; shortened sail; resumed sailing ENE',
 'fine weather; squally 2 AM; moderate AM',
 'WNW',
 'SW by S (later ENE)',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Finished slowing/stowing oil at 3 PM; squally night; made sail 8 AM. Lat 42°01′ S, Long 79°45′ W.',
 0, 0);


-- ───────────────────────────────────────────────────────────────
-- Seed: Events — December 1844
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id,
  date,
  location,
  latitude,
  longitude,
  activity,
  weather,
  wind_direction,
  course_direction,
  ships_encountered,
  whale_activity,
  notes,
  motivation_levels,
  casualties
) VALUES
-- 1844-12-12
(@voyage_id, '1844-12-12 00:00:00', 'Pacific Ocean (at sea)', -41.8667, -79.8333,
 'close-reefed main topsail; heavy squalls; wore ship',
 'strong SW winds; heavy squalls; squally',
 'SW',
 'NNW; later NW by N',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Close-reefed main topsail; later wind noted W by W. Lat 41°52′ S, Long 79°50′ W.',
 0, 0),

-- 1844-12-14
(@voyage_id, '1844-12-14 00:00:00', 'Pacific Ocean (at sea)', -41.1333, -79.3333,
 'wore ship; made all prudent sail',
 'overcast',
 'W',
 'SW by S; then S; then NW; AM E by S',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Multiple wearings through the evening; all prudent sail made by morning. Lat 41°08′ S, Long 79°20′ W.',
 0, 0),

-- 1844-12-15
(@voyage_id, '1844-12-15 00:00:00', 'Pacific Ocean (at sea)', -41.2000, -79.0000,
 'wore ship; reduced sail; made all sail at daylight',
 'strong S winds; clear; later fine weather',
 'S',
 'E by S; later SW; then ENE',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Shortened sail during the night; made all sail in fine weather. Lat 41°12′ S, Long 79°00′ W.',
 0, 0),

-- 1844-12-16
(@voyage_id, '1844-12-16 00:00:00', 'Pacific Ocean (at sea)', -41.4667, -78.2500,
 'examined dead whale; wore ship; made all sail',
 'fine weather',
 'S by E',
 'E by S; evening ESW',
 JSON_ARRAY(),
 JSON_OBJECT('type','sperm whale','action','found dead; examined by boat','result','too decayed to use'),
 'Saw a dead sperm whale to windward; too far gone to save. Lat 41°28′ S, Long 78°15′ W.',
 0, 0),

-- 1844-12-19
(@voyage_id, '1844-12-19 00:00:00', 'Pacific Ocean (at sea)', -41.3000, -79.0833,
 'set fore topsail; continued under way',
 'squally and thick',
 'WSW',
 'NW by N; later NW',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Squally throughout; fore topsail set in the morning. Lat 41°18′ S, Long 79°05′ W.',
 0, 0),

-- 1844-12-21
(@voyage_id, '1844-12-21 00:00:00', 'Pacific Ocean (at sea)', -39.0000, -79.5000,
 'moderated; made sail; steering NE',
 'strong SW wind easing; squally 4 AM; fine by 6 AM',
 'SW (then WSW)',
 'NW (PM); NE (AM)',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Latitude minutes unclear in log (“39″ ?? S”). Stored as 39°00′ S; Long 79°30′ W.',
 0, 0),

-- 1844-12-22
(@voyage_id, '1844-12-22 00:00:00', 'Pacific Ocean (at sea)', -39.7500, -78.4167,
 'shortened sail; wore ship twice; strong winds and thick overcast',
 'strong NW winds; thick and overcast',
 'NW',
 'NE by W (under all drawing); later N by E; then W by S; AM NE by S',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Multiple wearings through the night and morning. Lat 39°45′ S, Long 78°25′ W.',
 0, 0),

-- 1844-12-23
(@voyage_id, '1844-12-23 00:00:00', 'Pacific Ocean (at sea)', -38.1500, -78.3333,
 'saw merchant vessel; wore ship several times; made prudent sail',
 'strong NW winds; thick and rainy; light winds later',
 'NW (then W)',
 'NE by N; later SW; WNW; AM NW by N',
 JSON_ARRAY(JSON_OBJECT('name','merchant vessel','home_port',NULL,'heading','E & S')),
 JSON_OBJECT(),
 'Sighted a merchant ship steering into the E & S. Lat 38°09′ S, Long 78°20′ W.',
 0, 0),

-- 1844-12-24
(@voyage_id, '1844-12-24 00:00:00', 'Pacific Ocean (at sea)', -34.3333, -78.8167,
 'shortened then made prudent sail; blackfish seen',
 'fine weather becoming light',
 'WSW',
 'NW (PM); AM WNW',
 JSON_ARRAY(),
 JSON_OBJECT('type','blackfish','action','sighted','result',NULL),
 'All hands employed (ratlines/ropes referenced). Blackfish seen ~8 AM. Lat 34°20′ S, Long 78°49′ W.',
 0, 0),

-- 1844-12-25 (date inferred from sequence)
(@voyage_id, '1844-12-25 00:00:00', 'Off Masafuera (Alejandro Selkirk) — bearing W by SW by compass', -34.7500, -81.0833,
 'made all sail; steering NNW; land bearing W by SW',
 'fine',
 '',
 'NNW',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Undated fragment placed by sequence between Dec 24 and Dec 30: “Saw Massafuero bearing W by SW by compass.” Lat 34°45′ S, Long 81°05′ W.',
 0, 0),

-- 1844-12-30
(@voyage_id, '1844-12-30 00:00:00', 'Island of Masafuera (Alejandro Selkirk) in sight', -33.7500, -80.7667,
 'shortened to the wind; stood off at 4 AM; island ~10 miles SE by end',
 'fine, overcast with light showers',
 '',
 'NW by N (then W by N to the wind; AM off the island)',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Island bearing N by W at 6 PM (~30 miles); at 4 AM stood off for the island; ended with island bearing SE ~10 miles. Coords approximate for vicinity of Masafuera.',
 0, 0),

-- 1844-12-31
(@voyage_id, '1844-12-31 00:00:00', 'Off Masafuera (Alejandro Selkirk)', -33.3000, -81.1667,
 'laying off and on with two boats; loaded twice; later tacked SSW',
 'light SW squalls',
 'SW',
 'WNW then S; later SSW',
 JSON_ARRAY(JSON_OBJECT('name','unknown ship','home_port',NULL,'relative_bearing','to SW at 8–10 AM')),
 JSON_OBJECT(),
 'Working boats with the tide; shortened sail; later a ship seen to the SW; tacked SSW. Lat 33°18′ S, Long 81°10′ W (by reckoning).',
 0, 0);


-- ───────────────────────────────────────────────────────────────
-- Seed: Events — January 1845
-- ───────────────────────────────────────────────────────────────
INSERT INTO events (
  voyage_id,
  date,
  location,
  latitude,
  longitude,
  activity,
  weather,
  wind_direction,
  course_direction,
  ships_encountered,
  whale_activity,
  notes,
  motivation_levels,
  casualties
) VALUES
-- 1845-01-01
(@voyage_id, '1845-01-01 00:00:00', 'Pacific Ocean (off Masafuera vicinity)', -33.5833, -81.0000,
 'spoke ships; wore ship; general sailing',
 'fine; overcast later',
 'S to W',
 'W & S; later SW',
 JSON_ARRAY(
   JSON_OBJECT('name','Mary Frasier','home_port','New Bedford','type','bark'),
   JSON_OBJECT('name','[unclear: “Obid”/“Obed” Michael]','home_port',NULL)
 ),
 JSON_OBJECT(),
 '“Spoak the book Mary Frasier of New Bedford”; also spoke “[Obid] Michael” (unclear). Lat 33°35′ S, Long 81°00′ W by reckoning.',
 0, 0),

-- 1845-01-02
(@voyage_id, '1845-01-02 00:00:00', 'Pacific Ocean', -33.7500, -81.3333,
 'in company with [Obid/Obed Michael]; shortened then made all sail',
 'overcast',
 'SSE',
 'SW',
 JSON_ARRAY(JSON_OBJECT('name','[unclear: “Obid”/“Obed” Michael]','home_port',NULL,'status','in sight')),
 JSON_OBJECT(),
 'Longitude garbled in log (“24/20”); stored as ~81°20′ W (−81.3333) with note.',
 0, 0),

-- 1845-01-04
(@voyage_id, '1845-01-04 00:00:00', 'Pacific Ocean', -34.1500, -84.9167,
 'boiling; finished 4 AM; made prudent sail',
 'light breeze ENE; calm in evening',
 'ENE',
 'SW by W',
 JSON_ARRAY(),
 JSON_OBJECT(),
 'Saw a “lark” (bird) heading SE. Lat 34°09′ S, Long 84°55′ W.',
 0, 0),

-- 1845-01-08
(@voyage_id, '1845-01-08 00:00:00', 'Pacific Ocean', -34.1667, -86.1667,
 'chased finback; shortened to the wind; coopering oil',
 'fine',
 '',
 'SW; then ESW; AM WSW',
 JSON_ARRAY(),
 JSON_OBJECT('type','finback','action','sighted & steered for','result','no capture'),
 'Longitude in log appears “56°10′ W”; interpreted as 86°10′ W. Coopered oil in AM.',
 0, 0),

-- 1845-01-09
(@voyage_id, '1845-01-09 00:00:00', 'Pacific Ocean', -34.0667, -86.0833,
 'lowered for sperm whales; took one alongside; commenced cutting',
 'light winds SE',
 'SE',
 'WSW; then W by E while shortening sail',
 JSON_ARRAY(),
 JSON_OBJECT('type','sperm whale','action','lowered; struck; alongside','result','taken'),
 'Lowered 3 PM; by 6 had him alongside; commenced cutting (whale sketch noted). Lat 34°04′ S, Long 86°05′ W (reckoning).',
 0, 0),

-- 1845-01-10
(@voyage_id, '1845-01-10 00:00:00', 'Pacific Ocean', -34.0167, -87.0000,
 'finished cutting; made sail in morning',
 'calm',
 '',
 '',
 JSON_ARRAY(),
 JSON_OBJECT('type','sperm whale','action','cutting in','result','finished'),
 'Finished cutting about 2–4 AM; made sail 7 AM. Log latitude reads “24°01′ S” but context suggests 34°01′ S; stored as −34.0167 with note. Long 87°00′ W.',
 0, 0),

-- 1845-01-11
(@voyage_id, '1845-01-11 00:00:00', 'Pacific Ocean', -34.1833, -87.2000,
 'boiling; made sail at daylight; wore ship 11 AM heading ENE',
 'light NW winds',
 'NW',
 'WSW; AM ENE after wearing',
 JSON_ARRAY(),
 JSON_OBJECT('type','sperm whale','action','trying out oil','result','processing'),
 'Laid with main yard aback during boiling; resumed sail 6 AM; wore ship 11 AM. Lat 34°11′ S, Long 87°12′ W.',
 0, 0);
