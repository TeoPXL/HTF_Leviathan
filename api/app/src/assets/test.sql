-- ───────────────────────────────────────────────────────────────
-- Seed: Ships
-- ───────────────────────────────────────────────────────────────
INSERT INTO ships (ship_name, home_port)
VALUES ('John Howland', 'New Bedford')
ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);

-- Capture ship id
SET @ship_id := LAST_INSERT_ID();

-- ───────────────────────────────────────────────────────────────
-- Seed: Voyages (John Howland, N. L. Cannon)
-- ───────────────────────────────────────────────────────────────
INSERT INTO voyages (
  ship_id, starting_port, destination_port, captain_name, crew_count, casualties, start_date
) VALUES (
  @ship_id, 'New Bedford', 'Sea of Okhotsk via New Zealand & Guam', 'Nathaniel Lorins Cannon', 0, 0, '1852-12-21 00:00:00'
);

-- Capture voyage id
SET @voyage_id := LAST_INSERT_ID();

-- ───────────────────────────────────────────────────────────────
-- Seed: Events (selected, structured from the log transcription)
-- Dates use 00:00:00 time since precise times weren’t given.
-- ───────────────────────────────────────────────────────────────
INSERT INTO events
(voyage_id, date, location, activity, weather, wind_direction, course_direction, ships_encountered, whale_activity, notes, motivation_levels, casualties)
VALUES
-- 1852 Pacific, Society Islands
(@voyage_id, '1852-12-21 00:00:00', 'Rurutu Island', 'went ashore; provisioning', 'fine', '', '', JSON_ARRAY(), JSON_OBJECT(), 'Margin also mentions Rarotonga; laying off & on.', 0, 0),
(@voyage_id, '1852-12-24 00:00:00', 'Pacific Ocean (en route)', 'routine sailing', '', '', '', JSON_ARRAY(), JSON_OBJECT(), 'Man up main rigging; flag hoisted.', 0, 0),
(@voyage_id, '1852-12-25 00:00:00', 'Pacific Ocean (at sea)', 'Christmas at sea', '', '', '', JSON_ARRAY(), JSON_OBJECT(), '“Dish water for turkey sea pie.”', 0, 0),
(@voyage_id, '1852-12-26 00:00:00', 'Pacific Ocean (at sea)', 'whaling attempt', '', '', '', JSON_ARRAY(), JSON_OBJECT('type','sperm whales','action','lowered and chased','result','no success'), 'PM activity.', 0, 0),
(@voyage_id, '1852-12-29 00:00:00', 'Pacific Ocean (at sea)', 'sighted ship; whale breach', '', '', '', JSON_ARRAY(JSON_OBJECT('name','unknown','home_port',NULL)), JSON_OBJECT('type','unknown','action','breach sighted','result',NULL), 'Ship steering south; breach at 6 o’clock.', 0, 0),

-- 1853 January toward New Zealand
(@voyage_id, '1853-01-02 00:00:00', 'Pacific Ocean (bound to New Zealand)', 'sailing; chased blackfish', 'fine breezes', '', '', JSON_ARRAY(), JSON_OBJECT('type','blackfish','action','chased','result','no success'), 'Waist boat got a billfish.', 0, 0),
(@voyage_id, '1853-01-03 00:00:00', 'Pacific Ocean (ESE winds)', 'whaling attempt', 'strong breezes', 'ESE', 'full and by', JSON_ARRAY(), JSON_OBJECT('type','sperm whales','action','lowered','result','no success'), '', 0, 0),
(@voyage_id, '1853-01-05 00:00:00', 'Near Coal Island/Rock (NZ, uncertain)', 'whaling attempt', 'strong wind', 'ESE', 'on the wind', JSON_ARRAY(), JSON_OBJECT('type','sperm whales','action','lowered','result','lost / not seen'), 'Margin “Colus Island/Rock” likely Coal Island.', 0, 0),
(@voyage_id, '1853-01-06 00:00:00', 'Off New Zealand coast', 'spoke ships', 'fine', '', 'steering into the land',
  JSON_ARRAY(JSON_OBJECT('name','Hope','home_port','New Bedford'), JSON_OBJECT('name','Zane','home_port','Fairhaven')),
  JSON_OBJECT(), '', 0, 0),
(@voyage_id, '1853-01-07 00:00:00', 'Between Coal Island & Coal Rock (NZ)', 'spoke ships; whaling attempt', 'fine', 'SSE', 'between islets',
  JSON_ARRAY(JSON_OBJECT('name','Hope','home_port','New Bedford'), JSON_OBJECT('name','Omega','home_port','Nantucket')),
  JSON_OBJECT('type','sperm whales','action','lowered','result','too fast to catch'), 'Three sails in sight.', 0, 0),
(@voyage_id, '1853-01-09 00:00:00', 'Off New Zealand', 'spoke ship', 'fine', '', 'S by W',
  JSON_ARRAY(JSON_OBJECT('name','Commodore Morris','home_port','Falmouth')), JSON_OBJECT(), '', 0, 0),
(@voyage_id, '1853-01-10 00:00:00', 'Off New Zealand (French Rock in sight)', 'coasting', 'fine', '', 'S by W', JSON_ARRAY(), JSON_OBJECT(), 'French Rock in sight (local feature).', 0, 0),
(@voyage_id, '1853-01-14 00:00:00', 'Off New Zealand', 'coasting; calm PM', 'fair; calm PM', '', 'steering in to the land', JSON_ARRAY(), JSON_OBJECT(), '', 0, 0),

-- New Zealand bay stop (pilot/anchor)
(@voyage_id, '1853-01-16 00:00:00', 'Bay “Muckeenet/Muckennut” (NZ, uncertain)', 'took pilot; anchored', '', '', '', 
  JSON_ARRAY(
    JSON_OBJECT('name','Albion','home_port','Fairhaven'),
    JSON_OBJECT('name','Columbia','home_port','Sag Harbor')
  ),
  JSON_OBJECT(), 'Sunday entry inferred from sequence.', 0, 0),
(@voyage_id, '1853-01-17 00:00:00', 'Same bay (NZ)', 'at anchor', '', '', '', JSON_ARRAY(JSON_OBJECT('name','Trident','home_port','New Bedford')), JSON_OBJECT(), '', 0, 0),
(@voyage_id, '1853-01-18 00:00:00', 'Same bay (NZ)', 'getting and stowing water', '', '', '', JSON_ARRAY(), JSON_OBJECT(), '', 0, 0),
(@voyage_id, '1853-01-19 00:00:00', 'Same bay (NZ)', 'arrivals noted', '', '', '', JSON_ARRAY(JSON_OBJECT('name','Clinton','home_port',NULL), JSON_OBJECT('name','Lisbon','home_port',NULL)), JSON_OBJECT(), 'Names uncertain in transcription.', 0, 0),
(@voyage_id, '1853-01-20 00:00:00', 'Same bay (NZ)', 'arrival noted', '', '', '', JSON_ARRAY(JSON_OBJECT('name','[unclear name]','home_port','Fairhaven')), JSON_OBJECT(), 'Fairhaven vessel; name unclear.', 0, 0),
(@voyage_id, '1853-01-25 00:00:00', 'New Zealand', 'weighed anchor; departed', '', '', '', JSON_ARRAY(JSON_OBJECT('name','incoming ship','home_port',NULL)), JSON_OBJECT(), '', 0, 0),
(@voyage_id, '1853-01-26 00:00:00', 'New Zealand', 'put back (gear issue)', '', '', '', JSON_ARRAY(), JSON_OBJECT(), 'Put back “through [gear] that belong to other ship”.', 0, 0),

-- February/March pelagic + Micronesia
(@voyage_id, '1853-02-03 00:00:00', 'Pacific Ocean', 'spoke ship', '', '', '', JSON_ARRAY(JSON_OBJECT('name','Alpha','home_port','Nantucket')), JSON_OBJECT('type','sperm','action','reported cargo','result','Alpha with one'), '', 0, 0),
(@voyage_id, '1853-03-05 00:00:00', 'Pacific Ocean', 'whaling — took whale', '', '', '', JSON_ARRAY(), JSON_OBJECT('type','sperm whale','action','struck and took alongside','barrels',40,'result','successful'), 'Margin “40 barrals”.', 0, 0),
(@voyage_id, '1853-03-17 00:00:00', 'Strong’s Island (Kosrae)', 'made land', 'strong winds', 'NE', 'W of W', JSON_ARRAY(), JSON_OBJECT(), '', 0, 0),
(@voyage_id, '1853-03-24 00:00:00', 'Guam', 'laying off & on; captain ashore', 'strong breezes', 'NE', 'N by W', JSON_ARRAY(), JSON_OBJECT(), '', 0, 0),
(@voyage_id, '1853-03-25 00:00:00', 'Off Guam', 'departed north; spoke ship', '', '', 'northbound', JSON_ARRAY(JSON_OBJECT('name','Napoleon','home_port','Nantucket')), JSON_OBJECT(), 'Captain came off at night; stood north.', 0, 0),
(@voyage_id, '1853-03-26 00:00:00', 'W. Pacific (northbound)', 'spoke ship', 'strong wind', 'N', 'northbound', JSON_ARRAY(JSON_OBJECT('name','Nimrod','home_port','New Bedford')), JSON_OBJECT(), 'Nimrod bound north.', 0, 0),

-- April–May Sea of Okhotsk approach
(@voyage_id, '1853-04-16 00:00:00', 'Okhotsk approach (ice)', 'ice encountered; whale sightings', 'very light', '', '', JSON_ARRAY(JSON_OBJECT('name','two ships in sight','home_port',NULL)), JSON_OBJECT('type','humpback / unknown','action','sightings','result','unknown'), 'Ice all around; whale at night of unknown kind.', 0, 0),
(@voyage_id, '1853-04-18 00:00:00', 'Strait (Okhotsk entrance)', 'lowered for right whales', 'fine; light PM', '', '', JSON_ARRAY(), JSON_OBJECT('type','right whales','action','lowered','result','no success'), 'Made the land; in the strait.', 0, 0),
(@voyage_id, '1853-05-10 00:00:00', 'Sea of Okhotsk', 'spoke ship; whaling attempt', '', 'N', '', JSON_ARRAY(JSON_OBJECT('name','Coral','home_port','New Bedford','captain','Taber')), JSON_OBJECT('type','bowhead (context)','action','lowered','result','no success'), 'Ice in sight.', 0, 0),
(@voyage_id, '1853-05-11 00:00:00', 'Sea of Okhotsk', 'spoke ships; whales in company', 'pleasant', 'N', 'to the wind',
  JSON_ARRAY(
    JSON_OBJECT('name','Northern Light','home_port','Fairhaven','captain','Stewart'),
    JSON_OBJECT('name','Coral','home_port','New Bedford')
  ),
  JSON_OBJECT('type','bowhead','action','sightings / lowered','result','no success'), 'Northern Light boiling two whales.', 0, 0),
(@voyage_id, '1853-05-13 00:00:00', 'Sea of Okhotsk', 'took a whale; cut in', 'fine', '', 'N & W',
  JSON_ARRAY(), JSON_OBJECT('type','bowhead','action','rose whales; got one; cut in','barrels',155,'result','successful'),
  'On deck by 11 o’clock.', 0, 0),
(@voyage_id, '1853-05-14 00:00:00', 'Sea of Okhotsk', 'boiling; spoke ships', 'pleasant', '', 'WSW then N by E',
  JSON_ARRAY(JSON_OBJECT('name','Three Brothers','home_port','Nantucket'), JSON_OBJECT('name','Isaac Howland','home_port','New Bedford','captain','West')),
  JSON_OBJECT('type','bowhead','action','trying out','result','processing'), '', 0, 0),
(@voyage_id, '1853-05-16 00:00:00', 'Sea of Okhotsk', 'spoke barque Vernon; stowing oil', 'pleasant', 'N', 'N & W',
  JSON_ARRAY(JSON_OBJECT('name','Vernon (barque)','home_port','New Bedford','captain','Little')),
  JSON_OBJECT('type','bowhead','action','stowing down','result','processing'), 'Plenty of ice; two sails in sight.', 0, 0),

-- Late May–June bowhead run
(@voyage_id, '1853-05-31 00:00:00', 'Sea of Okhotsk (land in sight)', 'took a whale; alongside at night', 'fine; light', 'NE', 'southward',
  JSON_ARRAY(), JSON_OBJECT('type','bowhead','action','AM struck & lost line; PM struck & got one','barrels',145,'result','successful'), '', 0, 0),
(@voyage_id, '1853-06-01 00:00:00', 'Sea of Okhotsk', 'cutting in; ships in sight', 'fine; light', 'N', '', JSON_ARRAY(JSON_OBJECT('name','several ships','home_port',NULL)), JSON_OBJECT('type','bowhead','action','cutting in','result','processing'), '', 0, 0),
(@voyage_id, '1853-06-02 00:00:00', 'Sea of Okhotsk', 'boiling; lost whale', 'fine', 'N', 'S & W',
  JSON_ARRAY(JSON_OBJECT('name','ship in sight','home_port',NULL)),
  JSON_OBJECT('type','bowhead','action','west boat struck; larboard got slow; lost in sea','result','lost'), '', 0, 0),
(@voyage_id, '1853-06-04 00:00:00', 'Sea of Okhotsk', 'boiling; chasing whales; spoke Mercury', 'fine; light', '', '',
  JSON_ARRAY(JSON_OBJECT('name','Mercury','home_port','New Bedford')),
  JSON_OBJECT('type','bowhead','action','chasing','result','no success'), '', 0, 0),

-- July coastal / inshore whaling
(@voyage_id, '1853-07-01 00:00:00', 'Sea of Okhotsk', 'stowing down 100 bbl; spoke ships', 'strong winds', 'NW', '',
  JSON_ARRAY(JSON_OBJECT('name','John & Edward','home_port','New Bedford'), JSON_OBJECT('name','Sarah','home_port','Mattapoisett')),
  JSON_OBJECT('type','bowhead','action','stowing','barrels',100,'result','on board'), 'Saw a bark steering NE.', 0, 0),
(@voyage_id, '1853-07-06 00:00:00', 'Sea of Okhotsk (near land)', 'spoke vessels; whales seen', 'fine', '', 'for land',
  JSON_ARRAY(JSON_OBJECT('name','Charleston Packet (barque)','home_port','New Bedford'), JSON_OBJECT('name','Nimrod','home_port','New Bedford')),
  JSON_OBJECT('type','bowhead','action','sightings','result',NULL), '“Chelpached” likely Charleston Packet.', 0, 0),
(@voyage_id, '1853-07-10 00:00:00', 'Sea of Okhotsk (close inshore)', 'lowered for whales; spoke Fellow', 'fine; strong wind later', '', '',
  JSON_ARRAY(JSON_OBJECT('name','Fellow (bark)','home_port','Stonington')),
  JSON_OBJECT('type','bowhead','action','lowered; “full in”','result','no success indicated'), '', 0, 0),
(@voyage_id, '1853-07-15 00:00:00', 'Sea of Okhotsk (inshore)', 'took whale; cutting in', 'fine', '', '',
  JSON_ARRAY(JSON_OBJECT('name','Callao (prob.)','home_port','New Bedford')),
  JSON_OBJECT('type','bowhead','action','struck and got one; cut in','result','successful'), 'Name “Calito/Coal” likely Callao.', 0, 0),
(@voyage_id, '1853-07-22 00:00:00', 'Sea of Okhotsk', 'took whale; finished cutting', 'fine', '', '',
  JSON_ARRAY(JSON_OBJECT('name','South America','home_port','New Bedford')),
  JSON_OBJECT('type','bowhead','action','bow boat struck and got one','result','successful'), '', 0, 0),
(@voyage_id, '1853-07-29 00:00:00', 'Sea of Okhotsk (land in sight)', 'lowered; line cut', 'fine; strong wind later', '', '',
  JSON_ARRAY(JSON_OBJECT('name','two ships ranging off','home_port',NULL)),
  JSON_OBJECT('type','bowhead','action','waist boat struck; line cut by second iron','result','lost'), 'Double reef topsail.', 0, 0),
(@voyage_id, '1853-07-30 00:00:00', 'Sea of Okhotsk', 'took whale; finished cutting', 'strong wind easing by 11', '', '',
  JSON_ARRAY(), JSON_OBJECT('type','bowhead','action','larboard boat struck; got one','result','successful'), '', 0, 0),

-- August anchorage & stowing
(@voyage_id, '1853-08-01 00:00:00', 'Sea of Okhotsk (inshore/anchorage)', 'boiling; weighed and re-anchored', 'fine; little thick AM', '', 'stood in / anchored',
  JSON_ARRAY(JSON_OBJECT('name','three ships (one at anchor)','home_port',NULL)),
  JSON_OBJECT('type','bowhead','action','boiling','result','processing'), '', 0, 0),
(@voyage_id, '1853-08-03 00:00:00', 'Sea of Okhotsk (anchorage)', 'stowed down 140 bbl; spoke John & Edward', 'fine', '', '',
  JSON_ARRAY(JSON_OBJECT('name','John & Edward','home_port','New Bedford')),
  JSON_OBJECT('type','bowhead','action','stowing','barrels',140,'result','on board'), '', 0, 0),
(@voyage_id, '1853-08-05 00:00:00', 'Sea of Okhotsk (inshore; calm later)', 'chasing whales; spoke Florida', 'fine; calm later', '', '',
  JSON_ARRAY(JSON_OBJECT('name','Florida','home_port','Fairhaven')),
  JSON_OBJECT('type','bowhead','action','many whales around; chasing','result','no success'), '', 0, 0);
