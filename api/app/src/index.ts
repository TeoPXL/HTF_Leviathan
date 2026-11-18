import { Elysia } from "elysia"
import { swagger } from "@elysiajs/swagger"
import mysql from "mysql2/promise"
import { drizzle } from "drizzle-orm/mysql2"
import { generalRoutes } from "./routes/general"
import { chaosMiddleware } from "./middleware/chaos"
import { setupDatabase } from "./db/connect"
import {voyagesRoutes} from "./routes/coords"

// Drizzle database instance
let db: ReturnType<typeof drizzle>

// Initialize the database and start the server
(async () => {
    try {
        // Set up the database with migrations
        db = await setupDatabase()

        // Create the Elysia app
        const app = new Elysia()
            .use(swagger())
            .use(chaosMiddleware()) // Add chaos middleware for delays and errors
            .get("/health", () => "Healthy")

        // Pass the db & logger to the routes
        voyagesRoutes(app, db)
        generalRoutes(app, db)

        // Start the server
        const server = app.listen(3000)

        console.log(
            `🚀 API is running at ${server.server?.hostname}:${server.server?.port}`
        )

        // Handle graceful shutdown
        process.on("SIGINT", async () => {
            console.log("🔄 Closing database connection...")
            // Close the pool connection (assuming db.client has an end() method)
            await (db.$client as mysql.Pool).end()
            console.log("✅ Database connection closed. Shutting down.")
            process.exit(0)
        })

    } catch (error) {
        console.error("❌ Server initialization failed:", error)
        process.exit(1)
    }
})()