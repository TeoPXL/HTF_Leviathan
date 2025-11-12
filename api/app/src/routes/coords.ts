// src/routes/voyagesRoutes.ts
import { Elysia, t } from "elysia"
import { drizzle } from "drizzle-orm/mysql2"
import { voyages, events, ships } from "../db/schema"
import { eq, asc } from "drizzle-orm"

export const voyagesRoutes = (app: Elysia, db: ReturnType<typeof drizzle>) => {
    app.get("/v1/voyages-geo", async () => {
        try {
            // 1️⃣ Fetch all events with voyage info
            const rows = await db
                .select({
                    voyageId: voyages.id,
                    shipId: voyages.shipId,
                    shipName: ships.shipName,
                    startingPort: voyages.startingPort,
                    destinationPort: voyages.destinationPort,
                    eventId: events.id,
                    eventDate: events.date,
                    latitude: events.latitude,
                    longitude: events.longitude,
                })
                .from(events)
                .leftJoin(voyages, eq(events.voyageId, voyages.id))
                .leftJoin(ships, eq(voyages.shipId, ships.id))
                .orderBy(asc(events.date)) // sort events chronologically

            // 2️⃣ Group events by voyage
            const voyageMap: Record<number, typeof rows> = {}
            rows.forEach((row) => {
                if (!voyageMap[row.voyageId as any]) voyageMap[row.voyageId as any] = []
                voyageMap[row.voyageId as any].push(row)
            })

            // 3️⃣ Convert grouped events to GeoJSON Features
            const features = Object.values(voyageMap).map((rows) => {
                const firstEvent = rows[0]
                const coordinates = rows.map((r) => [r.longitude, r.latitude])

                return {
                    type: "Feature",
                    properties: {
                        id: `voyage-${firstEvent.voyageId}`,
                        name: `${firstEvent.startingPort || "Unknown"} → ${firstEvent.destinationPort || "Unknown"}`,
                        shipName: firstEvent.shipName,
                        color: "#" + Math.floor(Math.random() * 16777215).toString(16),
                        feature_id: `voyage-${firstEvent.voyageId}-0`,
                        coordinates: coordinates[0] || [0, 0], // reference point
                    },
                    geometry: {
                        type: "MultiLineString",
                        coordinates: [coordinates], // full path of all events
                    },
                }
            })

            // 4️⃣ Return full GeoJSON
            return {
                type: "FeatureCollection",
                name: "voyages",
                crs: { type: "name", properties: { name: "urn:ogc:def:crs:OGC:1.3:CRS84" } },
                features,
            }
        } catch (error) {
            console.error("Error fetching voyages geo:", error)
            return { error: "Failed to fetch voyages GeoJSON" }
        }
    }, {
        query: t.Object({}) // optional query parameters later
    })
    // src/routes/voyagesRoutes.ts (add this inside your route definition)
    .get("/v1/voyages/:id/details", async ({ params: { id } }) => {
        try {
            const voyageData = await db
                .select({
                    voyage: voyages,
                    ship: ships,
                })
                .from(voyages)
                .leftJoin(ships, eq(voyages.shipId, ships.id))
                .where(eq(voyages.id, Number(id)))
                .limit(1);

            if (!voyageData.length) return { error: "Voyage not found" };

            const voyageEvents = await db
                .select()
                .from(events)
                .where(eq(events.voyageId, Number(id)))
                .orderBy(asc(events.date));

            return {
                ...voyageData[0],
                events: voyageEvents,
            };
        } catch (error) {
            console.error("Error fetching voyage details:", error);
            return { error: "Failed to fetch voyage details" };
        }
    });

    return app
}
