import { sql } from "drizzle-orm"
import {
    mysqlTable,
    varchar,
    int,
    datetime,
    text,
    boolean,
    unique,
} from "drizzle-orm/mysql-core"

/* ──────────────────────────────────────────────────────────────── */
/* Ships Table */
/* ──────────────────────────────────────────────────────────────── */

export const ships = mysqlTable("ships", {
    id: int("id").primaryKey().autoincrement(),
    shipName: varchar("ship_name", { length: 255 }).notNull().unique(),
    homePort: varchar("home_port", { length: 255 }),
})

/* ──────────────────────────────────────────────────────────────── */
/* Voyages Table */
/* ──────────────────────────────────────────────────────────────── */

export const voyages = mysqlTable("voyages", {
    id: int("id").primaryKey().autoincrement(),
    shipId: int("ship_id")
        .notNull()
        .references(() => ships.id, { onDelete: "cascade" }),
    startingPort: varchar("starting_port", { length: 255 }),
    destinationPort: varchar("destination_port", { length: 255 }),
    captainName: varchar("captain_name", { length: 255 }).notNull(),
    crewCount: int("crew_count").default(0),
    casualties: int("casualties").default(0),
    startDate: datetime("start_date").notNull(),
})

/* ──────────────────────────────────────────────────────────────── */
/* Events Table */
/* ──────────────────────────────────────────────────────────────── */

export const events = mysqlTable("events", {
    id: int("id").primaryKey().autoincrement(),
    voyageId: int("voyage_id")
        .notNull()
        .references(() => voyages.id, { onDelete: "cascade" }),
    date: datetime("date").notNull(),
    location: varchar("location", { length: 255 }).notNull(),
    activity: varchar("activity", { length: 255 }).notNull(),
    weather: varchar("weather", { length: 255 }).default(""),
    windDirection: varchar("wind_direction", { length: 255 }).default(""),
    courseDirection: varchar("course_direction", { length: 255 }).default(""),
    shipsEncountered: text("ships_encountered").default(""), // JSON or comma-separated list
    whaleActivity: text("whale_activity").default(""),
    notes: text("notes").default(""),
    motivationLevels: int("motivation_levels").default(0),
    casualties: int("casualties").default(0),
})
