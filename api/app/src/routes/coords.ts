// src/routes/voyagesRoutes.ts
import { Elysia, t } from "elysia"
import { drizzle } from "drizzle-orm/mysql2"
import { voyages, events, ships } from "../db/schema"
import { eq, asc } from "drizzle-orm"
import { z } from 'zod';

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
        })
        .post("/v1/voyages/:id/chat", async ({ params, body }) => {
            const { id } = params;
            const { message, currentEventIndex } = body;

            // Validation
            const chatSchema = z.object({
                message: z.string().min(1).max(500),
                currentEventIndex: z.number().min(0)
            });

            try {
                chatSchema.parse({ message, currentEventIndex });
            } catch (e) {
                return { error: "Invalid request parameters" };
            }

            try {
                // Fetch voyage details
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

                // Fetch all events for this voyage
                const voyageEvents = await db
                    .select()
                    .from(events)
                    .where(eq(events.voyageId, Number(id)))
                    .orderBy(asc(events.date));

                if (!voyageEvents.length) return { error: "No events found" };

                // ✅ Filter events up to current position with bounds checking
                const eventIndex = Math.floor(currentEventIndex);
                if (eventIndex < 0 || eventIndex >= voyageEvents.length) {
                    return { error: "Current position is out of voyage bounds" };
                }
                const pastEvents = voyageEvents.slice(0, eventIndex + 1);

                // Build context for AI
                const voyage = voyageData[0].voyage;
                const ship = voyageData[0].ship;
                const captainName = voyage.captainName || "Captain";
                const shipName = ship?.shipName || "the ship";
                const currentDate = pastEvents[pastEvents.length - 1]?.date || voyage.startDate;

                const context = `You are ${captainName}, captain of the ship "${shipName}" in the year ${new Date(voyage.startDate).getFullYear()}.
Voyage: ${voyage.startingPort} → ${voyage.destinationPort}
Current Date: ${new Date(currentDate).toLocaleDateString('en-GB', { day: 'numeric', month: 'long', year: 'numeric' })}

Events that have occurred on this voyage so far:
${pastEvents.map((e, i) => `${i + 1}. ${new Date(e.date).toLocaleDateString()}: ${e.activity}${e.weather ? ` - Weather: ${e.weather}` : ''} : ''}`).join('\n')}

IMPORTANT: You must ONLY discuss events that have already happened. Do NOT mention future events. Respond in the voice of a 19th-century sea captain: concise, nautical, commanding but fair. Use period-appropriate language. Keep responses under 3 sentences.`;

                // Call OpenAI API (using fetch to avoid extra dependencies)
                const response = await fetch('https://api.openai.com/v1/chat/completions', {
                    method: 'POST',
                    headers: {
                        'Authorization': `Bearer ${Bun.env.OPENAI_API_KEY}`,
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        model: 'gpt-4o-mini',
                        messages: [
                            { role: 'system', content: context },
                            { role: 'user', content: message }
                        ],
                        max_tokens: 150,
                        temperature: 0.6,
                        presence_penalty: 0.1,
                    }),
                });

                if (!response.ok) {
                    const error = await response.json();
                    throw new Error(`OpenAI API error: ${response.status} - ${error.error?.message}`);
                }

                const data = await response.json();
                const aiResponse = data.choices[0]?.message?.content?.trim() || "No response from captain.";

                return {
                    response: aiResponse,
                    timestamp: new Date().toISOString(),
                };

            } catch (error) {
                console.error("Chat error:", error);
                return { error: "Captain is currently unavailable." };
            }
        }, {
            body: t.Object({
                message: t.String(),
                currentEventIndex: t.Number(),
            })
        })

    return app
}