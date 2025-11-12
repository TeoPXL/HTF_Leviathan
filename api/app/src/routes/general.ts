// routes/general.ts
import { Elysia } from "elysia"
import {eq, sql, ne} from "drizzle-orm"

export const generalRoutes = (app: Elysia, db: any) => {
    return app
        .get("/v1/status", async () => {
            try {
                // Minimal query to check MySQL connection
                await db.execute(sql`SELECT 1 AS status`)
                return { status: 'healthy' }
            } catch (error) {
                return { status: 'damaged' }
            }
        })
}